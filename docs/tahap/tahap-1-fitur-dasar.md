# Tahap 1 — Fitur Dasar (tanpa penyimpanan)

**Tujuan:** Pengguna bisa menambah, mencentang, dan menghapus tugas. Data hanya disimpan di memori, jadi hilang saat aplikasi ditutup. Itu normal untuk tahap ini.

## Konsep yang dipelajari
- Membuat kelas data (model) dengan field `final` dan method `copyWith`
- `StatefulWidget`, `State`, dan `setState`
- `TextField` dan `TextEditingController` (termasuk `dispose`)
- `ListView.builder` untuk daftar dinamis
- `Checkbox` / `CheckboxListTile`
- `Dismissible` dan pentingnya `Key`
- Mengirim data dari widget anak ke induk lewat callback (`ValueChanged`, `VoidCallback`)
- `SnackBar` dan `ScaffoldMessenger`

## Ruang lingkup

### Kerjakan
1. **Model** `lib/models/task.dart`, kelas `Task` dengan field `final`:
   - `id` (String), dibuat dari `DateTime.now().microsecondsSinceEpoch.toString()`
   - `title` (String)
   - `isDone` (bool, bawaan `false`)
   - `createdAt` (DateTime)
   - method `copyWith(...)`
2. **Halaman** `lib/screens/home_screen.dart` diubah menjadi `StatefulWidget` yang menyimpan `List<Task>`:
   - fungsi tambah, ubah status selesai, dan hapus, semuanya memakai `setState`
   - tugas baru muncul di **paling atas** daftar
3. **Widget input** `lib/widgets/task_input.dart`:
   - `TextField` dengan petunjuk "Tulis tugas baru..." dan tombol tambah
   - tugas bisa ditambah dengan menekan tombol **atau** Enter di keyboard
   - spasi di awal dan akhir teks dibuang; teks kosong tidak ditambahkan
   - kolom dikosongkan setelah tugas ditambahkan
   - controller di-`dispose`
4. **Widget item** `lib/widgets/task_tile.dart`:
   - menampilkan judul tugas dan checkbox
   - tugas yang selesai: teks dicoret dan warnanya lebih pudar
   - dibungkus `Dismissible` dengan `key: ValueKey(task.id)`; geser dari kanan ke kiri untuk menghapus, latar merah dengan ikon tempat sampah
   - setelah dihapus muncul SnackBar: `Tugas "<judul>" dihapus`
5. **Tampilan kosong** `lib/widgets/empty_state.dart`: ikon dan teks "Belum ada tugas. Yuk tambahkan!" saat daftar kosong.

### Jangan kerjakan
- Jangan menyimpan data ke HP (itu Tahap 2).
- Jangan membuat fitur edit, filter, atau batal hapus (itu Tahap 3).

## Tes
- `test/models/task_test.dart`: `copyWith` mengubah field yang diberikan dan mempertahankan field lainnya.
- `test/widget_test.dart`:
  - mengetik tugas lalu menekan tombol tambah membuat tugas muncul di daftar
  - input kosong atau hanya spasi tidak menambah tugas
  - mengetuk checkbox mengubah status tugas
  - tampilan kosong muncul saat belum ada tugas

## Kriteria selesai
- [ ] Bisa menambah tugas lewat tombol dan lewat Enter
- [ ] Input kosong atau hanya spasi diabaikan
- [ ] Bisa mencentang dan membatalkan centang; teks tugas selesai dicoret
- [ ] Bisa menghapus dengan menggeser, dan SnackBar muncul
- [ ] Tampilan kosong muncul saat daftar kosong
- [ ] `flutter analyze` 0 masalah dan `flutter test` lulus
