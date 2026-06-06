 UTS Pemrograman Basis Data - Kelompok 10

1. Judul Projek
Sistem Otomatisasi Rekapitulasi Nilai Praktikum Berbasis Stored Procedure dan Explicit Cursor pada Database MySQL

 2. Nama Kelompok & Daftar Anggota
*Kelompok 10 - Kelas Informatika*

* Lisa kelly (Anggota 1) - NIM:IK2411010
* Lilis (Anggota 2) - NIM:IK2411012
* Hasriani (Anggota 3) - NIM:IK2411040
* Uminati (Anggota 4) - NIM:IK2411011
* Nur aisyah Masdin (Anggota 5) - NIM:IK2411014

 3. Deskripsi Sistem
Sistem ini dirancang untuk mengotomatisasi proses kalkulasi nilai akhir, penentuan grade, pemberian bobot, hingga pembaruan status kelulusan mahasiswa pada mata kuliah praktikum. Sistem bekerja secara transaksional menggunakan konsep pemrograman basis data lanjutan di MySQL, yaitu *Stored Procedure*, *Explicit Cursor*, perulangan (*Loop*), dan kondisional (*Case/If*). Setiap kali rekapitulasi dilakukan, sistem juga secara otomatis mencatat riwayat eksekusi ke dalam tabel log sebagai fungsi audit database.


4. Struktur Tabel
Projek ini menggunakan 6 tabel terintegrasi dengan mesin penyimpanan InnoDB dan relasi Foreign Key yang ketat:
1. **dosen**: Menyimpan data master dosen pengampu.
2. **mahasiswa**: Menyimpan data master identitas mahasiswa.
3. **grade_nilai**: Menyimpan batas acuan nilai atas, nilai bawah, huruf grade, dan bobot.
4. **mata_kuliah**: Menyimpan data mata kuliah yang terikat dengan kode dosen pengampu.
5. **nilai_praktikum**: Tabel utama yang menampung komponen nilai mentah serta hasil kalkulasi akhir.
6. **log_rekap_nilai**: Tabel audit untuk mencatat setiap aktivitas eksekusi rekapitulasi nilai.


 5. Daftar Stored Procedure
*rekap_semua_nilai()*
  Melakukan pemrosesan massal untuk seluruh baris data yang ada pada tabel nilai menggunakan *Explicit Cursor*.
*rekap_nilai_per_mk(p_kode_mk)*
  Melakukan pemrosesan paralel yang fleksibel dengan menyaring data mahasiswa berdasarkan parameter input Kode Mata Kuliah tertentu.


# 6. Pembagian Tugas Anggota
* Lisa Kelly (Anggota 1): Menyusun struktur database (DDL), menentukan relasi *Foreign Key*, serta menyiapkan *dummy data* awal (DML) sebanyak 20 data mahasiswa.
* Lilis (Anggota 2): Menyusun algoritma variabel lokal serta rumus perhitungan Nilai Akhir berbasis persentase bobot tugas, kuis, dan UTS di dalam procedure.
* Hasriani (Anggota 3) : Menyusun logika percabangan `CASE` untuk konversi nilai ke huruf grade/bobot, serta kondisi `IF` untuk menentukan status kelulusan.
* Uminati (Anggota 4): Menyusun perintah `UPDATE` ke tabel utama, perintah `INSERT` data riwayat ke tabel log, serta mekanisme penutupan cursor di akhir perulangan.
* Nur aisyah Masdin (Anggota 5): Menyusun skrip pengujian sistem dari kondisi awal hingga akhir, melakukan uji coba eksekusi (CALL), serta menyusun dokumentasi laporan akhir.


7. Cara Menjalankan Program
Jalankan file SQL di dalam phpMyAdmin secara berurutan sesuai dengan penomoran file berikut:
1. Impor file `database.sql` untuk membuat struktur skema dan tabel.
2. Impor file `data_awal.sql` untuk mengisi data master dan nilai awal mahasiswa.
3. Impor file `procedure_rekap_nilai.sql` untuk menanamkan kedua *Stored Procedure* ke dalam MySQL server.
4. Jalankan perintah di dalam file `query_pengujian.sql` pada menu SQL phpMyAdmin untuk melihat hasil eksekusi program.

 8. Screenshot Hasil Program
*(Silakan unggah gambar screenshot kalian ke repositori GitHub ini, lalu sesuaikan jalur pemanggilan gambarnya di bawah ini)*

 Hasil Eksekusi Procedure Utama (Massal)
Menampilkan keberhasilan pemrosesan seluruh data (20 baris data mahasiswa):
![Hasil Rekap Massal](screenshot_rekap_massal.jpg)

### Hasil Eksekusi Procedure Spesifik (Parameter MK001)
Menampilkan keberhasilan penyaringan data berdasarkan kode mata kuliah (12 baris data mahasiswa):
![Hasil Rekap Parameter](screenshot_rekap_parameter.jpg)
