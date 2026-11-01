---
name: tahap
description: Mengerjakan satu tahap proyek To-Do List sesuai rencana di docs/tahap. Dipanggil manual dengan nomor tahap, misalnya /tahap 1.
argument-hint: "[nomor tahap 0-4]"
disable-model-invocation: true
---

Kerjakan **Tahap $ARGUMENTS** proyek ini dengan langkah-langkah berikut, secara berurutan. Semua komunikasi dalam Bahasa Indonesia.

## 1. Pahami posisi
- Baca `docs/PROGRES.md`, `docs/RENCANA.md`, dan file tahap yang namanya diawali `tahap-$ARGUMENTS-` di folder `docs/tahap/`.
- Jika nomor tahap kosong atau filenya tidak ada, tampilkan daftar tahap dari `docs/RENCANA.md`, tanyakan tahap mana yang dimaksud, lalu berhenti.
- Jika tahap sebelumnya belum berstatus "Selesai" di `docs/PROGRES.md`, beri tahu saya dan tanyakan apakah tetap mau lanjut. Berhenti sampai saya menjawab.
- Baca kode yang sudah ada agar tidak merusak hasil tahap sebelumnya.

## 2. Sampaikan rencana, lalu tunggu
Tulis dengan singkat:
- **Tujuan** tahap ini dengan kalimatmu sendiri
- **File** yang akan dibuat atau diubah
- **Paket** yang akan ditambahkan (jika ada)
- **Urutan langkah**
- **Pertanyaan** jika ada yang perlu saya putuskan

Lalu **berhenti dan tunggu saya membalas "lanjut"** atau memberi koreksi. Jangan menulis kode apa pun sebelum itu.

## 3. Kerjakan
- Ubah status tahap ini di `docs/PROGRES.md` menjadi "Sedang dikerjakan".
- Kerjakan langkah demi langkah sesuai rencana yang disetujui, hanya dalam ruang lingkup tahap ini.
- Ikuti semua aturan di `CLAUDE.md`.

## 4. Verifikasi
Jalankan, lalu perbaiki sampai bersih:
1. `dart format .`
2. `flutter analyze` → harus 0 masalah
3. `flutter test` → harus lulus semua

Setelah itu periksa setiap poin "Kriteria selesai" di file tahap. Poin yang hanya bisa dicek dengan menjalankan aplikasi, tandai sebagai "perlu dicoba manual". Jika ada poin yang tidak bisa dipenuhi, jelaskan alasannya.

## 5. Catat dan laporkan
Perbarui `docs/PROGRES.md`: status "Selesai", tanggal hari ini, dan catatan singkat (file yang dibuat atau diubah, keputusan penting, hal yang perlu diingat untuk tahap berikutnya).

Lalu beri laporan dengan bagian-bagian berikut:
- **Yang dikerjakan**: daftar file, masing-masing dengan satu kalimat fungsinya
- **Konsep yang kamu pelajari**: 3–5 konsep dengan penjelasan sederhana, merujuk ke file dan bagian kode yang nyata di proyek ini
- **Coba sendiri**: jalankan `flutter run`, lalu apa saja yang perlu dicoba dan apa yang seharusnya terlihat
- **Latihan kecil**: satu perubahan kecil yang bisa saya coba kerjakan sendiri untuk menguji pemahaman
- **Saran commit**: perintah `git add .` lalu `git commit -m "..."` dengan pesan yang sesuai

Kemudian **berhenti**. Jangan memulai tahap berikutnya.
