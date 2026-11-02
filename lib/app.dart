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
      // Tema gelap memakai warna dasar yang sama; Brightness.dark membuat
      // fromSeed menghasilkan latar gelap dan teks terang.
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      // system = ikuti pengaturan terang/gelap di HP.
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
