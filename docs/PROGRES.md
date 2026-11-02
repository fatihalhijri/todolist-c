# Log Progres

Status yang dipakai: **Belum**, **Sedang dikerjakan**, **Selesai**.

| Tahap | Nama | Status | Tanggal selesai |
|---|---|---|---|
| 0 | Persiapan | Selesai | 2026-11-01 |
| 1 | Fitur dasar | Selesai | 2026-11-01 |
| 2 | Penyimpanan | Selesai | 2026-11-01 |
| 3 | Fitur tambahan | Selesai | 2026-11-02 |
| 4 | Tes dan finalisasi | Selesai | 2026-11-02 |

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

### Tahap 1 — Fitur dasar
- File dibuat/diubah: `lib/models/task.dart` (baru), `lib/widgets/task_input.dart` (baru), `lib/widgets/task_tile.dart` (baru), `lib/widgets/empty_state.dart` (baru), `lib/screens/home_screen.dart` (jadi StatefulWidget), `test/models/task_test.dart` (baru), `test/widget_test.dart` (ditulis ulang, 7 tes).
- Keputusan penting: kolom input ada di atas daftar. `id` dan `createdAt` diisi di `HomeScreen._addTask`, bukan di model. SnackBar hapus ditampilkan oleh `HomeScreen._deleteTask` (bukan oleh `TaskTile`) agar tombol "Batal" di Tahap 3 mudah ditambahkan. `TaskTile` hanya memakai callback `onToggle` / `onDelete`; `TaskInput` memakai `onSubmitted` (teks sudah di-trim dan dijamin tidak kosong).
- Perlu diingat untuk tahap berikutnya: semua perubahan daftar ada di tiga fungsi `_addTask`, `_toggleTask`, `_deleteTask` di `home_screen.dart`, jadi itu tempat memanggil penyimpanan di Tahap 2. `Task` belum punya `toJson`/`fromJson`. Tes widget mencari tombol tambah lewat tooltip "Tambah tugas".

### Tahap 2 — Penyimpanan
- File dibuat/diubah: `pubspec.yaml` (paket `shared_preferences`, dev: `shared_preferences_platform_interface`), `lib/models/task.dart` (`toJson`/`fromJson`), `lib/services/task_storage.dart` (baru), `lib/screens/home_screen.dart` (muat di `initState`, loading, simpan otomatis), `test/models/task_test.dart` (tes JSON), `test/services/task_storage_test.dart` (baru), `test/widget_test.dart` (mock penyimpanan + 3 tes baru).
- Keputusan penting: memakai `SharedPreferencesAsync` (API yang direkomendasikan di shared_preferences 2.5.6; API lama `SharedPreferences` berstatus legacy). Pengguna mengizinkan `shared_preferences_platform_interface` sebagai dev_dependency untuk mock `InMemorySharedPreferencesAsync` di tes. Data disimpan di key `tasks_v1`. Data rusak (`FormatException`/`TypeError`) menghasilkan daftar kosong. Penyimpanan berjalan tanpa di-await setelah `setState`; gagal simpan menampilkan SnackBar "Gagal menyimpan tugas" tanpa membatalkan perubahan di layar. Selama loading, seluruh body diganti `CircularProgressIndicator` agar input tidak bisa dipakai sebelum data termuat.
- Perlu diingat untuk tahap berikutnya: setiap perubahan daftar harus diikuti `_saveTasks()` (termasuk edit dan batal hapus di Tahap 3). SnackBar dipusatkan di `_showMessage`. Tes widget memakai helper `startApp` (pumpWidget + pumpAndSettle) dan `setUp` yang memasang penyimpanan tiruan kosong. Saat `flutter pub add` sempat muncul peringatan Windows "Building with plugins requires symlink support" (perlu Developer Mode untuk build Windows).

### Tahap 3 — Fitur tambahan
- Fitur dikerjakan: A (penghitung), B (filter), C (edit), D (batal hapus), E (mode gelap). Fitur F (hapus semua yang selesai) tidak dipilih.
- File dibuat/diubah: `lib/models/task_filter.dart` (baru, enum + `matches`), `lib/widgets/task_counter.dart` (baru), `lib/widgets/filter_bar.dart` (baru), `lib/widgets/edit_task_dialog.dart` (baru), `lib/widgets/task_list.dart` (baru, dipecah dari HomeScreen), `lib/widgets/empty_state.dart` (parameter `message` dan `icon`), `lib/widgets/task_tile.dart` (ListTile + Checkbox, callback `onEdit`), `lib/screens/home_screen.dart`, `lib/app.dart` (`darkTheme`, `themeMode`), `test/widget_test.dart` (14 tes baru, dikelompokkan per fitur; total 38 tes).
- Keputusan penting: `CheckboxListTile` diganti `ListTile` + `Checkbox` agar ketuk judul = edit, ketuk kotak = centang (disetujui pengguna). Pilihan filter tidak disimpan (selalu "Semua" saat dibuka). Penghitung dan filter disembunyikan saat daftar kosong. Undo memakai closure (`task` dan `index` ditangkap `onPressed`), bukan variabel State. SnackBar memakai `persist: false` karena di Flutter ini SnackBar yang punya action secara bawaan tidak hilang sendiri.
- Perlu diingat untuk tahap berikutnya: tes widget mencari baris lewat `TaskTile` (bukan `CheckboxListTile`) dan segmen filter lewat `find.descendant` di dalam `SegmentedButton<TaskFilter>`. `test/widget_test.dart` sudah panjang (±440 baris), jadi bisa dipertimbangkan untuk dipecah per widget di Tahap 4. `TaskFilter.matches` dan `TaskCounter` belum punya tes unit tersendiri (baru lewat tes widget).

### Tahap 4 — Tes dan finalisasi
- File dibuat/diubah: `lib/screens/home_screen.dart` (refactor `_toggleTask` dan `_buildTaskArea`), `pubspec.yaml` (deskripsi, `cupertino_icons` dihapus), `test/models/task_filter_test.dart` (baru), `test/services/task_storage_test.dart` (+1 tes), `test/widget_test.dart` (+2 tes), `android/app/src/main/AndroidManifest.xml` dan `ios/Runner/Info.plist` (nama aplikasi "Daftar Tugas"), `README.md` (ditulis ulang). Total 44 tes.
- Keputusan penting: temuan tinjauan 1–4 diperbaiki (teks kosong ganda, `_toggleTask` disamakan dengan `_editTask` + jaga `index == -1`, deskripsi pubspec, hapus `cupertino_icons`). Temuan 5–7 sengaja dibiarkan: gagal *membaca* penyimpanan karena error sistem membuat loading berputar terus (dicatat di README sebagai ide pengembangan), `copyWith(id:, createdAt:)` belum dipakai, angka padding 16 berulang.
- Perlu diingat: README punya placeholder screenshot di `docs/screenshots/` (terang.png, gelap.png, edit.png) dan bagian "Pembuat" yang perlu diisi sendiri. Nama aplikasi untuk Windows/web/macOS/Linux belum diubah (di luar ruang lingkup).
