/// Data satu tugas.
///
/// Semua field `final` (tidak bisa diubah setelah dibuat). Untuk "mengubah"
/// tugas, kita membuat salinan baru lewat [copyWith]. Cara ini membuat data
/// lebih mudah ditebak karena satu objek tidak pernah berubah diam-diam.
class Task {
  const Task({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
  });

  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  /// Membuat salinan tugas. Field yang diberikan diganti, sisanya
  /// memakai nilai lama (operator `??` artinya "kalau null, pakai yang kanan").
  Task copyWith({
    String? id,
    String? title,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
