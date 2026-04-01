import 'package:flutter/material.dart';
import '../models/student.dart';

class DisciplineDetailScreen extends StatelessWidget {
  final Discipline discipline;

  const DisciplineDetailScreen({super.key, required this.discipline});

  @override
  Widget build(BuildContext context) {
    final percentage = discipline.percentage;

    // Определяем цвет и оценку
    Color getColor() {
      if (percentage >= 80) return const Color(0xFF66BB6A); // Зелёный
      if (percentage >= 60) return const Color(0xFF9575CD); // Лиловый
      return const Color(0xFFEF5350); // Красный
    }

    String getGrade() {
      if (percentage >= 85) return 'Отлично';
      if (percentage >= 70) return 'Хорошо';
      if (percentage >= 60) return 'Удовлетворительно';
      return 'Неудовлетворительно';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали дисциплины'),
        backgroundColor: const Color(0xFF9575CD),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок дисциплины
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFB39DDB),
                    Color(0xFF9575CD),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    discipline.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (discipline.teacher.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white70, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            discipline.teacher,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Оценка и баллы
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Текущие баллы
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Текущие баллы',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF424242),
                        ),
                      ),
                      Text(
                        '${discipline.currentScore} / ${discipline.totalScore}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: getColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Прогресс-бар
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      minHeight: 20,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(getColor()),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: getColor(),
                        ),
                      ),
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
                          getGrade(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: getColor(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Информация о дисциплине
                  _buildInfoCard(
                    icon: Icons.info_outline,
                    title: 'ID дисциплины',
                    value: discipline.id.toString(),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.check_circle_outline,
                    title: 'Максимальный балл',
                    value: discipline.totalScore.toString(),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.trending_up,
                    title: 'Набрано баллов',
                    value: discipline.currentScore.toString(),
                  ),

                  const SizedBox(height: 32),

                  // Рекомендации
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF9575CD).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Color(0xFF9575CD)),
                            SizedBox(width: 8),
                            Text(
                              'Рекомендация',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9575CD),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getRecommendation(percentage),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF9575CD), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
        ],
      ),
    );
  }

  String _getRecommendation(double percentage) {
    if (percentage >= 85) {
      return 'Отличная работа! Вы уверенно идёте к успешной сдаче дисциплины. Продолжайте в том же духе!';
    } else if (percentage >= 70) {
      return 'Хорошие результаты! Ещё немного усилий, и вы сможете получить отличную оценку.';
    } else if (percentage >= 60) {
      return 'Обратите внимание на пробелы в знаниях. Рекомендуется больше времени уделить изучению материала.';
    } else {
      return 'Критическая ситуация! Необходимо срочно обратиться к преподавателю и наверстать упущенное.';
    }
  }
}
