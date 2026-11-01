# Log Progres

Status yang dipakai: **Belum**, **Sedang dikerjakan**, **Selesai**.

| Tahap | Nama | Status | Tanggal selesai |
|---|---|---|---|
| 0 | Persiapan | Selesai | 2026-11-01 |
| 1 | Fitur dasar | Belum | - |
| 2 | Penyimpanan | Belum | - |
| 3 | Fitur tambahan | Belum | - |
| 4 | Tes dan finalisasi | Belum | - |

## Catatan per tahap

<!--
Claude menambahkan catatan di bawah ini setiap kali satu tahap selesai, dengan format:

### Tahap N — Nama tahap
- File dibuat/diubah: ...
- Keputusan penting: ...
- Perlu diingat untuk tahap berikutnya: ...
-->

### Tahap 0 — Persiapan
- File dibuat/diubah: `lib/main.dart` (ditulis ulang), `lib/app.dart` (baru), `lib/screens/home_screen.dart` (baru), `analysis_options.yaml` (3 aturan lint), `test/widget_test.dart` (ditulis ulang).
- Keputusan penting: nama paket proyek `todolist_c` (dipakai di import tes: `package:todolist_c/...`). Bagian `analyzer: exclude` untuk folder platform di `analysis_options.yaml` dipertahankan.
- Perlu diingat untuk tahap berikutnya: `HomeScreen` masih StatelessWidget dan teks "Belum ada tugas" masih ditulis langsung di dalamnya; di Tahap 1 diubah menjadi StatefulWidget dan teks kosong pindah ke `widgets/empty_state.dart`. Tes di `test/widget_test.dart` saat ini juga mengecek teks "Belum ada tugas", jadi sesuaikan jika teksnya berubah.
