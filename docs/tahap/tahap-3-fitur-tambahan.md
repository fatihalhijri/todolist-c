# Tahap 3 — Fitur Tambahan

**Tujuan:** Membuat aplikasi lebih nyaman dipakai. Fitur dikerjakan **satu per satu**, dan setiap fitur diverifikasi sebelum pindah ke fitur berikutnya.

## Cara mengerjakan tahap ini
1. Di awal tahap, tampilkan daftar fitur di bawah dan tanyakan fitur mana yang ingin saya kerjakan. Fitur A sampai E adalah pilihan bawaan; fitur F opsional.
2. Kerjakan fitur yang dipilih secara berurutan. Setelah tiap fitur selesai, jalankan `flutter analyze` dan `flutter test`, lalu beri ringkasan satu paragraf.
3. Catat fitur yang dikerjakan di `PROGRES.md`.

## Daftar fitur

### A. Penghitung tugas
- Teks kecil di atas daftar, misalnya "3 dari 5 tugas belum selesai".
- Konsep: menghitung data turunan dari list (`where`, `length`).

### B. Filter
- `SegmentedButton` dengan pilihan **Semua**, **Belum**, **Selesai**.
- Jika hasil filter kosong, tampilkan pesan yang sesuai, misalnya "Tidak ada tugas yang selesai".
- Konsep: `enum`, memfilter list tanpa mengubah data asli.

### C. Edit tugas
- Ketuk judul tugas untuk membuka `AlertDialog` berisi `TextField` yang sudah terisi judul lama.
- Tombol "Batal" dan "Simpan"; judul kosong tidak boleh disimpan.
- Konsep: `showDialog`, mengembalikan nilai dari dialog dengan `Navigator.pop`.

### D. Batal hapus (undo)
- SnackBar setelah menghapus punya aksi "Batalkan" yang mengembalikan tugas ke **posisi semula**.
- Konsep: menyimpan data sementara, `SnackBarAction`.

### E. Mode gelap mengikuti sistem
- Tambahkan `darkTheme` dengan warna dasar yang sama dan `themeMode: ThemeMode.system`.
- Konsep: `Brightness`, tema terang dan gelap.

### F. (Opsional) Hapus semua tugas yang selesai
- Tombol ikon di AppBar dengan dialog konfirmasi sebelum menghapus.
- Tombol tidak aktif jika tidak ada tugas yang selesai.

## Aturan tambahan
- Setiap widget baru dibuat di file sendiri di `lib/widgets/`, misalnya `filter_bar.dart` dan `edit_task_dialog.dart`.
- Jika `home_screen.dart` mulai terlalu panjang, pecah bagian tampilannya menjadi widget.
- Semua perubahan data tetap disimpan dengan `TaskStorage` dari Tahap 2.
- Tambahkan tes widget untuk setiap fitur yang dikerjakan.

## Kriteria selesai
- [ ] Semua fitur yang dipilih berfungsi dan datanya tetap tersimpan setelah aplikasi ditutup
- [ ] Setiap fitur punya minimal satu tes
- [ ] `flutter analyze` 0 masalah dan `flutter test` lulus
