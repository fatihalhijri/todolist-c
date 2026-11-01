import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/empty_state.dart';
import '../widgets/task_input.dart';
import '../widgets/task_tile.dart';

/// Halaman utama: memegang daftar tugas dan semua aksi terhadapnya.
///
/// StatefulWidget dipakai karena daftar tugas berubah selama aplikasi berjalan.
/// Widget-nya sendiri tetap tidak berubah; data yang berubah disimpan di
/// kelas State (_HomeScreenState) di bawah.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Data hanya di memori; hilang saat aplikasi ditutup (disimpan di Tahap 2).
  final List<Task> _tasks = [];

  // setState memberi tahu Flutter bahwa data berubah, sehingga build()
  // dipanggil ulang dan layar menampilkan data terbaru.
  void _addTask(String title) {
    final now = DateTime.now();
    setState(() {
      // insert(0, ...) supaya tugas baru muncul paling atas.
      _tasks.insert(
        0,
        Task(
          id: now.microsecondsSinceEpoch.toString(),
          title: title,
          createdAt: now,
        ),
      );
    });
  }

  void _toggleTask(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      _tasks[index] = task.copyWith(isDone: !task.isDone);
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });

    // ScaffoldMessenger mengatur SnackBar untuk seluruh aplikasi.
    // hideCurrentSnackBar agar SnackBar lama tidak antre saat menghapus beruntun.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Tugas "${task.title}" dihapus')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      body: Column(
        children: [
          TaskInput(onSubmitted: _addTask),
          // Expanded memberi daftar semua sisa tinggi layar di bawah input.
          Expanded(
            child: _tasks.isEmpty
                ? const EmptyState()
                // ListView.builder hanya membuat baris yang terlihat di layar,
                // jadi tetap ringan walaupun tugasnya banyak.
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return TaskTile(
                        task: task,
                        onToggle: () => _toggleTask(task),
                        onDelete: () => _deleteTask(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
