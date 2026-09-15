# Catatan pengujian dan perbaikan

Tanggal: 15 September 2026.

## Hasil

- Analisis awal menemukan 16 masalah. Setelah perbaikan, `flutter analyze` selesai dengan `No issues found`.
- `flutter test`: 21 tes lulus, terdiri dari 20 tes autentikasi dan 1 tes widget counter bawaan.
- Tes autentikasi memakai adapter HTTP palsu dan penyimpanan mock. Backend asli, perangkat fisik, serta build Android/iOS belum diuji.

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
4. `main.dart` masih aplikasi counter bawaan. AuthCubit belum terhubung ke layar login/register, sehingga tes widget yang lulus belum membuktikan alur autentikasi di UI.
5. Token masih ditulis melalui SharedPreferences; kode ini belum menyediakan enkripsi token. Tinjau kebutuhan penyimpanan kredensial sebelum rilis.
6. Belum ada penanganan refresh/expiry token, pemulihan sesi saat startup, maupun pengiriman header Authorization pada request berikutnya.
7. Cegah submit berulang saat AuthLoading dan pastikan lifecycle Cubit dikelola saat request masih berlangsung. Skenario request bersamaan/penutupan Cubit belum ditangani dalam perubahan ini.

## Menjalankan ulang

```sh
flutter analyze
flutter test
```

Jalankan pengujian integrasi dengan backend yang sesuai kontrak untuk login sukses/gagal, registrasi, dan logout sebelum menyatakan fitur siap digunakan.
