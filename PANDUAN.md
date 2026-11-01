# Starter Kit: To-Do List Flutter dengan Claude Code

Kit ini membuat Claude Code mengerjakan aplikasi To-Do List **bertahap**: setiap tahap punya rencana yang jelas, Claude menunggu persetujuanmu sebelum menulis kode, menguji hasilnya sendiri, mencatat progres, dan menjelaskan konsep yang baru kamu pelajari.

## Isi kit

```
todo-starter-kit/
├── PANDUAN.md                  ← file ini
├── CLAUDE.md                   ← aturan yang selalu dibaca Claude
├── .claude/
│   ├── settings.json           ← izin otomatis untuk perintah aman (analyze, test, dll.)
│   └── skills/
│       ├── tahap/SKILL.md      ← perintah /tahap
│       ├── cek/SKILL.md        ← perintah /cek
│       ├── jelaskan/SKILL.md   ← perintah /jelaskan
│       └── progres/SKILL.md    ← perintah /progres
└── docs/
    ├── RENCANA.md              ← gambaran besar 5 tahap
    ├── PROGRES.md              ← catatan kemajuan (diisi Claude)
    ├── PROMPT-SIAP-PAKAI.md    ← prompt cadangan jika perintah slash tidak muncul
    └── tahap/
        ├── tahap-0-persiapan.md
        ├── tahap-1-fitur-dasar.md
        ├── tahap-2-penyimpanan.md
        ├── tahap-3-fitur-tambahan.md
        └── tahap-4-tes-dan-finalisasi.md
```

## Persiapan (sekali saja)

1. Pastikan Flutter sudah terpasang dan sehat:
   ```
   flutter doctor
   ```
2. Pastikan Claude Code sudah terpasang:
   ```
   claude --version
   ```
3. Buat proyek Flutter baru (nama harus huruf kecil dengan garis bawah):
   ```
   flutter create todo_app
   ```
4. **Salin seluruh isi folder kit ini ke dalam folder `todo_app`**, termasuk folder `.claude`.
   Folder yang namanya diawali titik sering tersembunyi:
   - Windows (File Explorer): menu **View → Show → Hidden items**
   - macOS (Finder): tekan `Cmd + Shift + .`
5. Simpan kondisi awal dengan git:
   ```
   cd todo_app
   git init
   git add .
   git commit -m "Proyek awal + starter kit"
   ```
6. Jalankan Claude Code di dalam folder `todo_app`:
   ```
   claude
   ```

## Alur kerja setiap tahap

1. Ketik `/progres` untuk melihat posisi sekarang.
2. Ketik `/tahap 0` (lalu `/tahap 1`, `/tahap 2`, dan seterusnya).
3. Claude menampilkan **rencana**. Baca baik-baik. Jika sudah sesuai, balas `lanjut`. Jika ada yang ingin diubah, katakan saja.
4. Claude menulis kode, menjalankan `flutter analyze` dan `flutter test`, lalu memberi laporan.
5. Jalankan aplikasinya sendiri di terminal lain dan coba sesuai bagian "Coba sendiri":
   ```
   flutter run
   ```
6. Ketik `/cek` jika ingin pemeriksaan kualitas tambahan.
7. Jika sudah puas, commit:
   ```
   git add .
   git commit -m "Tahap N selesai"
   ```
8. Ketik `/clear` untuk memulai sesi baru yang bersih, lalu lanjut ke tahap berikutnya.

## Perintah yang tersedia

| Perintah | Fungsi |
|---|---|
| `/tahap <nomor>` | Mengerjakan satu tahap: rencana → tunggu persetujuan → kode → tes → laporan |
| `/cek` | Memeriksa kualitas kode dan kelengkapan tahap terakhir, tanpa mengubah apa pun |
| `/jelaskan <file atau konsep>` | Penjelasan untuk pemula, misalnya `/jelaskan lib/models/task.dart` atau `/jelaskan setState` |
| `/progres` | Menampilkan tahap yang sudah selesai dan langkah berikutnya |

## Tips agar hasilnya bagus

- **Satu tahap per sesi.** Gunakan `/clear` setelah setiap tahap supaya Claude tidak bingung dengan percakapan lama. Catatan di `PROGRES.md` menjaga kesinambungannya.
- **Baca rencana sebelum bilang "lanjut".** Ini kesempatan terbaik untuk mengoreksi arah.
- **Coba aplikasinya sendiri.** Tes otomatis tidak bisa menggantikan mata kamu.
- **Commit setiap tahap.** Jika ada yang rusak, kamu bisa kembali ke kondisi sebelumnya.
- **Banyak bertanya.** Gunakan `/jelaskan` untuk bagian yang belum dipahami. Tujuannya belajar, bukan hanya aplikasi jadi.
- **Kerjakan latihan kecil** di akhir setiap laporan. Itu cara tercepat untuk benar-benar paham.
- **Beri umpan balik yang spesifik**, misalnya "tombol tambah terlalu kecil di HP" lebih baik daripada "kurang bagus".

## Menyesuaikan rencana

Semua file di `docs/tahap/` boleh kamu ubah, misalnya mengganti warna tema, menambah fitur, atau menghapus fitur di Tahap 3. Claude akan mengikuti isi file terbaru. Aturan umum ada di `CLAUDE.md`.

## Jika ada masalah

- **Perintah slash tidak muncul:** pastikan folder `.claude` ikut tersalin ke dalam `todo_app`, lalu perbarui Claude Code ke versi terbaru. Sebagai cadangan, salin prompt dari `docs/PROMPT-SIAP-PAKAI.md`.
- **Claude langsung menulis kode tanpa rencana:** ingatkan, misalnya "Ikuti aturan di CLAUDE.md, tampilkan rencana dulu."
- **Claude mengerjakan fitur di luar tahap:** minta dibatalkan, atau kembalikan perubahan dengan git.
- **Claude meminta izin menjalankan perintah lain:** itu normal. Baca perintahnya, lalu setujui jika aman.
