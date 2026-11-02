import 'package:flutter/material.dart';

import '../models/task.dart';

/// Satu baris tugas: checkbox dan judul, bisa digeser untuk dihapus.
///
/// Ketuk kotak centang untuk mengubah status; ketuk judul untuk mengedit.
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  final Task task;

  /// VoidCallback = fungsi tanpa parameter dan tanpa nilai kembali.
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Dismissible membuat anaknya bisa digeser keluar layar.
    // Key wajib unik per tugas, supaya Flutter tahu persis baris mana yang
    // dihapus; kalau memakai urutan (index), baris yang salah bisa ikut hilang.
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        color: colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      // ListTile + Checkbox terpisah (bukan CheckboxListTile), supaya
      // mengetuk judul bisa dipakai untuk edit, bukan ikut mencentang.
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          // Checkbox mengirim nilai baru, tapi kita cukup membalik status.
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? colorScheme.outline : null,
          ),
        ),
        onTap: onEdit,
      ),
    );
  }
}
