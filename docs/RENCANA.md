# Rencana Proyek: To-Do List Flutter

Aplikasi daftar tugas sederhana untuk belajar dasar-dasar Flutter. Dikerjakan dalam 5 tahap. Setiap tahap harus selesai, teruji, dan dipahami sebelum lanjut ke tahap berikutnya.

## Daftar tahap

| Tahap | Nama | Hasil akhir | File detail |
|---|---|---|---|
| 0 | Persiapan | Aplikasi kosong yang rapi dengan struktur folder dan tema | `tahap/tahap-0-persiapan.md` |
| 1 | Fitur dasar | Tambah, centang, dan hapus tugas (data belum tersimpan) | `tahap/tahap-1-fitur-dasar.md` |
| 2 | Penyimpanan | Tugas tetap ada setelah aplikasi ditutup | `tahap/tahap-2-penyimpanan.md` |
| 3 | Fitur tambahan | Filter, edit, batal hapus, mode gelap, dan lainnya | `tahap/tahap-3-fitur-tambahan.md` |
| 4 | Tes dan finalisasi | Kode rapi, tes lengkap, README proyek | `tahap/tahap-4-tes-dan-finalisasi.md` |

## Keputusan teknis
- **State:** `StatefulWidget` + `setState` saja, supaya konsep dasarnya terlihat jelas.
- **Penyimpanan:** `shared_preferences`, data disimpan sebagai teks JSON.
- **Tampilan:** Material 3 dengan satu warna dasar (seed color).
- **Paket tambahan:** hanya `shared_preferences`. Selebihnya memakai bawaan Flutter.

## Struktur folder akhir (target)
```
lib/
├── main.dart
├── app.dart
├── models/
│   └── task.dart
├── screens/
│   └── home_screen.dart
├── widgets/
│   ├── task_input.dart
│   ├── task_tile.dart
│   ├── empty_state.dart
│   └── (widget tambahan dari Tahap 3)
└── services/
    └── task_storage.dart
test/
├── models/
│   └── task_test.dart
├── services/
│   └── task_storage_test.dart
└── widget_test.dart
```

## Aturan alur kerja
- Satu tahap dikerjakan dalam satu sesi Claude. Setelah tahap selesai, commit, lalu mulai sesi baru (`/clear`).
- Di setiap tahap, Claude menyampaikan rencana dulu dan baru menulis kode setelah disetujui.
- Kemajuan dicatat di `PROGRES.md`.
