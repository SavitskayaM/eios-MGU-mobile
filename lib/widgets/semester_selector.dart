import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';

class SemesterSelector extends StatelessWidget {
  const SemesterSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Выберите семестр',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Учебный год',
                    border: OutlineInputBorder(),
                  ),
                  value: '2024-2025',
                  items: const [
                    DropdownMenuItem(value: '2024-2025', child: Text('2024-2025')),
                    DropdownMenuItem(value: '2023-2024', child: Text('2023-2024')),
                    DropdownMenuItem(value: '2022-2023', child: Text('2022-2023')),
                  ],
                  onChanged: (value) {
                    // TODO: Сохранить выбор
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Период',
                    border: OutlineInputBorder(),
                  ),
                  value: 1,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('1 (Осень)')),
                    DropdownMenuItem(value: 2, child: Text('2 (Весна)')),
                  ],
                  onChanged: (value) {
                    // TODO: Сохранить выбор
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.refreshData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Загрузить данные'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
