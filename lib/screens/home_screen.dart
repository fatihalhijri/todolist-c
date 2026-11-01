import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_storage.dart';
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
  final _storage = TaskStorage();
  List<Task> _tasks = [];
  bool _isLoading = true;

  // initState dipanggil sekali saat halaman pertama kali dibuat, cocok untuk
  // memulai pemuatan data. initState tidak boleh async, jadi pemuatannya
  // dipindah ke fungsi tersendiri.
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    // await = tunggu sampai data selesai dibaca, tanpa membekukan layar.
    final tasks = await _storage.loadTasks();
    // Selama menunggu, halaman bisa saja sudah ditutup. mounted == false
    // artinya halaman sudah tidak ada, jadi setState tidak boleh dipanggil.
    if (!mounted) return;
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  /// Menyimpan daftar terbaru. Tidak di-await oleh pemanggilnya karena layar
  /// sudah diperbarui lebih dulu; penyimpanan berjalan di belakang.
  Future<void> _saveTasks() async {
    try {
      await _storage.saveTasks(_tasks);
    } on Exception {
      if (!mounted) return;
      _showMessage('Gagal menyimpan tugas');
    }
  }

  void _showMessage(String message) {
    // ScaffoldMessenger mengatur SnackBar untuk seluruh aplikasi.
    // hideCurrentSnackBar agar SnackBar lama tidak antre saat muncul beruntun.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

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
    _saveTasks();
  }

  void _toggleTask(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      _tasks[index] = task.copyWith(isDone: !task.isDone);
    });
    _saveTasks();
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
    _showMessage('Tugas "${task.title}" dihapus');
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      // Selama memuat, seluruh isi diganti indikator loading supaya pengguna
      // tidak sempat menambah tugas yang nanti tertimpa hasil pemuatan.
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TaskInput(onSubmitted: _addTask),
                // Expanded memberi daftar semua sisa tinggi layar di bawah input.
                Expanded(
                  child: _tasks.isEmpty
                      ? const EmptyState()
                      // ListView.builder hanya membuat baris yang terlihat di
                      // layar, jadi tetap ringan walaupun tugasnya banyak.
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
