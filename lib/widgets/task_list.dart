import 'package:flutter/material.dart';

import '../models/task.dart';
import 'task_tile.dart';

/// Daftar tugas yang bisa digulir.
///
/// Dipisah dari HomeScreen supaya build() di sana tetap pendek. Widget ini
/// hanya menampilkan; semua perubahan data dikirim ke induk lewat callback.
class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  final List<Task> tasks;
  final ValueChanged<Task> onToggle;
  final ValueChanged<Task> onDelete;
  final ValueChanged<Task> onEdit;

  @override
  Widget build(BuildContext context) {
    // ListView.builder hanya membuat baris yang terlihat di layar,
    // jadi tetap ringan walaupun tugasnya banyak.
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskTile(
          task: task,
          onToggle: () => onToggle(task),
          onDelete: () => onDelete(task),
          onEdit: () => onEdit(task),
        );
      },
    );
  }
}
