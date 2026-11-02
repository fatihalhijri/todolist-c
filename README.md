# Daftar Tugas

Aplikasi daftar tugas (to-do list) sederhana yang dibuat dengan Flutter. Proyek ini adalah proyek belajar: dikerjakan bertahap (Tahap 0–4) untuk memahami dasar-dasar Flutter, mulai dari widget, state, penyimpanan lokal, sampai pengujian.

## Tangkapan layar

| Tema terang | Tema gelap | Edit tugas |
|---|---|---|
| ![Tema terang](docs/screenshots/terang.png) | ![Tema gelap](docs/screenshots/gelap.png) | ![Edit tugas](docs/screenshots/edit.png) |

> Belum ada gambar. Simpan tangkapan layar di folder `docs/screenshots/` dengan nama file di atas.

## Fitur

- **Tambah tugas** lewat tombol **+** atau tombol Enter di keyboard. Teks kosong atau hanya spasi diabaikan.
- **Centang tugas** yang sudah selesai. Judulnya dicoret dan warnanya memudar.
- **Hapus tugas** dengan menggeser baris ke kiri, lalu **batalkan** lewat tombol "Batalkan" di SnackBar. Tugas kembali ke posisi semula.
- **Edit judul** dengan mengetuk judul tugas.
- **Penghitung**: "3 dari 5 tugas belum selesai".
- **Filter**: Semua, Belum, Selesai.
- **Tersimpan otomatis** di HP. Tugas tetap ada setelah aplikasi ditutup.
- **Mode gelap** otomatis, mengikuti pengaturan HP.

## Teknologi

- Flutter (channel stable), Dart 3, Material 3
- State: `StatefulWidget` + `setState` (tanpa paket state management)
- Penyimpanan: [`shared_preferences`](https://pub.dev/packages/shared_preferences) (`SharedPreferencesAsync`), data disimpan sebagai teks JSON

## Cara menjalankan

Pastikan Flutter sudah terpasang (`flutter doctor` tidak menunjukkan masalah), lalu:

```bash
flutter pub get   # mengunduh paket yang dibutuhkan
flutter run       # menjalankan aplikasi di HP/emulator yang terhubung
```

Perintah lain:

```bash
flutter test      # menjalankan semua tes
flutter analyze   # memeriksa kode (harus 0 masalah)
dart format .     # merapikan format kode
```

> **Windows:** jika muncul pesan "Building with plugins requires symlink support", aktifkan **Developer Mode** (`start ms-settings:developers`).

## Struktur folder

```
lib/
├── main.dart                  titik masuk, hanya memanggil runApp
├── app.dart                   MaterialApp, tema terang dan gelap
├── models/
│   ├── task.dart              kelas data Task (+ copyWith, toJson, fromJson)
│   └── task_filter.dart       enum filter: Semua, Belum, Selesai
├── screens/
│   └── home_screen.dart       halaman utama, memegang daftar tugas dan semua aksinya
├── services/
│   └── task_storage.dart      menyimpan dan memuat tugas (shared_preferences + JSON)
└── widgets/
    ├── task_input.dart        kolom teks dan tombol tambah
    ├── task_counter.dart      teks "X dari Y tugas belum selesai"
    ├── filter_bar.dart        tombol pilihan filter
    ├── task_list.dart         daftar tugas yang bisa digulir
    ├── task_tile.dart         satu baris tugas (centang, edit, geser untuk hapus)
    ├── edit_task_dialog.dart  dialog untuk mengubah judul
    └── empty_state.dart       tampilan saat tidak ada tugas
test/
├── models/                    unit test Task dan TaskFilter
├── services/                  unit test TaskStorage (memakai penyimpanan tiruan)
└── widget_test.dart           widget test alur utama dan semua fitur
docs/                          rencana, catatan progres, dan detail tiap tahap
```

## Yang saya pelajari

**Tahap 0 — Persiapan**
- Struktur proyek Flutter, `main()` dan `runApp()`.
- `MaterialApp`, `Scaffold`, `AppBar`, dan `StatelessWidget`.
- Tema Material 3 dari satu warna dasar dengan `ColorScheme.fromSeed`.
- `const` dan aturan lint untuk menjaga gaya kode.

**Tahap 1 — Fitur dasar**
- Kelas data dengan field `final` dan `copyWith`, jadi data tidak diubah, melainkan diganti dengan salinan baru.
- `StatefulWidget` dan `setState` untuk memperbarui layar saat data berubah.
- `TextField` dan `TextEditingController` (yang wajib di-`dispose`).
- `ListView.builder`, `Dismissible`, dan pentingnya `Key` yang unik.
- Mengirim data dari widget anak ke induk lewat callback (`ValueChanged`, `VoidCallback`).

**Tahap 2 — Penyimpanan**
- `Future`, `async`, dan `await` untuk pekerjaan yang butuh waktu.
- Mengubah objek ke JSON dan sebaliknya (`toJson`/`fromJson`, `jsonEncode`/`jsonDecode`).
- `initState` untuk memuat data, dan cek `mounted` setelah `await`.
- Memisahkan logika penyimpanan ke kelas service, serta menangani data rusak dengan `try`/`on`.

**Tahap 3 — Fitur tambahan**
- Data turunan (penghitung, hasil filter) yang dihitung dengan `where`, bukan disimpan.
- `enum` dan `switch` yang wajib menangani semua nilai.
- `showDialog` dan mengembalikan nilai dari dialog dengan `Navigator.pop`.
- Closure untuk tombol "Batalkan" pada `SnackBarAction`.
- Tema terang/gelap dengan `Brightness` dan `ThemeMode.system`.

**Tahap 4 — Tes dan finalisasi**
- Refactoring: merapikan kode tanpa mengubah perilaku, dengan tes sebagai jaring pengaman.
- Perbedaan unit test (logika saja, cepat) dan widget test (meniru pengguna mengetuk layar).
- Mengatur nama aplikasi di Android (`AndroidManifest.xml`) dan iOS (`Info.plist`).

## Ide pengembangan

- Tampilkan pesan dan tombol "Coba lagi" jika **membaca** penyimpanan gagal karena error sistem (saat ini loading akan terus berputar).
- Tanggal tenggat dan pengingat untuk tiap tugas.
- Mengurutkan ulang tugas dengan menyeret (`ReorderableListView`).
- Tombol "Hapus semua yang selesai".
- Kategori atau warna untuk tiap tugas.

## Pembuat

_(Isi nama dan tautan GitHub kamu di sini.)_
