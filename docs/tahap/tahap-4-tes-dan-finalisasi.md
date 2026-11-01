# Tahap 4 — Tes dan Finalisasi

**Tujuan:** Merapikan seluruh kode, melengkapi tes, dan menulis dokumentasi, sehingga proyek layak dipamerkan di portofolio.

## Konsep yang dipelajari
- Refactoring: memperbaiki kode tanpa mengubah perilakunya
- Unit test vs widget test
- Menulis README yang baik

## Ruang lingkup

### Kerjakan
1. **Tinjau seluruh kode** dan tampilkan dulu daftar temuan sebelum memperbaiki:
   - kode yang berulang, nama yang kurang jelas, widget yang terlalu besar
   - `const` yang terlewat, controller yang tidak di-`dispose`
   - penggunaan `context` setelah `await` tanpa cek `mounted`
2. Perbaiki temuan yang saya setujui. Perilaku aplikasi **tidak boleh berubah**.
3. **Lengkapi tes** sehingga mencakup model, storage, dan alur utama di layar (tambah, centang, hapus, serta fitur Tahap 3 yang dikerjakan).
4. **Nama aplikasi di HP** menjadi "Daftar Tugas":
   - Android: `android:label` di `android/app/src/main/AndroidManifest.xml`
   - iOS: `CFBundleDisplayName` di `ios/Runner/Info.plist`
5. **Tulis ulang `README.md`** dalam bahasa Indonesia:
   - deskripsi singkat dan daftar fitur
   - cara menjalankan (`flutter pub get`, `flutter run`)
   - struktur folder dengan penjelasan singkat
   - "Yang saya pelajari" (ringkasan konsep dari Tahap 0–4)
   - tempat untuk screenshot (placeholder)

### Jangan kerjakan
- Jangan menambah fitur baru.
- Jangan mengganti cara pengelolaan state atau penyimpanan.

## Kriteria selesai
- [ ] Daftar temuan sudah ditampilkan dan perbaikan yang disetujui sudah dikerjakan
- [ ] `dart format`, `flutter analyze` (0 masalah), dan `flutter test` (lulus semua) bersih
- [ ] Nama aplikasi di HP menjadi "Daftar Tugas"
- [ ] README.md baru selesai ditulis
- [ ] Ringkasan akhir pembelajaran diberikan, berisi konsep yang sudah dikuasai dan ide pengembangan selanjutnya
