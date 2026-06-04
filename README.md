# 🎓 Sistem Otomatisasi Rekapitulasi Nilai Praktikum Mahasiswa

Projek ini merupakan implementasi Pemrograman Prosedural pada DBMS MySQL menggunakan **Stored Procedure**, **Explicit Cursor**, **Implicit Cursor**, dan **Control Flow Bersyarat** untuk melakukan rekapitulasi data nilai mahasiswa secara otomatis, presisi, dan *real-time*.

Projek ini disusun untuk memenuhi tugas **Projek UTS Pemrograman Basis Data** - Kelompok 10, Program Studi Informatika, Fakultas Komputer, Universitas Mega Buana Palopo.

---

## 👥 Anggota Kelompok & Pembagian Tugas

| Nama Anggota | NIM | Pembagian Tugas / Tanggung Jawab Utama |
|---|---|---|
| **Lisa Kelly** | *[Isi NIM]* | Penanggung Jawab Database, Pembuat Skema Tabel, & Penyedia Data Awal (Min. 20 Data). |
| **Lilis** | *[Isi NIM]* | **Poin 3**: Logika Perhitungan Nilai Akhir & Implementasi Manajemen Variabel Lokal. |
| **Hasriani** | *[Isi NIM]* | **Poin 4**: Pembuat Logika Percabangan Multi-Kondisi (`CASE` & `IF`) Grade, Bobot, & Status Lulus. |
| **Uminati** | *[Isi NIM]* | **Poin 5, 6, 7**: Implementasi Struktur Perulangan (`LOOP`), *Explicit Cursor*, & *Implicit Cursor* (`ROW_COUNT()`). |
| **Nuraisya** | *[Isi NIM]* | **Poin 8**: Integrasi Fitur Spesifik, Pembuat *Stored Procedure* Berparameter, & Pengujian Sistem. |

---

## 🏛️ Arsitektur dan Skema Database

Sistem ini berjalan di atas dua tabel utama yang saling berelasi secara logis pada *logic-layer* di dalam Stored Procedure:

### 1. Tabel `nilai_praktikum` (Master Transaksi)
Menyimpan data mentah komponen nilai praktikum mahasiswa beserta hasil rekapitulasi akhir.
* `id_nilai` (INT, Primary Key, Auto Increment)
* `nim` (VARCHAR(20))
* `kode_mk` (VARCHAR(10))
* `nilai_tugas` (DECIMAL(5,2))
* `nilai_kuis` (DECIMAL(5,2))
* `nilai_uts` (DECIMAL(5,2))
* `nilai_akhir` (DECIMAL(5,2), Nullable)
* `grade` (VARCHAR(2), Nullable)
* `bobot` (DECIMAL(3,2), Nullable)
* `status_lulus` (VARCHAR(15), Nullable)

### 2. Tabel `log_rekap_nilai` (Audit Trail Log)
Menyimpan riwayat dan rekam jejak digital dari setiap proses kalkulasi yang sukses dilakukan oleh sistem.
* `id_log` (INT, Primary Key, Auto Increment)
* `nim` (VARCHAR(20))
* `kode_mk` (VARCHAR(10))
* `nilai_akhir` (DECIMAL(5,2))
* `grade` (VARCHAR(2))
* `bobot` (DECIMAL(3,2))
* `status_lulus` (VARCHAR(15))
* `keterangan` (VARCHAR(255))
* `waktu_proses` (DATETIME)

---

## 🛠️ Fitur dan Komponen Utama Sistem

1. **Server-Side Processing**: Perhitungan dilakukan langsung di dalam mesin database untuk mengurangi beban latensi transfer data aplikasi.
2. **Precision Decimal Calculation**: Menggunakan tipe data `DECIMAL` untuk menjaga akurasi pecahan nilai dan menghindari pembulatan otomatis yang keliru.
3. **Automated Grade & Status Mapping**: Mengklasifikasikan nilai akhir ke dalam 10 tingkatan standar grade akademik (A hingga E) beserta status kelulusan (`LULUS` / `TIDAK LULUS`) menggunakan kondisi bersyarat `CASE WHEN`.
4. **Row-by-Row Cursor Processing**: Memanfaatkan *Explicit Cursor* berkombinasi dengan `CONTINUE HANDLER FOR NOT FOUND` untuk menjelajahi data secara aman sekuensial.
5. **Data Audit Logging**: Mengintegrasikan sistem pelaporan otomatis (*audit trail*) ke tabel log seketika setelah data diperbarui.
6. **Dynamic Filtering**: Mendukung kalkulasi fleksibel per mata kuliah tertentu melalui parameter input prosedur.

---

## 🚀 Panduan Instalasi dan Penggunaan

### 1. Import Struktur Tabel dan Data Mentah
Pastikan Anda sudah membuat database bernama `uts_pbd_kelompok_10` dan meng-import tabel beserta minimal 20 data mentah mahasiswa (pastikan kolom `nilai_akhir`, `grade`, `bobot`, dan `status_lulus` dalam kondisi kosong/NULL).

### 2. Skrip SQL Kode Utama (Stored Procedure)
Salin dan jalankan kueri berikut di tab SQL phpMyAdmin Anda untuk mendaftarkan kedua program prosedur ke dalam database:

```sql
-- =========================================================================
-- PROSEDUR 1: REKAPITULASI GLOBAL (SEMUA MAHASISWA)
-- =========================================================================
DROP PROCEDURE IF EXISTS rekap_semua_nilai;
DELIMITER $$

CREATE PROCEDURE rekap_semua_nilai()
BEGIN
    -- 1. DEKLARASI VARIABEL LOKAL (Tugas Lilis)
    DECLARE v_id_nilai INT;
    DECLARE v_nim VARCHAR(20);
    DECLARE v_kode_mk VARCHAR(10);
    DECLARE v_tugas DECIMAL(5,2);
    DECLARE v_kuis DECIMAL(5,2);
    DECLARE v_uts DECIMAL(5,2);
    
    DECLARE v_nilai_akhir DECIMAL(5,2);
    DECLARE v_grade VARCHAR(2);
    DECLARE v_bobot DECIMAL(3,2);
    DECLARE v_status VARCHAR(15);
    
    DECLARE done INT DEFAULT FALSE;
    
    -- 2. DEKLARASI EXPLICIT CURSOR & HANDLER (Tugas Uminati)
    DECLARE cursor_total CURSOR FOR 
        SELECT id_nilai, nim, kode_mk, nilai_tugas, nilai_kuis, nilai_uts FROM nilai_praktikum;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cursor_total;
    
    -- 3. PERULANGAN DATA (Tugas Uminati)
    rekap_loop: LOOP
        
        FETCH cursor_total INTO v_id_nilai, v_nim, v_kode_mk, v_tugas, v_kuis, v_uts;
        
        IF done THEN
            LEAVE rekap_loop;
        END IF;
        
        -- 4. PERHITUNGAN RUMUS NILAI AKHIR (Tugas Lilis)
        SET v_nilai_akhir = (v_tugas * 0.30) + (v_kuis * 0.30) + (v_uts * 0.40);
        
        -- 5. PERCABANGAN GRADE, BOBOT & STATUS (Tugas Hasriani)
        CASE 
            WHEN v_nilai_akhir BETWEEN 93.00 AND 100.00 THEN SET v_grade = 'A',  v_bobot = 4.00;
            WHEN v_nilai_akhir BETWEEN 85.00 AND 92.99  THEN SET v_grade = 'A-', v_bobot = 3.75;
            WHEN v_nilai_akhir BETWEEN 81.00 AND 84.99  THEN SET v_grade = 'B+', v_bobot = 3.50;
            WHEN v_nilai_akhir BETWEEN 75.00 AND 80.99  THEN SET v_grade = 'B',  v_bobot = 3.25;
            WHEN v_nilai_akhir BETWEEN 71.00 AND 74.99  THEN SET v_grade = 'B-', v_bobot = 3.00;
            WHEN v_nilai_akhir BETWEEN 66.00 AND 70.99  THEN SET v_grade = 'C+', v_bobot = 2.75;
            WHEN v_nilai_akhir BETWEEN 61.00 AND 65.99  THEN SET v_grade = 'C',  v_bobot = 2.50;
            WHEN v_nilai_akhir BETWEEN 56.00 AND 60.99  THEN SET v_grade = 'C-', v_bobot = 2.00;
            WHEN v_nilai_akhir BETWEEN 40.00 AND 55.99  THEN SET v_grade = 'D',  v_bobot = 1.00;
            ELSE SET v_grade = 'E', v_bobot = 0.00;
        END CASE;
        
        IF v_grade IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C') THEN
            SET v_status = 'LULUS';
        ELSE
            SET v_status = 'TIDAK LULUS';
        END IF;
        
        -- 6. UPDATE TABEL UTAMA & LOGGING DATA (Tugas Uminati)
        UPDATE nilai_praktikum 
        SET nilai_akhir = v_nilai_akhir, grade = v_grade, bobot = v_bobot, status_lulus = v_status
        WHERE id_nilai = v_id_nilai;
        
        INSERT INTO log_rekap_nilai (nim, kode_mk, nilai_akhir, grade, bobot, status_lulus, keterangan, waktu_proses)
        VALUES (v_nim, v_kode_mk, v_nilai_akhir, v_grade, v_bobot, v_status, 'Proses Rekapitulasi Otomatis Sukses', NOW());
        
    END LOOP rekap_loop;
    
    CLOSE cursor_total;
    
    -- 7. IMPLICIT CURSOR ROW_COUNT (Tugas Uminati)
    SELECT ROW_COUNT() AS jumlah_data_diproses;

END$$

-- =========================================================================
-- PROSEDUR 2: REKAPITULASI SELEKTIF BERPARAMETER (Tugas Nuraisya)
-- =========================================================================
DROP PROCEDURE IF EXISTS rekap_nilai_per_mk;
CREATE PROCEDURE rekap_nilai_per_mk(IN p_kode_mk VARCHAR(10))
BEGIN
    DECLARE v_id_nilai INT;
    DECLARE v_nim VARCHAR(20);
    DECLARE v_kode_mk VARCHAR(10);
    DECLARE v_tugas DECIMAL(5,2);
    DECLARE v_kuis DECIMAL(5,2);
    DECLARE v_uts DECIMAL(5,2);
    
    DECLARE v_nilai_akhir DECIMAL(5,2);
    DECLARE v_grade VARCHAR(2);
    DECLARE v_bobot DECIMAL(3,2);
    DECLARE v_status VARCHAR(15);
    
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE cursor_per_mk CURSOR FOR 
        SELECT id_nilai, nim, kode_mk, nilai_tugas, nilai_kuis, nilai_uts 
        FROM nilai_praktikum
        WHERE kode_mk = p_kode_mk;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cursor_per_mk;
    
    rekap_loop: LOOP
        
        FETCH cursor_per_mk INTO v_id_nilai, v_nim, v_kode_mk, v_tugas, v_kuis, v_uts;
        
        IF done THEN
            LEAVE rekap_loop;
        END IF;
        
        SET v_nilai_akhir = (v_tugas * 0.30) + (v_kuis * 0.30) + (v_uts * 0.40);
        
        CASE 
            WHEN v_nilai_akhir BETWEEN 93.00 AND 100.00 THEN SET v_grade = 'A',  v_bobot = 4.00;
            WHEN v_nilai_akhir BETWEEN 85.00 AND 92.99  THEN SET v_grade = 'A-', v_bobot = 3.75;
            WHEN v_nilai_akhir BETWEEN 81.00 AND 84.99  THEN SET v_grade = 'B+', v_bobot = 3.50;
            WHEN v_nilai_akhir BETWEEN 75.00 AND 80.99  THEN SET v_grade = 'B',  v_bobot = 3.25;
            WHEN v_nilai_akhir BETWEEN 71.00 AND 74.99  THEN SET v_grade = 'B-', v_bobot = 3.00;
            WHEN v_nilai_akhir BETWEEN 66.00 AND 70.99  THEN SET v_grade = 'C+', v_bobot = 2.75;
            WHEN v_nilai_akhir BETWEEN 61.00 AND 65.99  THEN SET v_grade = 'C',  v_bobot = 2.50;
            WHEN v_nilai_akhir BETWEEN 56.00 AND 60.99  THEN SET v_grade = 'C-', v_bobot = 2.00;
            WHEN v_nilai_akhir BETWEEN 40.00 AND 55.99  THEN SET v_grade = 'D',  v_bobot = 1.00;
            ELSE SET v_grade = 'E', v_bobot = 0.00;
        END CASE;
        
        IF v_grade IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C') THEN
            SET v_status = 'LULUS';
        ELSE
            SET v_status = 'TIDAK LULUS';
        END IF;
        
        UPDATE nilai_praktikum 
        SET nilai_akhir = v_nilai_akhir, grade = v_grade, bobot = v_bobot, status_lulus = v_status
        WHERE id_nilai = v_id_nilai;
        
        INSERT INTO log_rekap_nilai (nim, kode_mk, nilai_akhir, grade, bobot, status_lulus, keterangan, waktu_proses)
        VALUES (v_nim, v_kode_mk, v_nilai_akhir, v_grade, v_bobot, v_status, CONCAT('Rekap Khusus Mata Kuliah: ', p_kode_mk), NOW());
        
    END LOOP rekap_loop;
    
    CLOSE cursor_per_mk;
    
    SELECT ROW_COUNT() AS jumlah_data_mk_diproses;

END$$

DELIMITER ;


3. Perintah Eksekusi / Uji Coba Pengujian
Buka tab SQL baru yang kosong di phpMyAdmin, jalankan instruksi di bawah ini untuk mengetes performa sistem:

Skenario A: Memproses Semua Data Mahasiswa Sekaligus

SQL
CALL rekap_semua_nilai();
Skenario B: Memproses Data Secara Selektif Menggunakan Parameter Filter MK

SQL
CALL rekap_nilai_per_mk('MK001');
CALL rekap_nilai_per_mk('MK002');
Skenario C: Memverifikasi Hasil Pembaruan dan Riwayat Log Audit

SQL
SELECT * FROM nilai_praktikum;
SELECT * FROM log_rekap_nilai;
📝 Ringkasan Analisis Logika Kode
Variabel Lokal (DECLARE): Digunakan untuk menyimpan sementara data komponen nilai aktif dari tabel fisik ke memori operasional RAM sebelum diproses kalkulasi rumus matematika.

Percabangan (CASE WHEN): Memvalidasi kondisi berlapis untuk memetakan rentang nilai akhir ke dalam representasi string nilai huruf beserta angka bobot SKS secara inklusif.

Perulangan (LOOP): Memutar pembacaan baris tabel baris demi baris, dikunci dengan statemen LEAVE untuk memutus perputaran kursor saat kondisi handler NOT FOUND terpenuhi demi mencegah malapetaka infinite loop.

Explicit Cursor: Komponen inti pembuat penunjuk (pointer result-set) data kueri internal tabel agar sekumpulan baris dapat dieksekusi secara berurutan.

Implicit Cursor (ROW_COUNT()): Mengambil data konfirmasi internal mesin MySQL secara otomatis untuk menampilkan berapa total baris data yang sukses termanipulasi di kueri UPDATE terakhir.

Cursor Parameter: Menggunakan argumentasi masukan prosedur (IN) untuk menyaring data kursor langsung pada klausa WHERE, sangat menghemat penggunaan alokasi ruang memori database server.


