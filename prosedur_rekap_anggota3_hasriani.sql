-- ==================================================
-- BAGIAN ANGGOTA 3: PERCABANGAN & PERULANGAN
-- Sesuai ketentuan halaman 7-8 soal
-- ==================================================

-- Ubah pemisah kode (WAJIB di MySQL)
DELIMITER //

-- Buat / Ganti Stored Procedure
CREATE OR REPLACE PROCEDURE rekap_semua_nilai()
BEGIN
    -- ==============================================
    -- DEKLARASI VARIABEL & PENANDA (UNTUK PERULANGAN)
    -- ==============================================
    -- Variabel penanda kapan perulangan berhenti
    DECLARE data_selesai BOOLEAN DEFAULT FALSE;
    
    -- Variabel untuk menampung data dari tabel (WAJIB, karena TIDAK BOLEH pakai SELECT biasa)
    DECLARE v_id_nilai       INT;
    DECLARE v_nilai_akhir    DECIMAL(5,2);
    DECLARE v_grade          VARCHAR(2);
    DECLARE v_bobot          DECIMAL(3,2);
    DECLARE v_status_lulus   VARCHAR(15);
    
    -- Variabel hasil hitungan dari Anggota 2 (nanti disambung)
    DECLARE v_tugas, v_kuis, v_uts DECIMAL(5,2);

    -- ==============================================
    -- DEKLARASI PERULANGAN (SYARAT WAJIB SOAL)
    -- Boleh pakai LOOP/WHILE/REPEAT -> di sini saya pakai LOOP
    -- ==============================================
    -- Kita ambil semua data nilai yang mau diproses
    DECLARE daftar_nilai CURSOR FOR
        SELECT id_nilai, nilai_tugas, nilai_kuis, nilai_uts
        FROM nilai_praktikum;

    -- Penanda kalau data sudah habis, ubah jadi TRUE
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET data_selesai = TRUE;

    -- ==============================================
    -- BUKA PERULANGAN
    -- ==============================================
    OPEN daftar_nilai;

    -- ⛔ ATURAN SOAL: TIDAK BOLEH HANYA MENGGUNAKAN QUERY SELECT BIASA
    -- ✅ SOLUSI: Kita ambil dan proses DATA PER SATU BARIS pakai LOOP
    proses_semua_data: LOOP

        -- Ambil data satu per satu dari tabel
        FETCH daftar_nilai INTO v_id_nilai, v_tugas, v_kuis, v_uts;

        -- Jika data habis, BERHENTI
        IF data_selesai THEN
            LEAVE proses_semua_data;
        END IF;

        -- ==============================================
        -- 🔽🔽🔽 DI SINI NANTI DISAMBUNG KODE ANGGOTA 2 🔽🔽🔽
        -- (Perhitungan Nilai Akhir pakai Variabel)
        -- Contoh: SET v_nilai_akhir = (v_tugas*0.3)+(v_kuis*0.3)+(v_uts*0.4);
        -- ==============================================
        -- SEMENTARA KITA ISI CONTOH RUMUS DI SINI DULU
        SET v_nilai_akhir = (v_tugas * 0.30) + (v_kuis * 0.30) + (v_uts * 0.40);
        -- ==============================================


        -- ==============================================
        -- ✅ BAGIAN UTAMA KAMU: PERCABANGAN GRADE
        -- Sesuai ketentuan BAGIAN G di soal
        -- ==============================================
        CASE
            -- Rentang Nilai: 93.00 - 100.00
            WHEN v_nilai_akhir BETWEEN 93.00 AND 100.00 THEN
                SET v_grade = 'A', v_bobot = 4.00;
            
            -- Rentang Nilai: 85.00 - 92.99
            WHEN v_nilai_akhir BETWEEN 85.00 AND 92.99 THEN
                SET v_grade = 'A-', v_bobot = 3.75;

            -- Rentang Nilai: 81.00 - 84.99
            WHEN v_nilai_akhir BETWEEN 81.00 AND 84.99 THEN
                SET v_grade = 'B+', v_bobot = 3.50;

            -- Rentang Nilai: 75.00 - 80.99
            WHEN v_nilai_akhir BETWEEN 75.00 AND 80.99 THEN
                SET v_grade = 'B', v_bobot = 3.25;

            -- Rentang Nilai: 71.00 - 74.99
            WHEN v_nilai_akhir BETWEEN 71.00 AND 74.99 THEN
                SET v_grade = 'B-', v_bobot = 3.00;

            -- Rentang Nilai: 66.00 - 70.99
            WHEN v_nilai_akhir BETWEEN 66.00 AND 70.99 THEN
                SET v_grade = 'C+', v_bobot = 2.75;

            -- Rentang Nilai: 61.00 - 65.99  ✅ BATAS MINIMAL LULUS
            WHEN v_nilai_akhir BETWEEN 61.00 AND 65.99 THEN
                SET v_grade = 'C', v_bobot = 2.50;

            -- Rentang Nilai: 56.00 - 60.99
            WHEN v_nilai_akhir BETWEEN 56.00 AND 60.99 THEN
                SET v_grade = 'C-', v_bobot = 2.00;

            -- Rentang Nilai: 40.00 - 55.99
            WHEN v_nilai_akhir BETWEEN 40.00 AND 55.99 THEN
                SET v_grade = 'D', v_bobot = 1.00;

            -- Rentang Nilai: 0.00 - 39.99
            ELSE
                SET v_grade = 'E', v_bobot = 0.00;
        END CASE;


        -- ==============================================
        -- ✅ BAGIAN UTAMA KAMU: PERCABANGAN STATUS KELULUSAN
        -- Sesuai ketentuan BAGIAN H di soal
        -- ==============================================
        IF v_grade IN ('A','A-','B+','B','B-','C+','C') THEN
            SET v_status_lulus = 'LULUS';  -- Grade C ke atas = LULUS
        ELSE
            SET v_status_lulus = 'TIDAK LULUS'; -- C-, D, E = TIDAK LULUS
        END IF;


        -- ==============================================
        -- SIMPAN HASIL KE TABEL
        -- (Ini nanti akan dibungkus lagi sama Anggota 4 pakai Cursor)
        -- ==============================================
        UPDATE nilai_praktikum
        SET 
            nilai_akhir  = v_nilai_akhir,
            grade        = v_grade,
            bobot        = v_bobot,
            status_lulus = v_status_lulus
        WHERE id_nilai = v_id_nilai;

    -- AKHIR PERULANGAN
    END LOOP proses_semua_data;

    -- Tutup proses ambil data
    CLOSE daftar_nilai;

    -- ✅ SESUAI KETENTUAN: Tampilkan jumlah data yang diproses (Implicit Cursor)
    SELECT ROW_COUNT() AS Jumlah_Data_Yang_Diproses;

END //

DELIMITER ;
-- ==================================================
-- SELESAI BAGIAN ANGGOTA 3
-- ==================================================