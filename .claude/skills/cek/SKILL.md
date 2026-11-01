---
name: cek
description: Memeriksa kualitas kode dan kelengkapan tahap terakhir tanpa mengubah apa pun. Dipanggil manual dengan /cek.
disable-model-invocation: true
---

Periksa proyek ini **tanpa mengubah file apa pun**. Semua komunikasi dalam Bahasa Indonesia.

1. Baca `docs/PROGRES.md` untuk mengetahui tahap terakhir yang sedang dikerjakan atau sudah selesai, lalu baca file tahap tersebut di `docs/tahap/`.
2. Jalankan:
   - `dart format --output=none --set-exit-if-changed .` (cek format tanpa mengubah file)
   - `flutter analyze`
   - `flutter test`
3. Cocokkan kode dengan poin "Kriteria selesai" di file tahap dan aturan di `CLAUDE.md`.
4. Tinjau juga:
   - bug yang mungkin terjadi, termasuk saat input kosong atau data kosong
   - controller yang tidak di-`dispose`
   - `context` atau `setState` dipakai setelah `await` tanpa cek `mounted`
   - widget yang terlalu besar atau kode yang berulang
   - `const` yang terlewat
   - teks di layar yang bukan bahasa Indonesia
   - fitur di luar ruang lingkup tahap ini
5. Laporkan hasilnya:
   - ringkasan hasil format, analyze, dan test
   - tabel: **Masalah | File | Tingkat (Penting / Saran) | Usulan perbaikan**
   - kriteria selesai mana yang sudah dan belum terpenuhi
6. Jangan memperbaiki apa pun. Akhiri dengan bertanya masalah mana yang ingin saya perbaiki.
