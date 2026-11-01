# Proyek: Aplikasi To-Do List (Flutter)

## Konteks
- Saya pemula yang sedang belajar Flutter lewat proyek ini. Tujuan utamanya adalah **memahami**, bukan sekadar punya aplikasi jadi.
- Selalu jelaskan dalam **Bahasa Indonesia** yang sederhana. Hindari istilah teknis tanpa penjelasan.

## Cara kerja (WAJIB diikuti)
1. Proyek dikerjakan **bertahap** sesuai `docs/RENCANA.md`. Detail tiap tahap ada di `docs/tahap/`.
2. Di awal sesi, baca `docs/PROGRES.md` untuk tahu posisi terakhir.
3. Kerjakan **hanya tahap yang diminta**. Jangan mengerjakan fitur tahap berikutnya walaupun terlihat mudah.
4. Sebelum menulis kode, sampaikan rencana singkat lalu **tunggu saya membalas "lanjut"**.
5. Setelah selesai: jalankan verifikasi, perbarui `docs/PROGRES.md`, beri ringkasan dan penjelasan konsep, lalu **berhenti**.
6. Jika ada yang ambigu atau perlu keputusan, **tanya dulu**, jangan menebak.
7. Jangan mengubah file di `docs/tahap/` dan `docs/RENCANA.md` kecuali saya minta. Yang boleh kamu perbarui hanya `docs/PROGRES.md`.

## Teknologi
- Flutter (channel stable), Dart 3, null safety, Material 3.
- State management: **hanya `StatefulWidget` + `setState`**. Jangan memakai Provider, Riverpod, Bloc, GetX, atau sejenisnya. Tujuannya belajar dasar dulu.
- Penyimpanan lokal: `shared_preferences` (mulai Tahap 2).
- Hanya tambahkan paket yang tertulis di rencana. Paket lain harus minta izin saya dulu.
- Tambahkan paket dengan `flutter pub add <nama>`. Jangan menulis nomor versi secara manual.

## Struktur folder
```
lib/
  main.dart      -> titik masuk, hanya berisi runApp
  app.dart       -> MaterialApp dan tema
  models/        -> kelas data (misalnya Task)
  screens/       -> halaman
  widgets/       -> widget kecil yang dipakai ulang
  services/      -> penyimpanan data
test/            -> tes, struktur foldernya mengikuti lib/
```

## Gaya kode
- Nama kelas, variabel, fungsi, dan file dalam **bahasa Inggris** (file `snake_case`, variabel `camelCase`, kelas `PascalCase`).
- Semua teks yang tampil di layar dalam **bahasa Indonesia**.
- Gunakan `const` di mana pun bisa.
- Widget yang dipakai ulang diletakkan di file sendiri. Pecah widget jika method `build()` lebih dari kira-kira 80 baris.
- Komentar dalam bahasa Indonesia, singkat. Jelaskan "kenapa", dan beri komentar penjelas saat sebuah konsep Flutter baru pertama kali muncul.
- Selalu `dispose()` controller. Cek `mounted` sebelum memakai `context` setelah `await`.
- Jangan tinggalkan kode mati, `print` untuk debug, atau TODO tanpa penjelasan.

## Perintah
- `dart format .` -> merapikan kode
- `flutter analyze` -> harus **0 masalah**
- `flutter test` -> harus **lulus semua**
- **Jangan menjalankan `flutter run`** karena prosesnya interaktif. Beri tahu saya apa yang perlu dicoba saat saya menjalankannya sendiri.

## Definisi "selesai" untuk setiap tahap
- Semua poin "Kriteria selesai" di file tahap terpenuhi
- `dart format`, `flutter analyze`, dan `flutter test` bersih
- `docs/PROGRES.md` sudah diperbarui
- Ringkasan dan penjelasan konsep sudah diberikan
