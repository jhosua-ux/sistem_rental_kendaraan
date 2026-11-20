package com.rental;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.temporal.ChronoUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/rental")
public class RentalServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String aksi = request.getParameter("aksi");

        try (Connection conn = KoneksiDB.getConnection()) {
            if ("tambah_pelanggan".equals(aksi)) {
                String sql = "INSERT INTO id_data_pelanggan (no_ktp, nama_lengkap, no_hp, alamat) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, request.getParameter("no_ktp"));
                    ps.setString(2, request.getParameter("nama_lengkap"));
                    ps.setString(3, request.getParameter("no_hp"));
                    ps.setString(4, request.getParameter("alamat"));
                    ps.executeUpdate();
                }

            } else if ("tambah_kendaraan".equals(aksi)) {
                String sql = "INSERT INTO data_kendaraan_rental (jenis_kendaraan, merk_tipe, plat_nomor, harga_per_hari, status_kendaraan) VALUES (?, ?, ?, ?, 'Tersedia')";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, request.getParameter("jenis_kendaraan"));
                    ps.setString(2, request.getParameter("merk_tipe"));
                    ps.setString(3, request.getParameter("plat_nomor"));
                    ps.setBigDecimal(4, new BigDecimal(request.getParameter("harga_per_hari")));
                    ps.executeUpdate();
                }

            } else if ("proses_rental".equals(aksi)) {
                int idPelanggan = Integer.parseInt(request.getParameter("id_data_pelanggan"));
                int idKendaraan = Integer.parseInt(request.getParameter("id_kendaraan"));
                Date tglPinjam = Date.valueOf(request.getParameter("tanggal_pinjam"));
                Date tglKembali = Date.valueOf(request.getParameter("tanggal_kembali"));

                long lamaSewa = ChronoUnit.DAYS.between(tglPinjam.toLocalDate(), tglKembali.toLocalDate());
                if (lamaSewa <= 0) {
                    lamaSewa = 1;
                }

                // Ambil harga sewa per hari dari database
                BigDecimal hargaPerHari = BigDecimal.ZERO;
                String sqlHarga = "SELECT harga_per_hari FROM data_kendaraan_rental WHERE id_kendaraan = ?";
                try (PreparedStatement psHrg = conn.prepareStatement(sqlHarga)) {
                    psHrg.setInt(1, idKendaraan);
                    try (ResultSet rsHrg = psHrg.executeQuery()) {
                        if (rsHrg.next()) {
                            hargaPerHari = rsHrg.getBigDecimal("harga_per_hari");
                        }
                    }
                }

                BigDecimal totalBiaya = hargaPerHari.multiply(BigDecimal.valueOf(lamaSewa));

                // Simpan transaksi ke tabel transaksi_rental
                String sqlTrans = "INSERT INTO transaksi_rental (id_data_pelanggan, id_kendaraan, tanggal_pinjam, tanggal_kembali, lama_sewa, total_biaya_sewa) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement psTrans = conn.prepareStatement(sqlTrans)) {
                    psTrans.setInt(1, idPelanggan);
                    psTrans.setInt(2, idKendaraan);
                    psTrans.setDate(3, tglPinjam);
                    psTrans.setDate(4, tglKembali);
                    psTrans.setInt(5, (int) lamaSewa);
                    psTrans.setBigDecimal(6, totalBiaya);
                    psTrans.executeUpdate();
                }

                // Ubah status kendaraan menjadi Disewa
                String sqlUpdate = "UPDATE data_kendaraan_rental SET status_kendaraan = 'Disewa' WHERE id_kendaraan = ?";
                try (PreparedStatement psUpd = conn.prepareStatement(sqlUpdate)) {
                    psUpd.setInt(1, idKendaraan);
                    psUpd.executeUpdate();
                }
            }
        } catch (Exception e) {
            throw new ServletException("Gagal memproses data rental: " + e.getMessage(), e);
        }

        response.sendRedirect("index.jsp");
    }
}