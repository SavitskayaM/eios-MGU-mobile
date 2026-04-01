import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/api_service.dart';

class StudentProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  Student? _student;
  String? _studentCode;
  String? _email;
  String? _birthDate;
  List<Discipline> _disciplines = [];
  Map<DateTime, List<Lesson>> _timetable = {};
  DateTime _selectedDate = DateTime.now();
  int _selectedSubgroup = 1;
  bool _isLoading = false;
  String _loadingStatus = '';

  Student? get student => _student;
  String? get studentCode => _studentCode;
  String? get email => _email;
  String? get birthDate => _birthDate;
  List<Discipline> get disciplines => _disciplines;
  DateTime get selectedDate => _selectedDate;
  int get selectedSubgroup => _selectedSubgroup;
  bool get isLoading => _isLoading;
  String get loadingStatus => _loadingStatus;

  List<Lesson> get todayLessons {
    final key = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return _timetable[key] ?? [];
  }

  Future<void> loadStudentData() async {
    _isLoading = true;
    _loadingStatus = 'Загрузка данных пользователя...';
    notifyListeners();

    try {
      // 1. Загружаем User и ПОКАЗЫВАЕМ ВЕСЬ JSON
      print('📥 Запрос User...');
      final userResult = await _api.getUser();
      print('📦 СЫРОЙ ОТВЕТ User: $userResult');
      
      if (userResult['success'] == true) {
        // ВЫВОДИМ ВЕСЬ JSON ОТВЕТ!
        print('📦 ПОЛНЫЙ JSON User:');
        print(const JsonEncoder.withIndent('  ').convert(userResult['data']));
        
        final userData = userResult['data'];
        final fio = userData['FIO'] ?? 'Студент';
        final photo = userData['Photo'];
        final photoUrl = photo != null ? (photo['UrlSource'] ?? photo['UrlMedium'] ?? photo['UrlSmall'] ?? '') : '';
        
        _student = Student(name: fio, group: '', faculty: '', photoUrl: photoUrl);
        _studentCode = userData['StudentCod']?.toString();
        _email = userData['Email']?.toString();
        
        // Форматируем дату рождения
        final birthDateStr = userData['BirthDate']?.toString();
        if (birthDateStr != null && birthDateStr.isNotEmpty) {
          try {
            final date = DateTime.parse(birthDateStr);
            _birthDate = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
          } catch (e) {
            _birthDate = birthDateStr;
          }
        }
        
        print('✅ Использовал FIO: $fio');
        print('📸 URL фото: $photoUrl');
        print('🔑 StudentCod: $_studentCode');
        print('📧 Email: $_email');
        print('🎂 BirthDate: $_birthDate');
        print('👤 UserName: ${userData['UserName']}');
      }

      // 2. Семестр - сначала пробуем текущий, потом конкретные
      _loadingStatus = 'Загрузка дисциплин...';
      notifyListeners();
      
      print('📥 Запрос текущего семестра с selector=current...');
      var semesterResult = await _api.getCurrentSemester();
      
      // selector=current возвращает ОДИН объект семестра, а не массив!
      if (semesterResult['success'] == true) {
        final semesterData = semesterResult['data'];
        final recordBooks = semesterData['RecordBooks'] as List? ?? [];
        
        print('📚 Текущий семестр: ${semesterData['Year']} период ${semesterData['Period']}');
        print('📚 RecordBooks: ${recordBooks.length} шт.');
        
        if (recordBooks.isEmpty) {
          // Текущий семестр пустой - пробуем конкретные годы
          print('⚠️ Текущий семестр пустой, пробуем 2024 - 2025 период 1...');
          semesterResult = await _api.getStudentSemester('2024-2025', 1);
        }
      } else {
        // Ошибка получения текущего семестра
        print('⚠️ Ошибка getCurrentSemester, пробуем 2024-2025 период 1...');
        semesterResult = await _api.getStudentSemester('2024-2025', 1);
      }
      
      if (semesterResult['success'] != true || 
          (semesterResult['data']['RecordBooks'] as List? ?? []).isEmpty) {
        print('⚠️ Пробуем 2022-2023 период 2...');
        semesterResult = await _api.getStudentSemester('2022-2023', 2);
      }
      
      if (semesterResult['success'] != true || 
          (semesterResult['data']['RecordBooks'] as List? ?? []).isEmpty) {
        print('⚠️ Пробуем 2022-2023 период 1...');
        semesterResult = await _api.getStudentSemester('2022-2023', 1);
      }
      
      if (semesterResult['success'] != true || 
          (semesterResult['data']['RecordBooks'] as List? ?? []).isEmpty) {
        print('⚠️ Пробуем 2021-2022 период 2...');
        semesterResult = await _api.getStudentSemester('2021-2022', 2);
      }
      
      // МАССОВЫЙ ПЕРЕБОР всех годов и периодов!
      if (semesterResult['success'] != true || 
          (semesterResult['data']['RecordBooks'] as List? ?? []).isEmpty) {
        print('🔍 МАССОВЫЙ ПЕРЕБОР: пробуем все годы с 2020 по 2026...');
        
        final years = [
          '2025-2026', '2024-2025', '2023-2024', '2022-2023',
          '2021-2022', '2020-2021', '2019-2020'
        ];
        
        bool found = false;
        for (final year in years) {
          for (final period in [1, 2]) {
            print('  🔎 Проверяем $year период $period...');
            final testResult = await _api.getStudentSemester(year, period);
            
            if (testResult['success'] == true) {
              final books = testResult['data']['RecordBooks'] as List? ?? [];
              if (books.isNotEmpty) {
                print('  ✅✅✅ НАШЛИ! $year период $period: ${books.length} зачёток!');
                semesterResult = testResult;
                found = true;
                break;
              }
            }
          }
          if (found) break;
        }
        
        if (!found) {
          print('❌ НЕ НАШЛИ дисциплины ни в одном семестре!');
        }
      }
      
      print('📦 Semester success: ${semesterResult['success']}');
      
      if (semesterResult['success'] == true) {
        print('📦 ПОЛНЫЙ JSON Semester:');
        print(const JsonEncoder.withIndent('  ').convert(semesterResult['data']));
        
        final semesterData = semesterResult['data'];
        _disciplines = [];
        
        final recordBooks = semesterData['RecordBooks'] as List? ?? [];
        print('📚 RecordBooks: ${recordBooks.length} шт.');
        
        if (recordBooks.isNotEmpty) {
          final firstBook = recordBooks[0];
          print('📗 Первая зачётка: ${firstBook.keys}');
          
          final faculty = firstBook['Faculty'] ?? '';
          print('🏛️ Факультет: $faculty');
          
          if (_student != null) {
            _student = Student(
              name: _student!.name,
              group: '',
              faculty: faculty,
              photoUrl: _student!.photoUrl,
            );
          }
          
          final disciplinesList = firstBook['Disciplines'] as List? ?? [];
          print('📖 Дисциплин в зачётке: ${disciplinesList.length}');
          
          for (var disc in disciplinesList) {
            final disciplineId = disc['Id'] ?? 0;
            final disciplineName = disc['Title'] ?? 'Дисциплина';
            
            print('  - $disciplineName (ID: $disciplineId)');
            
            // Загружаем баллы для этой дисциплины
            int currentScore = 0;
            int totalScore = 100;
            
            if (disciplineId > 0) {
              final ratingResult = await _api.getStudentRatingPlan(disciplineId);
              if (ratingResult['success'] == true) {
                final ratingData = ratingResult['data'];
                
                // Выводим JSON только для первой дисциплины
                if (_disciplines.isEmpty) {
                  print('📦 JSON v2/StudentRatingPlan:');
                  print(const JsonEncoder.withIndent('  ').convert(ratingData));
                }

                // v2 API: Sections → ControlDots → Mark → Ball
                final sections = ratingData['Sections'] as List? ?? [];
                for (var section in sections) {
                  final controlDots = section['ControlDots'] as List? ?? [];
                  for (var dot in controlDots) {
                    final mark = dot['Mark'];
                    if (mark != null && mark['Ball'] != null) {
                      currentScore += (mark['Ball'] as num).toInt();
                    }
                  }
                }
                print('    Баллы: $currentScore/$totalScore (Sections: ${sections.length})');
              }
            }
            
            _disciplines.add(Discipline(
              id: disciplineId,
              name: disciplineName,
              teacher: '',
              totalScore: totalScore,
              currentScore: currentScore,
            ));
          }
          print('✅ Загружено дисциплин: ${_disciplines.length}');
        } else {
          print('⚠️ RecordBooks пустой массив! Проверьте семестр.');
        }
        notifyListeners();
      } else {
        print('❌ Семестр не загрузился!');
      }

      // 3. Расписание - загружаем 4 недели (с 10 февраля по 9 марта)
      await Future.delayed(const Duration(milliseconds: 500));
      _loadingStatus = 'Загрузка расписания...';
      notifyListeners();
      
      // Начинаем с 10 февраля 2026 (2 недели назад от 23-го)
      final startDate = DateTime(2026, 2, 10);
      
      print('📅 Загружаем расписание с ${startDate.day}.${startDate.month} (4 недели = 28 дней)...');
      
      // Загружаем 28 дней
      for (int dayOffset = 0; dayOffset < 28; dayOffset++) {
        final date = startDate.add(Duration(days: dayOffset));
        final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        
        print('📥 Запрос расписания на $dateStr...');
        final result = await _api.getStudentTimeTable(dateStr);
        
        if (result['success'] == true) {
          final items = result['data'] as List? ?? [];
          final key = DateTime(date.year, date.month, date.day);
          _timetable[key] = [];
          
          for (var item in items) {
            final group = item['Group'] ?? '';
            
            if (_student != null && group.isNotEmpty && _student!.group.isEmpty) {
              _student = Student(
                name: _student!.name,
                group: group,
                faculty: _student!.faculty,
                photoUrl: _student!.photoUrl,
              );
            }
            
            final timeTable = item['TimeTable'];
            final lessons = timeTable['Lessons'] as List? ?? [];
            
            for (var lesson in lessons) {
              final lessonNumber = lesson['Number'] ?? 0;
              final disciplines = lesson['Disciplines'] as List? ?? [];
              
              for (var discipline in disciplines) {
                final times = [
                  '08:00 - 09:30',
                  '09:45 - 11:15',
                  '11:35 - 13:05',
                  '13:20 - 14:50',
                  '15:00 - 16:30',
                  '16:40 - 18:10',
                  '18:15 - 19:45',
                  '19:50 - 21:20',
                ];
                final time = lessonNumber > 0 && lessonNumber <= times.length 
                    ? times[lessonNumber - 1] 
                    : '';
                
                _timetable[key]!.add(Lesson(
                  time: time,
                  name: discipline['Title'] ?? '',
                  teacher: discipline['Teacher']?['FIO'] ?? '',
                  room: discipline['Auditorium']?['Number'] ?? '',
                  type: 'Занятие',
                ));
              }
            }
          }
          
          if (_timetable[key]!.isNotEmpty) {
            print('✅ ${date.day}.${date.month}: ${_timetable[key]!.length} пар');
          } else {
            print('⚪ ${date.day}.${date.month}: выходной');
          }
        }
        
        // Небольшая пауза между запросами
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      print('📊 Всего загружено дней с расписанием: ${_timetable.keys.where((k) => _timetable[k]!.isNotEmpty).length}');
      
      // Устанавливаем selectedDate на 23 февраля (понедельник)
      _selectedDate = DateTime(2026, 2, 23);
      notifyListeners();

      _isLoading = false;
      _loadingStatus = '';
      notifyListeners();
      
    } catch (e, stack) {
      print('❌ ОШИБКА: $e');
      print('Stack: $stack');
      _isLoading = false;
      _loadingStatus = 'Ошибка загрузки данных';
      notifyListeners();
      // НЕ загружаем демо данные - показываем ошибку
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    
    // Если для этой даты нет расписания - загружаем
    final key = DateTime(date.year, date.month, date.day);
    if (!_timetable.containsKey(key)) {
      _loadDateTimetable(date);
    }
  }

  // Загрузить расписание для конкретной даты
  Future<void> _loadDateTimetable(DateTime date) async {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    print('📥 Подгружаем расписание на $dateStr...');
    
    final result = await _api.getStudentTimeTable(dateStr);
    
    if (result['success'] == true) {
      final items = result['data'] as List? ?? [];
      final key = DateTime(date.year, date.month, date.day);
      _timetable[key] = [];
      
      for (var item in items) {
        final group = item['Group'] ?? '';
        
        if (_student != null && group.isNotEmpty && _student!.group.isEmpty) {
          _student = Student(
            name: _student!.name,
            group: group,
            faculty: _student!.faculty,
            photoUrl: _student!.photoUrl,
          );
        }
        
        final timeTable = item['TimeTable'];
        final lessons = timeTable['Lessons'] as List? ?? [];
        
        for (var lesson in lessons) {
          final lessonNumber = lesson['Number'] ?? 0;
          final disciplines = lesson['Disciplines'] as List? ?? [];
          
          for (var discipline in disciplines) {
            final times = [
              '08:00 - 09:30',
              '09:45 - 11:15',
              '11:35 - 13:05',
              '13:20 - 14:50',
              '15:00 - 16:30',
              '16:40 - 18:10',
              '18:15 - 19:45',
              '19:50 - 21:20',
            ];
            final time = lessonNumber > 0 && lessonNumber <= times.length 
                ? times[lessonNumber - 1] 
                : '';
            
            _timetable[key]!.add(Lesson(
              time: time,
              name: discipline['Title'] ?? '',
              teacher: discipline['Teacher']?['FIO'] ?? '',
              room: discipline['Auditorium']?['Number'] ?? '',
              type: 'Занятие',
            ));
          }
        }
      }
      
      if (_timetable[key]!.isNotEmpty) {
        print('✅ Подгружено ${date.day}.${date.month}: ${_timetable[key]!.length} пар');
      } else {
        print('⚪ ${date.day}.${date.month}: выходной');
      }
      
      notifyListeners();
    }
  }

  void setSelectedSubgroup(int subgroup) {
    _selectedSubgroup = subgroup;
    notifyListeners();
  }

  Future<void> refreshData() async {
    await loadStudentData();
  }

  // Загрузить конкретный семестр
  Future<void> loadSemester(String year, int period) async {
    _isLoading = true;
    _loadingStatus = 'Загрузка семестра $year ($period период)...';
    notifyListeners();

    try {
      print('📥 Запрос семестра $year, период $period...');
      final semesterResult = await _api.getStudentSemester(year, period);
      
      if (semesterResult['success'] == true) {
        print('📦 ПОЛНЫЙ JSON Semester:');
        print(const JsonEncoder.withIndent('  ').convert(semesterResult['data']));
        
        final semesterData = semesterResult['data'];
        _disciplines = [];
        
        final recordBooks = semesterData['RecordBooks'] as List? ?? [];
        print('📚 RecordBooks: ${recordBooks.length} шт.');
        
        if (recordBooks.isNotEmpty) {
          final firstBook = recordBooks[0];
          print('📗 Первая зачётка: ${firstBook.keys}');
          
          final faculty = firstBook['Faculty'] ?? '';
          print('🏛️ Факультет: $faculty');
          
          if (_student != null) {
            _student = Student(
              name: _student!.name,
              group: _student!.group,
              faculty: faculty,
              photoUrl: _student!.photoUrl,
            );
          }
          
          final disciplinesList = firstBook['Disciplines'] as List? ?? [];
          print('📖 Дисциплин в зачётке: ${disciplinesList.length}');
          
          for (var disc in disciplinesList) {
            final disciplineId = disc['Id'] ?? 0;
            final disciplineName = disc['Title'] ?? 'Дисциплина';
            
            print('  - $disciplineName (ID: $disciplineId)');
            
            // Загружаем баллы для этой дисциплины
            int currentScore = 0;
            int totalScore = 100;
            
            if (disciplineId > 0) {
              final ratingResult = await _api.getStudentRatingPlan(disciplineId);
              if (ratingResult['success'] == true) {
                final ratingData = ratingResult['data'];
                // v2 API: Sections → ControlDots → Mark → Ball
                final sections = ratingData['Sections'] as List? ?? [];
                for (var section in sections) {
                  final controlDots = section['ControlDots'] as List? ?? [];
                  for (var dot in controlDots) {
                    final mark = dot['Mark'];
                    if (mark != null && mark['Ball'] != null) {
                      currentScore += (mark['Ball'] as num).toInt();
                    }
                  }
                }
                print('    Баллы: $currentScore/$totalScore (Sections: ${sections.length})');
              }
            }
            
            _disciplines.add(Discipline(
              id: disciplineId,
              name: disciplineName,
              teacher: '',
              totalScore: totalScore,
              currentScore: currentScore,
            ));
          }
          print('✅ Загружено дисциплин: ${_disciplines.length}');
        } else {
          print('⚠️ RecordBooks пустой массив! Семестр $year период $period не содержит дисциплин.');
        }
        
        _isLoading = false;
        _loadingStatus = '';
        notifyListeners();
      } else {
        print('❌ Семестр не загрузился!');
        _isLoading = false;
        _loadingStatus = 'Ошибка загрузки семестра';
        notifyListeners();
      }
    } catch (e, stack) {
      print('❌ ОШИБКА loadSemester: $e');
      print('Stack: $stack');
      _isLoading = false;
      _loadingStatus = 'Ошибка загрузки';
      notifyListeners();
    }
  }
}
