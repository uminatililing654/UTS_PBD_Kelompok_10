# UTS PBD Kelompok 10
 Sistem Rekap Nilai Praktikum Mahasiswa

Projek ini merupakan tugas Ujian Tengah Semester (UTS) untuk mata kuliah **Pemrograman Basis Data**. Sistem ini dirancang menggunakan DBMS MySQL (melalui XAMPP / phpMyAdmin) untuk membantu dosen dalam mengelola, mengalkulasi, dan mendokumentasikan rekapitulasi nilai praktikum mahasiswa secara otomatis dan relasional.

 # Daftar Anggota Kelompok & Pembagian Tugas
Sesuai dengan ketentuan pembagian tugas kelompok 5 orang, berikut adalah tanggung jawab masing-masing anggota:

| Anggota | Nama Mahasiswa | NIM | Tanggung Jawab / Kontribusi Kode |
Anggota 1 Lisa Kelly(IK2411010)  Membuat database, struktur 6 tabel, mendefinisikan relasi (`Primary Key` & `Foreign Key`), serta menyusun data awal. 
Anggota 2 Lilis(IK2411012) Merancang arsitektur penyimpanan dan perhitungan `nilai_akhir` menggunakan variabel lokal di dalam *Stored Procedure.
Anggota 3 Hasriani(IK24110) Menyusun logika kontrol percabangan (`CASE WHEN` & `IF-ELSE`) untuk penentuan grade, bobot, status kelulusan, serta struktur perulangan (`LOOP`).
Anggota 4 Uminati(IK2411011) Membuat kontrol aliran data menggunakan `Explicit Cursor`, menangani pembatasan parameter cursor, serta mengimplementasikan `Implicit Cursor`. 
Anggota 5 Nuraisya Masdin(IK2411015) Menyusun seluruh file dokumentasi laporan PDF, mengelola berkas *repository* GitHub (README.md), serta melakukan pengujian program.
📝 Deskripsi Sistem
Sistem database ini menangani otomatisasi pengolahan nilai praktikum mahasiswa. Nilai tugas (30%), kuis (30%), dan UTS (40%) yang diinput secara mentah akan dikalkulasi secara otomatis oleh sistem menjadi **Nilai Akhir**. 
Berdasarkan nilai akhir tersebut, sistem akan menentukan **Grade** (A sampai E), **Bobot Nilai**, serta **Status Kelulusan** (LULUS jika minimal Grade C). Setiap kali proses rekap dijalankan, riwayat proses dan *timestamp* waktu eksekusi akan langsung dicatat ke dalam tabel log audit (`log_rekap_nilai`).

 📊 Struktur Tabel
Sistem ini menggunakan 6 tabel utama yang saling berelasi:
1. `mahasiswa`: Data identitas mahasiswa (`nim` sebagai Primary Key).
2. `dosen`: Data dosen pengampu mata kuliah (`kode_dosen` sebagai Primary Key).
3. `mata_kuliah`: Data mata kuliah (`kode_mk` sebagai Primary Key, `kode_dosen` sebagai Foreign Key).
4. `grade_nilai`: Standar konversi acuan nilai (`grade` sebagai Primary Key).
5. `nilai_praktikum`: Penyimpanan komponen nilai praktikum (`id_nilai` sebagai Primary Key, memiliki relasi Foreign Key ke tabel mahasiswa, mata_kuliah, dan grade_nilai).
6. `log_rekap_nilai`: Pencatatan riwayat transaksi aktivitas rekap nilai (`id_log` sebagai Primary Key).

 🛠️ Daftar Stored Procedure
rekap_semua_nilai()
    * *Fungsi*: Memproses seluruh data nilai mahasiswa secara massal menggunakan gabungan *Explicit Cursor*, perulangan, dan diakhiri penayangan jumlah baris terubah menggunakan *Implicit Cursor* (`ROW_COUNT()`).
* **`rekap_nilai_per_mk(IN p_kode_mk VARCHAR(10))`**
    * *Fungsi*: Memproses rekapitulasi nilai secara spesifik dan dinamis berdasarkan filter parameter kode mata kuliah yang dimasukkan oleh dosen.

 Cara Menjalankan Program
1.  Buka **XAMPP Control Panel** dan aktifkan modul **Apache** serta **MySQL**.
2.  Buka browser dan masuk ke **phpMyAdmin** (`http://localhost/phpmyadmin/`).
3.  Buat database baru bernama `uts_pbd_kelompok_[NomorKelompok]` (Contoh: `uts_pbd_kelompok_03`).
4.  Masuk ke database tersebut, lalu buka tab **SQL**.
5.  Salin dan jalankan isi file `database.sql` untuk membentuk struktur tabel dan relasinya.
6.  Salin dan jalankan isi file `data_awal.sql` untuk memasukkan seluruh data master awal.
7.  Salin dan jalankan isi file `procedure_rekap_nilai.sql` untuk mendaftarkan kedua *Stored Procedure* ke dalam sistem database.
8.  Buka file `query_pengujian.sql` dan jalankan perintah `CALL` untuk menguji jalannya program rekap nilai.

 📸 Screenshot Hasil Program
*(Bagian ini wajib Anda isi dengan menempelkan link gambar atau file screenshot hasil eksekusi program phpMyAdmin kelompok Anda)*

### 1. Data Awal Sebelum Diproses
*(Tempel screenshot kueri SELECT * FROM nilai_praktikum; saat kolom nilai_akhir masih NULL)*

### 2. Hasil Eksekusi Stored Procedure (Output Implicit Cursor)
*(Tempel screenshot baris angka hasil CALL rekap_semua_nilai();)*

### 3. Tabel Nilai Praktikum Setelah Diproses Berhasil
*(Tempel screenshot tabel nilai_praktikum yang sudah terisi otomatis kolom grade dan kelulusannya)*

### 4. Isi Tabel Log Rekap Nilai (Audit Trail)
*(Tempel screenshot data riwayat dari tabel log_rekap_nilai)*
