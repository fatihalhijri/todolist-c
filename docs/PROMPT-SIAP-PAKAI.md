# Prompt Siap Pakai

Gunakan prompt ini jika perintah slash (`/tahap`, `/cek`, dan lainnya) tidak muncul, atau jika kamu ingin memberi instruksi dengan kata-katamu sendiri. Ganti `N` dengan nomor tahap.

## Mengerjakan satu tahap
```
Kerjakan Tahap N sesuai docs/tahap/tahap-N-*.md.
Baca dulu CLAUDE.md, docs/RENCANA.md, dan docs/PROGRES.md.
Tampilkan rencana singkat (tujuan, file yang dibuat/diubah, paket, urutan langkah),
lalu tunggu saya bilang "lanjut" sebelum menulis kode.
Setelah selesai: jalankan dart format, flutter analyze, dan flutter test,
perbarui docs/PROGRES.md, lalu jelaskan konsep yang saya pelajari. Jangan lanjut ke tahap berikutnya.
```

## Memeriksa hasil
```
Periksa kode tahap terakhir tanpa mengubah file apa pun.
Jalankan flutter analyze dan flutter test, cocokkan dengan "Kriteria selesai" di file tahapnya,
lalu laporkan masalah dalam tabel: Masalah | File | Tingkat | Usulan perbaikan.
```

## Minta penjelasan
```
Jelaskan isi lib/screens/home_screen.dart bagian demi bagian untuk pemula,
dengan bahasa sederhana. Jangan mengubah file apa pun.
```

## Memperbaiki sesuatu yang salah
```
Saat saya [langkah yang dilakukan], yang terjadi [hasil sekarang],
padahal seharusnya [hasil yang diharapkan].
Cari penyebabnya, jelaskan dulu, lalu tunggu persetujuan saya sebelum memperbaiki.
```

## Melihat posisi proyek
```
Baca docs/PROGRES.md dan beri tahu saya tahap yang sudah selesai dan tahap berikutnya.
```
