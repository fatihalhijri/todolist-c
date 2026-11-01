import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

/// Widget paling atas aplikasi: mengatur judul, tema, dan halaman pertama.
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Tugas',
      // Menyembunyikan pita "DEBUG" di pojok kanan atas.
      debugShowCheckedModeBanner: false,
      // ColorScheme.fromSeed membuat satu set warna Material 3 yang serasi
      // hanya dari satu warna dasar, jadi kita tidak perlu memilih tiap warna.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const HomeScreen(),
    );
  }
}
