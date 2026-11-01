# Tahap 0 — Persiapan

**Tujuan:** Mengganti contoh aplikasi counter bawaan `flutter create` dengan kerangka aplikasi To-Do yang rapi: struktur folder, tema, dan satu halaman kosong.

## Konsep yang dipelajari
- Struktur proyek Flutter (`lib/`, `test/`, `pubspec.yaml`, `analysis_options.yaml`)
- Fungsi `main()` dan `runApp()`
- `MaterialApp`, `ThemeData`, dan `ColorScheme.fromSeed` (Material 3)
- `Scaffold` dan `AppBar`
- `StatelessWidget`

## Ruang lingkup

### Kerjakan
1. Hapus seluruh kode counter bawaan di `lib/main.dart`.
2. Buat `lib/main.dart` yang hanya berisi `main()` dan `runApp(const TodoApp())`.
3. Buat `lib/app.dart` berisi kelas `TodoApp` (StatelessWidget) yang mengembalikan `MaterialApp`:
   - `title: 'Daftar Tugas'`
   - `debugShowCheckedModeBanner: false`
   - tema Material 3 dengan `ColorScheme.fromSeed(seedColor: Colors.teal)`
   - `home: const HomeScreen()`
4. Buat `lib/screens/home_screen.dart` berisi `HomeScreen` (StatelessWidget untuk sementara):
   - `AppBar` dengan judul "Daftar Tugas"
   - isi halaman: teks di tengah "Belum ada tugas"
5. Tambahkan aturan lint berikut di bagian `linter: rules:` pada `analysis_options.yaml` (pertahankan `include` bawaannya):
   - `prefer_const_constructors`
   - `prefer_const_literals_to_create_immutables`
   - `prefer_final_locals`
6. Ganti `test/widget_test.dart` bawaan (yang menguji counter dan pasti gagal) dengan tes sederhana: aplikasi tampil dan teks "Daftar Tugas" ditemukan di layar.

### Jangan kerjakan
- Jangan membuat model `Task`, input, atau daftar tugas (itu Tahap 1).
- Jangan menambah paket apa pun.

## Kriteria selesai
- [ ] Tidak ada lagi kode counter bawaan di proyek
- [ ] `lib/main.dart`, `lib/app.dart`, dan `lib/screens/home_screen.dart` ada dan sesuai spesifikasi
- [ ] Aturan lint tambahan sudah ada di `analysis_options.yaml`
- [ ] `flutter analyze` menunjukkan 0 masalah
- [ ] `flutter test` lulus
- [ ] Saat dijalankan, aplikasi menampilkan AppBar "Daftar Tugas" dan teks "Belum ada tugas"
