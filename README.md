 🎓 Sistem Otomatisasi Rekapitulasi Nilai Praktikum Mahasiswa Berbasis Stored Procedure dan Cursor

Projek ini merupakan implementasi Pemrograman Prosedural pada DBMS MySQL menggunakan **Stored Procedure**, **Explicit Cursor**, **Implicit Cursor**, dan **Control Flow Bersyarat** untuk melakukan rekapitulasi data nilai mahasiswa secara otomatis, presisi, dan *real-time*.

Projek ini disusun untuk memenuhi tugas
**Projek UTS Pemrograman Basis Data** 
Kelompok 10
Program Studi Informatika, 
Fakultas Komputer
Universitas Mega Buana Palopo.

Daftar Anggota dan  Pembagian Tugas Anggota Kelompok
Setiap anggota memiliki tanggung jawab spesifik terhadap komponen penilaian dan fitur yang diimplementasikan ke dalam sistem:

| No | Nama Anggota | NIM | Tugas & Tanggung Jawab Utama Dalam Projek |
|----|--------------|-----|-------------------------------------------|
| 1  | **Lisa Kelly** | *[Isi NIM]* | Penanggung Jawab Database, Merancang Skema Fisik Tabel, & Mengisi Data Awal (Min. 20 Data). |
| 2  | **Lilis** | *[Isi NIM]* | **Poin 3**: Logika Perhitungan Nilai Akhir & Implementasi Variabel Lokal Prosedural. |
| 3  | **Hasriani** | *[Isi NIM]* | **Poin 4**: Pembuat Logika Percabangan Bersyarat (`CASE` & `IF`) Grade, Bobot, & Status Kelulusan. |
| 4  | **Uminati** | *[IK2411011]| **Poin 5, 6, 7**: Implementasi Struktur Perulangan (`LOOP`), *Explicit Cursor*, & *Implicit Cursor* (`ROW_COUNT()`). |
| 5  | **Nuraisya** | *[Isi NIM]* | **Poin 8**: Integrasi Fitur Spesifik, Pembuat *Stored Procedure* Berparameter, & Pengujian Sistem. |

 📝 Deskripsi Sistem

    Sistem Rekapitulasi Nilai Praktikum ini dirancang untuk mengotomatisasi proses penilaian akademis mahasiswa secara *row-by-row processing* langsung di dalam server database menggunakan fitur *Stored Procedure* dan *Cursor* pada MySQL. 
    
    Tujuan utama dari sistem ini adalah menghilangkan proses kalkulasi nilai secara manual yang rentan terhadap kekeliruan manusia (*human error*). Sistem bekerja dengan cara mengambil komponen nilai mentah (Tugas, Kuis, UTS), menghitung nilai akhir berdasarkan bobot persentase tertentu, melakukan klasifikasi nilai ke dalam 10 tingkatan *grade* akademik, menentukan bobot SKS, serta menetapkan status kelulusan secara seketika (*real-time*). Selain memperbarui data pada tabel master utama, sistem ini dilengkapi dengan sistem jejak audit (*audit trail*) yang otomatis mencatat setiap riwayat pemrosesan data ke dalam tabel log terpisah demi menjaga integritas dan keamanan data.

 🏛️ Arsitektur dan Struktur Tabel

 Sistem ini dioperasikan menggunakan lima skema tabel yang saling terintegrasi melalui konstrain integritas data (*Foreign Key Constraints*):

 1. Tabel `mahasiswa` (Master Data)
```sql
CREATE TABLE mahasiswa (
    nim VARCHAR(20) PRIMARY KEY,
    nama_mahasiswa VARCHAR(100) NOT NULL,
    prodi VARCHAR(50) NOT NULL,
    angkatan INT NOT NULL
) ENGINE=InnoDB;

2. Tabel dosen (Master Data)
SQL
CREATE TABLE dosen (
    nidn VARCHAR(20) PRIMARY KEY,
    nama_dosen VARCHAR(100) NOT NULL,
    gelar VARCHAR(20) NOT NULL
) ENGINE=InnoDB;
3. Tabel mata_kuliah (Master Data)
SQL
CREATE TABLE mata_kuliah (
    kode_mk VARCHAR(10) PRIMARY KEY,
    nama_mk VARCHAR(100) NOT NULL,
    sks INT NOT NULL,
    nidn VARCHAR(20),
    FOREIGN KEY (nidn) REFERENCES dosen(nidn) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;
4. Tabel nilai_praktikum (Transaksi Data Utama)
SQL
CREATE TABLE nilai_praktikum (
    id_nilai INT AUTO_INCREMENT PRIMARY KEY,
    nim VARCHAR(20) NOT NULL,
    kode_mk VARCHAR(10) NOT NULL,
    nilai_tugas DECIMAL(5,2) NOT NULL,
    nilai_kuis DECIMAL(5,2) NOT NULL,
    nilai_uts DECIMAL(5,2) NOT NULL,
    nilai_akhir DECIMAL(5,2) NULL,
    grade VARCHAR(2) NULL,
    bobot DECIMAL(3,2) NULL,
    status_lulus VARCHAR(15) NULL,
    FOREIGN KEY (nim) REFERENCES mahasiswa(nim) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (kode_mk) REFERENCES mata_kuliah(kode_mk) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
5. Tabel log_rekap_nilai (Audit Trail Log Data)
SQL
CREATE TABLE log_rekap_nilai (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    nim VARCHAR(20) NOT NULL,
    kode_mk VARCHAR(10) NOT NULL,
    nilai_akhir DECIMAL(5,2) NOT NULL,
    grade VARCHAR(2) NOT NULL,
    bobot DECIMAL(3,2) NOT NULL,
    status_lulus VARCHAR(15) NOT NULL,
    keterangan VARCHAR(255) NOT NULL,
    waktu_proses DATETIME NOT NULL
) ENGINE=InnoDB;

🛠️ Daftar Stored Procedure Kelompok
Database ini mengemas logika bisnisnya ke dalam dua jenis program prosedural, yaitu:

1. Prosedur rekap_semua_nilai()
Prosedur global yang menggunakan Explicit Cursor untuk memproses iterasi seluruh data nilai mahasiswa tanpa filter di dalam tabel nilai_praktikum.

2. Prosedur rekap_nilai_per_mk(IN p_kode_mk VARCHAR(10))
Prosedur dinamis berspesifikasi filter parameter input untuk melakukan isolasi kalkulasi nilai rekapitulasi hanya pada mata kuliah tertentu yang dipilih.

🚀 Skrip SQL Kode Utama (Stored Procedure Lengkap)
Silakan salin seluruh kode di bawah ini dan eksekusi langsung di tab SQL phpMyAdmin Anda untuk mendaftarkan program prosedur ke dalam sistem database:

SQL
-- =========================================================================
-- PROSEDUR 1: REKAPITULASI GLOBAL (SEMUA MAHASISWA)
-- =========================================================================
DROP PROCEDURE IF EXISTS rekap_semua_nilai;
DELIMITER $$

CREATE PROCEDURE rekap_semua_nilai()
BEGIN
    -- Declarasi Variabel Lokal (Tugas Lilis)
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
    
    -- Declarasi Explicit Cursor & Handler (Tugas Uminati)
    DECLARE cursor_total CURSOR FOR 
        SELECT id_nilai, nim, kode_mk, nilai_tugas, nilai_kuis, nilai_uts FROM nilai_praktikum;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cursor_total;
    
    -- Struktur Iterasi Perulangan Data (Tugas Uminati)
    rekap_loop: LOOP
        
        FETCH cursor_total INTO v_id_nilai, v_nim, v_kode_mk, v_tugas, v_kuis, v_uts;
        
        IF done THEN
            LEAVE rekap_loop;
        END IF;
        
        -- Perhitungan Rumus Matematika Komponen Nilai Akhir (Tugas Lilis)
        SET v_nilai_akhir = (v_tugas * 0.30) + (v_kuis * 0.30) + (v_uts * 0.40);
        
        -- Percabangan Grade Dan Angka Bobot SKS (Tugas Hasriani)
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
        
        -- Percabangan Status Kelulusan Mahasiswa (Tugas Hasriani)
        IF v_grade IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C') THEN
            SET v_status = 'LULUS';
        ELSE
            SET v_status = 'TIDAK LULUS';
        END IF;
        
        -- Penguncian Sinkronisasi Data dan Logging Audit Trail (Tugas Uminati)
        UPDATE nilai_praktikum 
        SET nilai_akhir = v_nilai_akhir, grade = v_grade, bobot = v_bobot, status_lulus = v_status
        WHERE id_nilai = v_id_nilai;
        
        INSERT INTO log_rekap_nilai (nim, kode_mk, nilai_akhir, grade, bobot, status_lulus, keterangan, waktu_proses)
        VALUES (v_nim, v_kode_mk, v_nilai_akhir, v_grade, v_bobot, v_status, 'Proses Rekapitulasi Otomatis Sukses', NOW());
        
    END LOOP rekap_loop;
    
    CLOSE cursor_total;
    
    -- Eksekusi Output Fitur Implicit Cursor ROW_COUNT (Tugas Uminati)
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
    
    -- Penerapan Parameter Filter Prosedur Ke Kursor Dinamis
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
💻 Cara Menjalankan Program (Panduan Pengujian)
Buka tab SQL baru yang kosong di phpMyAdmin, kemudian ketik dan jalankan instruksi di bawah ini secara bertahap untuk mengetes performa sistem:

1. Pemanggilan Prosedur Global (Semua Mahasiswa)
SQL
CALL rekap_semua_nilai();
Hasil: Layar akan memunculkan info tabel luaran jumlah akumulasi data yang diproses secara implicit.

2. Pemanggilan Prosedur Berparameter (Per Mata Kuliah)
Fungsi ini dapat Anda panggil berulang kali secara aman untuk memfilter rekap khusus mata kuliah tertentu:

SQL
-- Mengolah khusus mata kuliah Pemrograman Basis Data
CALL rekap_nilai_per_mk('MK001');

-- Mengolah khusus mata kuliah Sistem Operasi
CALL rekap_nilai_per_mk('MK002');
3. Memverifikasi Hasil Pembaruan Data
SQL
-- Cek perubahan kolom pada tabel transaksi utama
SELECT * FROM nilai_praktikum;

-- Cek histori pencatatan pelaporan otomatis pada tabel audit trail
SELECT * FROM log_rekap_nilai;
📸 Screenshot Hasil Program
Silakan tempelkan tautan gambar hasil tangkapan layar praktikum database kelompok Anda pada tanda kurung di bawah ini:

1. Dokumentasi Tampilan Menggunakan Data Awal (Kondisi Nilai Kosong/NULL)


2. Dokumentasi Tampilan Hasil Eksekusi Output Prosedur (Implicit Cursor Info)
3. Dokumentasi Tampilan Tabel nilai_praktikum Setelah Sukses Diproses
4. Dokumentasi Tampilan Tabel log_rekap_nilai (Pencatatan Log Audit Trail)
