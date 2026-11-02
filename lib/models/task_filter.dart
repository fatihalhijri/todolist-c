import 'task.dart';

/// Pilihan filter daftar tugas.
///
/// `enum` adalah tipe dengan pilihan nilai yang tetap. Lebih aman daripada
/// String seperti 'selesai', karena salah ketik langsung ketahuan saat analyze.
enum TaskFilter {
  all,
  active,
  done;

  /// Apakah [task] ikut tampil saat filter ini dipilih.
  bool matches(Task task) {
    // switch pada enum wajib menangani semua nilai; jika suatu saat ada
    // nilai baru, analyzer akan mengingatkan bagian yang belum ditangani.
    return switch (this) {
      TaskFilter.all => true,
      TaskFilter.active => !task.isDone,
      TaskFilter.done => task.isDone,
    };
  }
}
