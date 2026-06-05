USE uts_pbd_kelompok_10;

DROP PROCEDURE IF EXISTS rekap_semua_nilai;

DELIMITER $$

CREATE PROCEDURE rekap_semua_nilai()
BEGIN
    DECLARE v_id_nilai INT;
    DECLARE v_nim VARCHAR(15);
    DECLARE v_kode_mk VARCHAR(15);
    DECLARE v_tugas DECIMAL(5,2);
    DECLARE v_kuis DECIMAL(5,2);
    DECLARE v_uts DECIMAL(5,2);
    DECLARE v_nilai_akhir DECIMAL(5,2);
    DECLARE v_grade VARCHAR(5);
    DECLARE v_bobot DECIMAL(3,2);
    DECLARE v_status_lulus VARCHAR(15);
    DECLARE v_hitung INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;

    DECLARE cursor_nilai CURSOR FOR 
        SELECT id_nilai, nim, kode_mk, nilai_tugas, nilai_kuis, nilai_uts 
        FROM nilai_praktikum;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cursor_nilai;

    rekap_loop: LOOP
        FETCH cursor_nilai INTO v_id_nilai, v_nim, v_kode_mk, v_tugas, v_kuis, v_uts;

        IF done THEN 
            LEAVE rekap_loop;
        END IF;

        SET v_nilai_akhir = (v_tugas * 0.30) + (v_kuis * 0.30) + (v_uts * 0.40);

        CASE 
            WHEN v_nilai_akhir BETWEEN 93.00 AND 100.00 THEN SET v_grade = 'A', v_bobot = 4.00;
            WHEN v_nilai_akhir BETWEEN 85.00 AND 92.99 THEN SET v_grade = 'A-', v_bobot = 3.75;
            WHEN v_nilai_akhir BETWEEN 81.00 AND 84.99 THEN SET v_grade = 'B+', v_bobot = 3.50;
            WHEN v_nilai_akhir BETWEEN 75.00 AND 80.99 THEN SET v_grade = 'B', v_bobot = 3.25;
            WHEN v_nilai_akhir BETWEEN 71.00 AND 74.99 THEN SET v_grade = 'B-', v_bobot = 3.00;
            WHEN v_nilai_akhir BETWEEN 66.00 AND 70.99 THEN SET v_grade = 'C+', v_bobot = 2.75;
            WHEN v_nilai_akhir BETWEEN 61.00 AND 65.99 THEN SET v_grade = 'C', v_bobot = 2.50;
            WHEN v_nilai_akhir BETWEEN 56.00 AND 60.99 THEN SET v_grade = 'C-', v_bobot = 2.00;
            WHEN v_nilai_akhir BETWEEN 40.00 AND 55.99 THEN SET v_grade = 'D', v_bobot = 1.00;
            ELSE SET v_grade = 'E', v_bobot = 0.00;
        END CASE;

        IF v_grade IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C') THEN
            SET v_status_lulus = 'LULUS';
        ELSE
            SET v_status_lulus = 'TIDAK LULUS';
        END IF;

        UPDATE nilai_praktikum 
        SET nilai_akhir = v_nilai_akhir,
            grade = v_grade,
            bobot = v_bobot,
            status_lulus = v_status_lulus
        WHERE id_nilai = v_id_nilai;

        SET v_hitung = v_hitung + 1;

        INSERT INTO log_rekap_nilai (nim, kode_mk, nilai_akhir, grade, bobot, status_lulus, keterangan)
        VALUES (v_nim, v_kode_mk, v_nilai_akhir, v_grade, v_bobot, v_status_lulus, 'Rekap otomatis seluruh mahasiswa sukses');

    END LOOP rekap_loop;

    CLOSE cursor_nilai;

    SELECT v_hitung AS jumlah_data_diproses;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS rekap_nilai_per_mk;

DELIMITER $$

CREATE PROCEDURE rekap_nilai_per_mk(IN p_kode_mk VARCHAR(15))
BEGIN
    DECLARE v_id_nilai INT;
    DECLARE v_nim VARCHAR(15);
    DECLARE v_kode_mk VARCHAR(15);
    DECLARE v_tugas DECIMAL(5,2);
    DECLARE v_kuis DECIMAL(5,2);
    DECLARE v_uts DECIMAL(5,2);
    DECLARE v_nilai_akhir DECIMAL(5,2);
    DECLARE v_grade VARCHAR(5);
    DECLARE v_bobot DECIMAL(3,2);
    DECLARE v_status_lulus VARCHAR(15);
    DECLARE v_hitung INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;

    DECLARE cursor_per_mk CURSOR FOR 
        SELECT id_nilai, nim, kode_mk, nilai_tugas, nilai_kuis, nilai_uts 
        FROM nilai_praktikum
        WHERE kode_mk = p_kode_mk;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cursor_per_mk;

    rekap_mk_loop: LOOP
        FETCH cursor_per_mk INTO v_id_nilai, v_nim, v_kode_mk, v_tugas, v_kuis, v_uts;

        IF done THEN 
            LEAVE rekap_mk_loop;
        END IF;

        SET v_nilai_akhir = (v_tugas * 0.30) + (v_kuis * 0.30) + (v_uts * 0.40);

        CASE 
            WHEN v_nilai_akhir BETWEEN 93.00 AND 100.00 THEN SET v_grade = 'A', v_bobot = 4.00;
            WHEN v_nilai_akhir BETWEEN 85.00 AND 92.99 THEN SET v_grade = 'A-', v_bobot = 3.75;
            WHEN v_nilai_akhir BETWEEN 81.00 AND 84.99 THEN SET v_grade = 'B+', v_bobot = 3.50;
            WHEN v_nilai_akhir BETWEEN 75.00 AND 80.99 THEN SET v_grade = 'B', v_bobot = 3.25;
            WHEN v_nilai_akhir BETWEEN 71.00 AND 74.99 THEN SET v_grade = 'B-', v_bobot = 3.00;
            WHEN v_nilai_akhir BETWEEN 66.00 AND 70.99 THEN SET v_grade = 'C+', v_bobot = 2.75;
            WHEN v_nilai_akhir BETWEEN 61.00 AND 65.99 THEN SET v_grade = 'C', v_bobot = 2.50;
            WHEN v_nilai_akhir BETWEEN 56.00 AND 60.99 THEN SET v_grade = 'C-', v_bobot = 2.00;
            WHEN v_nilai_akhir BETWEEN 40.00 AND 55.99 THEN SET v_grade = 'D', v_bobot = 1.00;
            ELSE SET v_grade = 'E', v_bobot = 0.00;
        END CASE;

        IF v_grade IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C') THEN
            SET v_status_lulus = 'LULUS';
        ELSE
            SET v_status_lulus = 'TIDAK LULUS';
        END IF;

        UPDATE nilai_praktikum 
        SET nilai_akhir = v_nilai_akhir,
            grade = v_grade,
            bobot = v_bobot,
            status_lulus = v_status_lulus
        WHERE id_nilai = v_id_nilai;

        SET v_hitung = v_hitung + 1;

        INSERT INTO log_rekap_nilai (nim, kode_mk, nilai_akhir, grade, bobot, status_lulus, keterangan)
        VALUES (v_nim, v_kode_mk, v_nilai_akhir, v_grade, v_bobot, v_status_lulus, CONCAT('Rekap sukses via parameter untuk MK: ', p_kode_mk));

    END LOOP rekap_mk_loop;

    CLOSE cursor_per_mk;

    SELECT v_hitung AS jumlah_data_diproses;
END$$

DELIMITER ;