INSERT INTO grade_nilai (grade, bobot, nilai_bawah, nilai_atas) VALUES
('A', 4.00, 93.00, 100.00),
('A-', 3.75, 85.00, 92.99),
('B+', 3.50, 81.00, 84.99),
('B', 3.25, 75.00, 80.99),
('B-', 3.00, 71.00, 74.99),
('C+', 2.75, 66.00, 70.99),
('C', 2.50, 61.00, 65.99),
('C-', 2.00, 56.00, 60.99),
('D', 1.00, 40.00, 55.99),
('E', 0.00, 0.00, 39.99);

INSERT INTO dosen (kode_dosen, nama_dosen, email) VALUES
('DS001', 'Abdul Malik, S.Kom., M.Cs.', 'abdul.malik@unismuh.ac.id'),
('DS002', 'Anandari Dewitri, S.Kom., M.T.', 'anandari.d@unismuh.ac.id');

INSERT INTO mata_kuliah (kode_mk, nama_mk, sks, semester, kode_dosen) VALUES
('MK001', 'Pemrograman Basis Data', 3, 4, 'DS001'),
('MK002', 'Sistem Operasi', 3, 4, 'DS001'),
('MK003', 'Internet of Things', 2, 4, 'DS002');

INSERT INTO mahasiswa (nim, nama, kelas, angkatan) VALUES
('202401001', 'Lisa', 'Informatika A', 2024),
('202401002', 'Kelly', 'Informatika A', 2024),
('202401003', 'Lilis', 'Informatika A', 2024),
('202401004', 'Hasriani', 'Informatika A', 2024),
('202401005', 'Uminati', 'Informatika B', 2024),
('202401006', 'Nur aisyah Masdin', 'Informatika B', 2024),
('202401007', 'Andi Ahmad', 'Informatika A', 2024),
('202401008', 'Budi Santoso', 'Informatika B', 2024),
('202401009', 'Citra Lestari', 'Informatika A', 2024),
('202401010', 'Dewi Sartika', 'Informatika B', 2024),
('202401011', 'Eko Prasetyo', 'Informatika A', 2024),
('202401012', 'Fany Rahma', 'Informatika B', 2024),
('202401013', 'Guntur Wibowo', 'Informatika A', 2024),
('202401014', 'Hendra Wijaya', 'Informatika B', 2024),
('202401015', 'Indah Permata', 'Informatika A', 2024),
('202401016', 'Joko Susilo', 'Informatika B', 2024),
('202401017', 'Kurniawan', 'Informatika A', 2024),
('202401018', 'Lestari Putri', 'Informatika B', 2024),
('202401019', 'Muhammad Rizky', 'Informatika A', 2024),
('202401020', 'Nabila Putri', 'Informatika B', 2024);

INSERT INTO nilai_praktikum (nim, kode_mk, nilai_tugas, nilai_kuis, nilai_uts) VALUES
('202401001', 'MK001', 95.00, 92.00, 94.00),
('202401002', 'MK001', 88.00, 85.00, 90.00),
('202401003', 'MK001', 82.00, 80.00, 85.00),
('202401004', 'MK001', 78.00, 75.00, 80.00),
('202401005', 'MK001', 74.00, 72.00, 75.00),
('202401006', 'MK002', 68.00, 70.00, 65.00),
('202401007', 'MK001', 63.00, 65.00, 62.00),
('202401008', 'MK002', 58.00, 55.00, 60.00),
('202401009', 'MK001', 50.00, 45.00, 52.00),
('202401010', 'MK003', 35.00, 30.00, 38.00),
('202401011', 'MK001', 98.00, 95.00, 96.00),
('202401012', 'MK002', 86.00, 84.00, 88.00),
('202401013', 'MK001', 80.00, 83.00, 82.00),
('202401014', 'MK002', 76.00, 74.00, 78.00),
('202401015', 'MK001', 72.00, 70.00, 73.00),
('202401016', 'MK003', 67.00, 66.00, 68.00),
('202401017', 'MK001', 62.00, 64.00, 61.00),
('202401018', 'MK002', 57.00, 59.00, 56.00),
('202401019', 'MK001', 45.00, 42.00, 48.00),
('202401020', 'MK003', 20.00, 25.00, 30.00);
