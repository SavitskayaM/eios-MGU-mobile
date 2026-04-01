import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';

class SemesterPicker extends StatefulWidget {
  const SemesterPicker({super.key});

  @override
  State<SemesterPicker> createState() => _SemesterPickerState();
}

class _SemesterPickerState extends State<SemesterPicker> {
  String _selectedYear = '2024-2025';
  int _selectedPeriod = 1;

  final List<String> _years = [
    '2024-2025',
    '2023-2024',
    '2022-2023',
    '2021-2022',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выбор семестра'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Учебный год',
              border: OutlineInputBorder(),
            ),
            initialValue: _selectedYear,
            items: _years.map((year) {
              return DropdownMenuItem(
                value: year,
                child: Text(year),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedYear = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Период',
              border: OutlineInputBorder(),
            ),
            initialValue: _selectedPeriod,
            items: const [
              DropdownMenuItem(value: 1, child: Text('1 семестр (Осень)')),
              DropdownMenuItem(value: 2, child: Text('2 семестр (Весна)')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedPeriod = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            final provider = Provider.of<StudentProvider>(context, listen: false);
            provider.loadSemester(_selectedYear, _selectedPeriod);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Загрузить'),
        ),
      ],
    );
  }
}
