import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  void _showStudentDetails(BuildContext context, StudentProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF9575CD),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Информация о студенте',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Детали
            _buildDetailRow(
              icon: Icons.school_outlined,
              label: 'Факультет',
              value: provider.student?.faculty ?? 'Не указан',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.menu_book_outlined,
              label: 'Направление',
              value: 'Информатика и вычислительная техника',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.badge_outlined,
              label: 'Номер зачётки',
              value: provider.studentCode ?? 'Не указан',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: provider.email ?? 'Не указан',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.cake_outlined,
              label: 'Дата рождения',
              value: provider.birthDate ?? 'Не указана',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.account_balance_outlined,
              label: 'Университет',
              value: 'МГУ им. Н.П. Огарёва',
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF9575CD), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF424242),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        final student = provider.student;
        if (student == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Фото как обложка на весь верх
              Stack(
                children: [
                  // Фото пользователя на весь верх
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFB39DDB),
                          Color(0xFF9575CD),
                        ],
                      ),
                    ),
                    child: student.photoUrl.isNotEmpty
                        ? Image.network(
                            student.photoUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('❌ Ошибка загрузки фото: $error');
                              print('📸 URL: ${student.photoUrl}');
                              return Container(
                                color: const Color(0xFF9575CD),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: const Color(0xFF9575CD),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  // Градиент затемнения снизу
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ФИО поверх фото
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 4,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        if (student.group.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Группа ${student.group}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              // Информация
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (student.faculty.isNotEmpty)
                      _buildInfoCard(
                        icon: Icons.school,
                        title: 'Факультет',
                        value: student.faculty,
                      ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _showStudentDetails(context, provider),
                      borderRadius: BorderRadius.circular(12),
                      child: _buildInfoCard(
                        icon: Icons.badge,
                        title: 'Студент',
                        value: 'МГУ им. Н.П. Огарёва',
                        showArrow: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    bool showArrow = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1BEE7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF9575CD), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF424242),
                  ),
                ),
              ],
            ),
          ),
          if (showArrow)
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF9575CD),
              size: 24,
            ),
        ],
      ),
    );
  }
}
