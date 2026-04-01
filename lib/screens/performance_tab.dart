import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../models/student.dart';
import 'discipline_detail_screen.dart';

class PerformanceTab extends StatefulWidget {
  const PerformanceTab({super.key});

  @override
  State<PerformanceTab> createState() => _PerformanceTabState();
}

class _PerformanceTabState extends State<PerformanceTab> {
  String selectedSemester = '1 семестр';
  String selectedYear = '2025 - 2026';

  final List<String> semesters = ['1 семестр', '2 семестр'];
  final List<String> years = ['2025 - 2026', '2024 - 2025', '2023 - 2024'];

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        final disciplines = provider.disciplines;
        final student = provider.student;

        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF9575CD),
            ),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              // Заголовок с фильтрами
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E5F5),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF9575CD), width: 2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Мои дисциплины',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Color(0xFF9575CD)),
                          onPressed: () => provider.refreshData(),
                          tooltip: 'Обновить',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterButton(
                            value: selectedSemester,
                            items: semesters,
                            onChanged: (value) {
                              setState(() {
                                selectedSemester = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFilterButton(
                            value: selectedYear,
                            items: years,
                            onChanged: (value) {
                              setState(() {
                                selectedYear = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Факультет
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                width: double.infinity,
                child: Text(
                  student?.faculty.isNotEmpty ?? false 
                      ? student!.faculty 
                      : 'Факультет математики и информационных технологий',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Список дисциплин
              Expanded(
                child: disciplines.isEmpty
                    ? const Center(
                        child: Text(
                          'Загрузка данных...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF9575CD),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: disciplines.length,
                        itemBuilder: (context, index) {
                          return _buildDisciplineCard(disciplines[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterButton({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF9575CD), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9575CD)),
          style: const TextStyle(
            color: Color(0xFF9575CD),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDisciplineCard(Discipline discipline) {
    final percentage = discipline.percentage;
    
    Color getColor() {
      if (percentage >= 80) return const Color(0xFF66BB6A);
      if (percentage >= 60) return const Color(0xFF9575CD);
      return const Color(0xFFEF5350);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisciplineDetailScreen(discipline: discipline),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        discipline.name,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1976D2),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (discipline.totalScore > 0)
                        Text(
                          '${discipline.currentScore} / ${discipline.totalScore} баллов',
                          style: TextStyle(
                            fontSize: 13,
                            color: getColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF9575CD),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
