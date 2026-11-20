CREATE DATABASE IF NOT EXISTS defaultdb;
USE defaultdb;

CREATE TABLE IF NOT EXISTS users (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    nama_lengkap VARCHAR(100) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user'
);

CREATE TABLE IF NOT EXISTS id_data_pelanggan (
    id_data_pelanggan INT AUTO_INCREMENT PRIMARY KEY,
    no_ktp VARCHAR(30) NOT NULL UNIQUE,
    nama_lengkap VARCHAR(100) NOT NULL,
    no_hp VARCHAR(20) NOT NULL,
    alamat TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS data_kendaraan_rental (
    id_kendaraan INT AUTO_INCREMENT PRIMARY KEY,
    jenis_kendaraan VARCHAR(20) NOT NULL,
    merk_tipe VARCHAR(100) NOT NULL,
    plat_nomor VARCHAR(20) NOT NULL UNIQUE,
    harga_per_hari DECIMAL(12, 2) NOT NULL,
    status_kendaraan VARCHAR(20) DEFAULT 'Tersedia'
);

CREATE TABLE IF NOT EXISTS transaksi_rental (
    id_transaksi_rental INT AUTO_INCREMENT PRIMARY KEY,
    id_data_pelanggan INT NOT NULL,
    id_kendaraan INT NOT NULL,
    tanggal_pinjam DATE NOT NULL,
    tanggal_kembali DATE NOT NULL,
    lama_sewa INT NOT NULL,
    total_biaya_sewa DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (id_data_pelanggan) REFERENCES id_data_pelanggan(id_data_pelanggan),
    FOREIGN KEY (id_kendaraan) REFERENCES data_kendaraan_rental(id_kendaraan)
);

-- Akun Uji Coba Default
INSERT IGNORE INTO users (username, password, nama_lengkap, role) VALUES
('admin', 'admin123', 'Jhosua Tewu', 'admin'),
('user1', 'user123', 'Devis Kalangie', 'user');