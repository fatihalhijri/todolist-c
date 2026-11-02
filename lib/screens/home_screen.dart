import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_filter.dart';
import '../services/task_storage.dart';
import '../widgets/edit_task_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/filter_bar.dart';
import '../widgets/task_counter.dart';
import '../widgets/task_input.dart';
import '../widgets/task_list.dart';

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
  TaskFilter _filter = TaskFilter.all;

  // Tugas yang tampil sesuai filter. where() membuat daftar baru, jadi
  // _tasks (data asli yang disimpan) tidak ikut berubah.
  List<Task> get _visibleTasks => _tasks.where(_filter.matches).toList();

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

  void _showMessage(String message, {SnackBarAction? action}) {
    // ScaffoldMessenger mengatur SnackBar untuk seluruh aplikasi.
    // hideCurrentSnackBar agar SnackBar lama tidak antre saat muncul beruntun.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: action,
          // SnackBar yang punya tombol aksi secara bawaan tidak hilang
          // sendiri; persist: false membuatnya tetap hilang setelah beberapa
          // detik.
          persist: false,
        ),
      );
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
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) return;

    setState(() {
      final current = _tasks[index];
      _tasks[index] = current.copyWith(isDone: !current.isDone);
    });
    _saveTasks();
  }

  Future<void> _editTask(Task task) async {
    // showDialog menampilkan dialog dan menunggu sampai ditutup. Hasilnya
    // adalah nilai yang dikirim lewat Navigator.pop di dalam dialog.
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => EditTaskDialog(initialTitle: task.title),
    );
    if (!mounted || newTitle == null || newTitle == task.title) return;

    final index = _tasks.indexWhere((t) => t.id == task.id);
    // Berjaga-jaga jika tugas sudah terhapus selama dialog terbuka.
    if (index == -1) return;

    setState(() {
      _tasks[index] = _tasks[index].copyWith(title: newTitle);
    });
    _saveTasks();
  }

  void _deleteTask(Task task) {
    // Posisi diingat dulu supaya "Batalkan" bisa mengembalikan tugas ke
    // tempat semula. Tugas dan posisinya ditangkap oleh fungsi onPressed
    // di bawah, jadi tidak perlu disimpan di variabel State.
    final index = _tasks.indexWhere((t) => t.id == task.id);
    setState(() {
      _tasks.removeAt(index);
    });
    _showMessage(
      'Tugas "${task.title}" dihapus',
      action: SnackBarAction(
        label: 'Batalkan',
        onPressed: () => _restoreTask(task, index),
      ),
    );
    _saveTasks();
  }

  void _restoreTask(Task task, int index) {
    setState(() {
      // Jika daftar sudah berubah sejak dihapus, index bisa melebihi
      // panjang daftar; clamp menjaganya tetap di rentang yang sah.
      _tasks.insert(index.clamp(0, _tasks.length), task);
    });
    _saveTasks();
  }

  /// Isi bagian bawah: daftar tugas, atau pesan kosong yang sesuai.
  Widget _buildTaskArea() {
    if (_tasks.isEmpty) return const EmptyState();

    final visibleTasks = _visibleTasks;
    if (visibleTasks.isEmpty) {
      // Cabang `all` sebenarnya tidak terjadi (sudah ditangani di atas),
      // tetapi switch pada enum wajib menangani semua nilai.
      return switch (_filter) {
        TaskFilter.all => const EmptyState(),
        TaskFilter.active => const EmptyState(
          icon: Icons.filter_list_off,
          message: 'Tidak ada tugas yang belum selesai',
        ),
        TaskFilter.done => const EmptyState(
          icon: Icons.filter_list_off,
          message: 'Tidak ada tugas yang selesai',
        ),
      };
    }

    return TaskList(
      tasks: visibleTasks,
      onToggle: _toggleTask,
      onDelete: _deleteTask,
      onEdit: _editTask,
    );
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
                if (_tasks.isNotEmpty) ...[
                  TaskCounter(tasks: _tasks),
                  FilterBar(
                    selected: _filter,
                    onChanged: (filter) => setState(() => _filter = filter),
                  ),
                ],
                // Expanded memberi daftar semua sisa tinggi layar di bawah input.
                Expanded(child: _buildTaskArea()),
              ],
            ),
    );
  }
}
