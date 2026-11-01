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

  /// Membuat Task dari Map hasil `jsonDecode`.
  ///
  /// `factory` adalah konstruktor yang boleh menjalankan kode dulu sebelum
  /// mengembalikan objek. Jika bentuk datanya salah, `as` akan melempar
  /// TypeError; error itu ditangani oleh TaskStorage.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      isDone: json['isDone'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  /// Mengubah Task menjadi Map agar bisa diubah ke teks JSON.
  /// DateTime tidak dikenal JSON, jadi disimpan sebagai teks ISO 8601
  /// (contoh: "2026-11-01T08:30:00.000").
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
    };
  }

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
