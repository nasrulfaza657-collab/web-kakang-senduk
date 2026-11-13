CREATE DATABASE IF NOT EXISTS db_voting_kakang_senduk CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE db_voting_kakang_senduk;
CREATE TABLE IF NOT EXISTS users (
 id INT AUTO_INCREMENT PRIMARY KEY, nama VARCHAR(100) NOT NULL, email VARCHAR(100) NOT NULL UNIQUE,
 no_hp VARCHAR(20), password VARCHAR(255) NOT NULL, role ENUM('admin','pemilih') NOT NULL DEFAULT 'pemilih',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS kontestan (
 id INT AUTO_INCREMENT PRIMARY KEY, nomor_peserta VARCHAR(10) NOT NULL, nama VARCHAR(100) NOT NULL,
 kategori ENUM('Kakang','Senduk') NOT NULL, foto VARCHAR(255), asal_instansi VARCHAR(150),
 tempat_lahir VARCHAR(100), tanggal_lahir DATE, visi TEXT, misi TEXT, prestasi TEXT, deskripsi TEXT,
 UNIQUE KEY uq_nomor_kategori(nomor_peserta,kategori)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS periode_voting (
 id INT AUTO_INCREMENT PRIMARY KEY, nama_periode VARCHAR(100) NOT NULL, tanggal_mulai DATETIME NOT NULL,
 tanggal_selesai DATETIME NOT NULL, status ENUM('Aktif','Nonaktif') NOT NULL DEFAULT 'Nonaktif'
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS voting (
 id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, kontestan_id INT NOT NULL,
 kategori ENUM('Kakang','Senduk') NOT NULL, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_user_kategori(user_id,kategori),
 CONSTRAINT fk_voting_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
 CONSTRAINT fk_voting_kontestan FOREIGN KEY(kontestan_id) REFERENCES kontestan(id) ON DELETE RESTRICT,
 INDEX idx_voting_kontestan(kontestan_id)
) ENGINE=InnoDB;
