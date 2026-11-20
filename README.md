# Sistem Informasi Rental Kendaraan Berbasis Web

Aplikasi manajemen penyewaan kendaraan (Mobil & Motor) berbasis web yang dikembangkan menggunakan **Java (Servlet & JSP)** dengan penerapan konsep **Pemrograman Berorientasi Objek (PBO)** dan terintegrasi dengan basis data cloud **MySQL**.

## Live Demo
- **Tautan Aplikasi Publik (24 Jam):** [https://sistemrentalkendaraan-production.up.railway.app](https://sistemrentalkendaraan-production.up.railway.app)

## Kredensial Akun Uji Coba
| Role | Username | Password | Hak Akses |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` | `admin123` | Kelola data pelanggan, kelola armada kendaraan, proses transaksi sewa, & lihat seluruh riwayat |
| **User** | `user1` | `user123` | Melihat katalog foto armada siap sewa, tarif harian, & riwayat transaksi penyewaan *(atau daftar mandiri melalui tab Buat Akun User)* |

## Fitur Utama
1. **Autentikasi Multi-Role & Registrasi:** Login terpisah untuk Admin dan User, dilengkapi fitur pendaftaran akun User baru secara mandiri (*self-registration*).
2. **Manajemen Data Pelanggan (Admin):** Input dan daftar data penyewa (No. KTP, Nama Lengkap, No. HP, Alamat).
3. **Manajemen Armada Kendaraan (Admin):** Penambahan unit Mobil/Motor beserta tarif per hari dan pembaruan status otomatis (`Tersedia` / `Disewa`).
4. **Transaksi Penyewaan Otomatis (Admin):** Perhitungan durasi sewa (`lama_sewa`) dan `total_biaya_sewa` otomatis berdasarkan tanggal pinjam dan tanggal kembali.
5. **Katalog Armada Visual & Riwayat Sewa (User):** Tampilan kartu armada dilengkapi foto kendaraan otomatis dan riwayat transaksi penyewaan secara *real-time*.

## Teknologi / Tech Stack
- **Bahasa Pemrograman:** Java (JDK 17)
- **Web Framework / Teknologi:** Java Servlet & JavaServer Pages (JSP)
- **Web Server / Container:** Apache Tomcat 9
- **Database:** MySQL 8.0 (Cloud Hosted via Aiven.io)
- **Deployment & Cloud Hosting:** Docker & Railway.app

## Cara Instalasi Lokal (Setup Guide)
1. **Clone Repositori:**
   ```bash
   git clone [https://github.com/jhosua-ux/sistem_rental_kendaraan.git](https://github.com/jhosua-ux/sistem_rental_kendaraan.git)
   cd sistem_rental_kendaraan