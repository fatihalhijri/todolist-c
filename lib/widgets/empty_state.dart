import 'package:flutter/material.dart';

/// Tampilan saat daftar tugas masih kosong.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

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
          Icon(Icons.checklist, size: 72, color: colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'Belum ada tugas. Yuk tambahkan!',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
