import 'package:flutter/material.dart';

/// Tampilan saat tidak ada tugas yang bisa ditampilkan.
///
/// Pesan dan ikon bisa diganti, misalnya saat hasil filter kosong.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.message = 'Belum ada tugas. Yuk tambahkan!',
    this.icon = Icons.checklist,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    // Theme.of(context) mengambil tema dari MaterialApp di atas,
    // supaya warnanya selalu ikut tema aplikasi.
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        // min: Column hanya setinggi isinya, jadi Center bisa menaruhnya di tengah.
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: colorScheme.outline),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
