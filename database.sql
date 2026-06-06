CREATE TABLE dosen (
    kode_dosen VARCHAR(10) NOT NULL,
    nama_dosen VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (kode_dosen)
) ENGINE=InnoDB;

CREATE TABLE mahasiswa (
    nim VARCHAR(15) NOT NULL,
    nama VARCHAR(100) NOT NULL,
    kelas VARCHAR(50) NOT NULL, 
    angkatan INT NOT NULL,
    PRIMARY KEY (nim)
) ENGINE=InnoDB;

CREATE TABLE grade_nilai (
    grade VARCHAR(5) NOT NULL,
    bobot DECIMAL(3,2) NOT NULL,
    nilai_bawah DECIMAL(5,2) NOT NULL,
    nilai_atas DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (grade)
) ENGINE=InnoDB;

CREATE TABLE mata_kuliah (
    kode_mk VARCHAR(15) NOT NULL,
    nama_mk VARCHAR(100) NOT NULL,
    sks INT NOT NULL,
    semester INT NOT NULL,
    kode_dosen VARCHAR(10) NOT NULL,
    PRIMARY KEY (kode_mk),
    CONSTRAINT fk_mk_dosen 
        FOREIGN KEY (kode_dosen) REFERENCES dosen(kode_dosen)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE nilai_praktikum (
    id_nilai INT AUTO_INCREMENT NOT NULL,
    nim VARCHAR(15) NOT NULL,
    kode_mk VARCHAR(15) NOT NULL,
    nilai_tugas DECIMAL(5,2) NOT NULL,
    nilai_kuis DECIMAL(5,2) NOT NULL,
    nilai_uts DECIMAL(5,2) NOT NULL,
    nilai_akhir DECIMAL(5,2) DEFAULT NULL, 
    grade VARCHAR(5) DEFAULT NULL,         
    bobot DECIMAL(3,2) DEFAULT NULL,       
    status_lulus VARCHAR(15) DEFAULT NULL, 
    PRIMARY KEY (id_nilai),
    CONSTRAINT fk_nilai_mahasiswa 
        FOREIGN KEY (nim) REFERENCES mahasiswa(nim)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_nilai_mk 
        FOREIGN KEY (kode_mk) REFERENCES mata_kuliah(kode_mk)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_nilai_grade 
        FOREIGN KEY (grade) REFERENCES grade_nilai(grade)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE log_rekap_nilai (
    id_log INT AUTO_INCREMENT NOT NULL,
    nim VARCHAR(15) NOT NULL,
    kode_mk VARCHAR(15) NOT NULL,
    nilai_akhir DECIMAL(5,2) NOT NULL,
    grade VARCHAR(5) NOT NULL,
    bobot DECIMAL(3,2) NOT NULL,
    status_lulus VARCHAR(15) NOT NULL,
    keterangan VARCHAR(255) NOT NULL,
    waktu_proses TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    PRIMARY KEY (id_log)
) ENGINE=InnoDB;
