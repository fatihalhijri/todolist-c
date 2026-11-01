# Tahap 2 — Penyimpanan Lokal

**Tujuan:** Tugas tetap tersimpan walaupun aplikasi ditutup sepenuhnya, lalu dibuka lagi.

## Konsep yang dipelajari
- Menambah paket pihak ketiga dan peran `pubspec.yaml`
- `Future`, `async`, dan `await`
- Mengubah objek menjadi JSON dan sebaliknya (`toJson` / `fromJson`, `jsonEncode` / `jsonDecode`)
- `initState` untuk memuat data saat halaman pertama dibuka
- Menampilkan indikator loading selama data dimuat
- Memisahkan logika penyimpanan ke kelas service

## Ruang lingkup

### Kerjakan
1. Tambahkan paket dengan `flutter pub add shared_preferences`.
2. Di `Task`, tambahkan `Map<String, dynamic> toJson()` dan `factory Task.fromJson(Map<String, dynamic> json)`. Simpan `createdAt` sebagai teks ISO 8601.
3. Buat `lib/services/task_storage.dart` berisi kelas `TaskStorage`:
   - `Future<List<Task>> loadTasks()`
   - `Future<void> saveTasks(List<Task> tasks)`
   - seluruh daftar disimpan sebagai satu teks JSON dengan key `tasks_v1`
   - jika data tersimpan rusak atau tidak bisa dibaca, kembalikan daftar kosong, jangan sampai aplikasi crash
   - gunakan API yang direkomendasikan oleh versi `shared_preferences` yang terpasang
4. Di `HomeScreen`:
   - muat tugas di `initState`; selama memuat tampilkan `CircularProgressIndicator`
   - simpan setiap kali daftar berubah (tambah, centang, hapus)
   - jika penyimpanan gagal, tampilkan SnackBar "Gagal menyimpan tugas", jangan crash
   - cek `mounted` sebelum memakai `context` atau `setState` setelah `await`

### Jangan kerjakan
- Jangan memakai database lain (Hive, sqflite, dan sejenisnya).
- Jangan membuat fitur baru di luar penyimpanan.

## Tes
- `test/models/task_test.dart`: tambahkan tes bolak-balik, yaitu `Task` → `toJson` → `fromJson` menghasilkan data yang sama.
- `test/services/task_storage_test.dart`:
  - menyimpan lalu memuat menghasilkan daftar yang sama
  - memuat saat belum ada data menghasilkan daftar kosong
  - memuat data rusak menghasilkan daftar kosong
  - gunakan cara pengujian (mock) yang disediakan paket `shared_preferences`
- Pastikan tes widget dari Tahap 1 tetap lulus.

## Kriteria selesai
- [ ] Tambah beberapa tugas, centang satu, **tutup aplikasi sepenuhnya** (bukan hot reload), buka lagi → semua tugas dan statusnya masih ada
- [ ] Indikator loading muncul sebentar saat aplikasi dibuka
- [ ] Data rusak tidak membuat aplikasi crash
- [ ] `flutter analyze` 0 masalah dan `flutter test` lulus
