import 'package:flutter/material.dart';

import '../models/task.dart';

/// Teks ringkas berapa tugas yang belum selesai.
class TaskCounter extends StatelessWidget {
  const TaskCounter({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    // Data turunan: tidak disimpan, cukup dihitung ulang dari daftar setiap
    // kali build. where() menyaring tanpa mengubah daftar aslinya.
    final remaining = tasks.where((task) => !task.isDone).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$remaining dari ${tasks.length} tugas belum selesai',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
