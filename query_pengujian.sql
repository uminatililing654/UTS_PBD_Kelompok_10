
SELECT * FROM mahasiswa;
SELECT * FROM dosen;
SELECT * FROM mata_kuliah;
SELECT * FROM grade_nilai;

SELECT * FROM nilai_praktikum;

SELECT * FROM log_rekap_nilai;

CALL rekap_semua_nilai();

CALL rekap_nilai_per_mk('MK001');

SELECT * FROM nilai_praktikum;

SELECT * FROM log_rekap_nilai;