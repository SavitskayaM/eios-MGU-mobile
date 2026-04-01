import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/student_provider.dart';
import '../models/student.dart';
import '../widgets/calendar_view.dart';
import '../screens/profile_tab_new.dart';
import '../screens/performance_tab.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() {
    print('🟢 MainScreen createState вызван');
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    print('🟢🟢🟢 MainScreen initState - начинаем загрузку');
    // Загружаем сразу
    Future.microtask(() {
      print('🟢 Вызываем loadStudentData');
      Provider.of<StudentProvider>(context, listen: false).loadStudentData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ЭИОС'),
        backgroundColor: const Color(0xFF9575CD),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final auth = Provider.of<AuthProvider>(context, listen: false);
              await auth.logout();
              if (!mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, _) {
          // Показываем статус загрузки
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(provider.loadingStatus),
                ],
              ),
            );
          }
          
          // Показываем вкладки когда загружено
          return IndexedStack(
            index: _selectedIndex,
            children: const [
              ProfileTab(),
              PerformanceTab(),
              TimetableTab(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Успеваемость'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Расписание'),
        ],
      ),
    );
  }
}

// Оценки
class GradesTab extends StatelessWidget {
  const GradesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        final disciplines = provider.disciplines;
        
        print('🎓 GradesTab: disciplines.length = ${disciplines.length}');
        
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Column(
          children: [
            // Заголовок
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD), // Светло-голубой фон
                border: Border(
                  bottom: BorderSide(color: Color(0xFF90CAF9), width: 2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.school, color: Color(0xFF90CAF9), size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Мои дисциплины',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ),
                  // Кнопка обновления
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFF90CAF9)),
                    onPressed: () => provider.refreshData(),
                    tooltip: 'Обновить',
                  ),
                ],
              ),
            ),
            
            // Список дисциплин
            Expanded(
              child: _buildDisciplinesList(disciplines, provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDisciplinesList(List<Discipline> disciplines, StudentProvider provider) {
    if (disciplines.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school_outlined, size: 80, color: Color(0xFF90CAF9)),
            const SizedBox(height: 24),
            const Text(
              'Дисциплины не найдены',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Данные могут появиться позже',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.refreshData(),
              icon: const Icon(Icons.refresh),
              label: const Text('Обновить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF90CAF9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: disciplines.length,
      itemBuilder: (context, index) {
        final discipline = disciplines[index];
        final percentage = discipline.percentage;
        
        // Цвета для оценок
        Color getColor() {
          if (percentage >= 80) return const Color(0xFF66BB6A); // Зелёный
          if (percentage >= 60) return const Color(0xFF90CAF9); // Голубой
          return const Color(0xFFEF5350); // Красный
        }
        
        String getGrade() {
          if (percentage >= 85) return 'Отлично';
          if (percentage >= 70) return 'Хорошо';
          if (percentage >= 60) return 'Удовлетворительно';
          return 'Неудовлетворительно';
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Можно добавить детали дисциплины
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название дисциплины
                  Text(
                    discipline.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Преподаватель
                  if (discipline.teacher.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            discipline.teacher,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  
                  // Баллы и прогресс
                  Row(
                    children: [
                      // Текущие баллы
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Баллы',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${discipline.currentScore}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: getColor(),
                                  ),
                                ),
                                Text(
                                  ' / ${discipline.totalScore}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Процент и оценка
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: getColor().withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: getColor(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            getGrade(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Прогресс-бар
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(getColor()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Расписание
class TimetableTab extends StatelessWidget {
  const TimetableTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        final lessons = provider.todayLessons;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      provider.setSelectedDate(
                        provider.selectedDate.subtract(const Duration(days: 1)),
                      );
                    },
                  ),
                  Row(
                    children: [
                      Text(
                        '${provider.selectedDate.day}.${provider.selectedDate.month}.${provider.selectedDate.year}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CalendarView(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      provider.setSelectedDate(
                        provider.selectedDate.add(const Duration(days: 1)),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: lessons.isEmpty
                  ? const Center(child: Text('Занятий нет'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: lessons.length,
                      itemBuilder: (context, index) {
                        final lesson = lessons[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(lesson.time, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                    Chip(label: Text(lesson.type), backgroundColor: Colors.blue.withValues(alpha: 0.2)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(lesson.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                if (lesson.teacher.isNotEmpty) Text('Преподаватель: ${lesson.teacher}'),
                                if (lesson.room.isNotEmpty) Text('Аудитория: ${lesson.room}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
