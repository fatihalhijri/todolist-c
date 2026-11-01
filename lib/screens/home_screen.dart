import 'package:flutter/material.dart';

/// Halaman utama aplikasi. Untuk sementara masih StatelessWidget
/// karena belum ada data yang berubah; di Tahap 1 akan diubah.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold = kerangka halaman Material: menyediakan tempat untuk
    // AppBar (bilah judul di atas) dan body (isi halaman).
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      body: const Center(child: Text('Belum ada tugas')),
    );
  }
}
