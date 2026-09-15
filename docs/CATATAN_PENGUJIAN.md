# Catatan pengujian dan perbaikan

Tanggal: 15 September 2026.

## Hasil

- Analisis awal menemukan 16 masalah. Setelah perbaikan, `flutter analyze` selesai dengan `No issues found`.
- `flutter test`: 21 tes lulus, terdiri dari 20 tes autentikasi dan 1 tes widget halaman login.
- Tes autentikasi memakai adapter HTTP palsu dan penyimpanan mock. Pengujian unit tidak mengakses backend asli. Lihat hasil uji emulator di bawah.

## Perbaikan

- Menambahkan import SharedPreferences yang hilang.
- Memperbaiki `final`, constructor, import ApiConstants, dan konsistensi nama `AuthRemoteDataSource`.
- Menolak respons yang tidak memiliki `accessToken` berupa string yang tidak kosong.
- Memperbaiki logout agar menggunakan `deleteToken()` dan menghasilkan AuthFailure jika penyimpanan melempar error.
- Menangani respons error berupa teks, null, list, atau message kosong tanpa crash saat membaca message.

## Hal yang perlu diperhatikan

1. `ApiConstants.baseUrl` masih `http://localhost:4000`. Pastikan alamat tersebut dapat dijangkau dari lingkungan tempat aplikasi berjalan; uji koneksi ke backend dari target perangkat sebelum menguji login.
2. Kontrak yang saat ini diterapkan: login menerima HTTP 200, register menerima HTTP 201, dan keduanya mengharapkan objek JSON dengan `accessToken`. Cocokkan dengan backend; respons register tanpa token saat ini dianggap gagal.
3. Register menghasilkan AuthSuccess tanpa menyimpan token. Arahkan pengguna ke login setelah register jika ini alur yang diinginkan. AuthSuccess dipakai bersama oleh login dan register, sehingga UI perlu mengetahui konteks operasinya.
4. `main.dart` sudah menampilkan LoginPage dan menyediakan AuthCubit. Tombol Register dan navigasi setelah login sukses masih berupa TODO.
5. Token masih ditulis melalui SharedPreferences; kode ini belum menyediakan enkripsi token. Tinjau kebutuhan penyimpanan kredensial sebelum rilis.
6. Belum ada penanganan refresh/expiry token, pemulihan sesi saat startup, maupun pengiriman header Authorization pada request berikutnya.
7. Cegah submit berulang saat AuthLoading dan pastikan lifecycle Cubit dikelola saat request masih berlangsung. Skenario request bersamaan/penutupan Cubit belum ditangani dalam perubahan ini.

## Menjalankan ulang

```sh
flutter analyze
flutter test
```

Jalankan pengujian integrasi dengan backend yang sesuai kontrak untuk login sukses/gagal, registrasi, dan logout sebelum menyatakan fitur siap digunakan.

## Pengujian emulator Android (15 September 2026)

- Memperbaiki pemanggilan constructor menjadi `AuthRemoteDataSource(dio: dio)`.
- Password dikirim apa adanya; spasi awal/akhir tidak lagi dihapus.
- Mengganti tes counter dengan tes tampilan form login, input, dan penyamaran password.
- `flutter analyze`: tidak ada masalah; `flutter test`: 21 tes lulus.
- `flutter run -d emulator-5554`: APK debug berhasil dibangun, dipasang, dan dijalankan pada Android 17 (API 37).
- Hierarchy UI memastikan judul, kolom Email/Password, tombol Login dan Register tampil.
- Menekan Login dengan form kosong menampilkan `Login gagal`; aplikasi tetap berjalan dan tombol aktif kembali. Validasi form lokal belum tersedia.
- Backend lokal port 4000 merespons HTTP 200 pada root. Port emulator diteruskan menggunakan perintah di bawah. Respons root belum membuktikan kontrak endpoint autentikasi sesuai.
- Login sukses dengan akun nyata belum diuji karena kredensial uji belum tersedia. Build release, iOS, dan perangkat fisik belum diuji.
- Log emulator menunjukkan skipped frames saat startup; performa perlu diukur terpisah pada perangkat fisik/profile mode.

Untuk menjalankan kembali dengan backend lokal aktif:

```sh
adb -s emulator-5554 reverse tcp:4000 tcp:4000
flutter run -d emulator-5554
```

Port forwarding mungkin perlu diulang setelah emulator dimulai ulang.

## Investigasi Internal Server Error

Temuan terbaru menggantikan asumsi kontrak API pada catatan sebelumnya:

- Login diagnostik ke backend lokal benar-benar menghasilkan HTTP 500.
- Query Prisma langsung gagal karena DATABASE_URL tidak memiliki password, sedangkan PostgreSQL meminta autentikasi SCRAM.
- Password yang diberikan telah diterapkan hanya pada backend/.env, tanpa commit atau pencatatan nilai. Verifikasi berikutnya menghasilkan P1000: kredensial untuk user database yang dikonfigurasi ditolak. Username/password database masih perlu dikonfirmasi sebelum backend dapat dinyatakan pulih.
- Backend login mengembalikan `access_token`. Parser Flutter dan fixture pengujian sudah disesuaikan.
- Backend register mengembalikan profil `{id, email, name}` dengan HTTP 201, tanpa token. Flutter sekarang menerima keberhasilan ini dan mengarahkan kembali ke login.
- Pesan validasi backend berbentuk list sekarang ditampilkan; HTTP 5xx tetap menjadi kegagalan dengan pesan yang dapat dipahami pengguna.
- Listener halaman login mengabaikan perubahan state saat halaman register berada di atasnya, agar registrasi tidak memunculkan notifikasi login berhasil.
- Spasi password dipertahankan pada login dan register; pemakaian withOpacity yang deprecated diganti.
- Verifikasi Flutter: analyzer bersih, 23 tes lulus. Hasil ini tidak berarti koneksi database backend sudah pulih.

Setelah memperbaiki kredensial DATABASE_URL, restart proses backend agar konfigurasi terbaru dimuat. Jangan commit file .env.

## Pemulihan backend untuk register emulator

- Pemeriksaan terbaru: koneksi PostgreSQL berhasil. Masalah kredensial pada investigasi sebelumnya sudah tidak muncul.
- Backend port 4000 ternyata tidak berjalan (`connection refused`). Backend dinyalakan kembali menggunakan `node dist/src/main.js` dari folder backend.
- Port forwarding emulator `tcp:4000` ke host `tcp:4000` sudah aktif.
- Pengujian langsung API dengan akun sementara: register HTTP 201, login HTTP 200 dan access_token tersedia. Akun sementara sudah dihapus setelah pengujian.
- Pesan kegagalan koneksi dan timeout di Flutter sekarang dibedakan dari penolakan register oleh server.
- `flutter analyze`: bersih; `flutter test`: 24 tes lulus.
- Pengujian register/login sukses di atas dilakukan langsung ke API, bukan lewat pengisian form emulator.

Saat memulai sesi pengembangan berikutnya, pastikan backend tetap berjalan. Dari folder backend jalankan `npm run start:dev`, lalu dari proyek Flutter jalankan `adb -s emulator-5554 reverse tcp:4000 tcp:4000` dan `flutter run -d emulator-5554`. Jangan menjalankan dua backend bersamaan pada port 4000.
