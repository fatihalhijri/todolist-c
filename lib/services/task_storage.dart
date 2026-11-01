import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

/// Menyimpan dan memuat daftar tugas di penyimpanan lokal HP.
///
/// Logika penyimpanan dipisah dari layar supaya HomeScreen cukup memanggil
/// `loadTasks` / `saveTasks` tanpa perlu tahu caranya, dan supaya bisa dites
/// sendiri.
class TaskStorage {
  // "_v1" memberi ruang jika suatu saat format datanya berubah.
  static const _tasksKey = 'tasks_v1';

  // SharedPreferencesAsync adalah API yang direkomendasikan paket ini;
  // setiap baca/tulis langsung ke penyimpanan, jadi selalu berupa Future.
  final _prefs = SharedPreferencesAsync();

  /// Memuat semua tugas. Mengembalikan daftar kosong jika belum ada data
  /// atau datanya rusak, supaya aplikasi tidak crash.
  ///
  /// `Future<...>` artinya hasilnya baru tersedia nanti; pemanggil
  /// menunggunya dengan `await`.
  Future<List<Task>> loadTasks() async {
    final text = await _prefs.getString(_tasksKey);
    if (text == null) return [];

    try {
      final list = jsonDecode(text) as List<dynamic>;
      return list
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList();
    } on FormatException {
      // Teks bukan JSON yang valid (atau tanggal tidak bisa dibaca).
      return [];
    } on TypeError {
      // JSON valid, tapi bentuknya tidak sesuai dengan Task.
      return [];
    }
  }

  /// Menyimpan seluruh daftar sebagai satu teks JSON.
  Future<void> saveTasks(List<Task> tasks) async {
    final text = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await _prefs.setString(_tasksKey, text);
  }
}
