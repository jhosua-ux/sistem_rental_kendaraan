package com.rental;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/rental")
public class RentalServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
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
                String sql = "INSERT INTO data_kendaraan_rental (plat_nomor, jenis_kendaraan, merk_tipe, harga_per_hari, status_kendaraan) VALUES (?, ?, ?, ?, 'Tersedia')";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, request.getParameter("plat_nomor"));
                    ps.setString(2, request.getParameter("jenis_kendaraan"));
                    ps.setString(3, request.getParameter("merk_tipe"));
                    ps.setBigDecimal(4, new BigDecimal(request.getParameter("harga_per_hari")));
                    ps.executeUpdate();
                }

            } else if ("proses_rental".equals(aksi)) {
                int idPelanggan = Integer.parseInt(request.getParameter("id_data_pelanggan"));
                int idKendaraan = Integer.parseInt(request.getParameter("id_kendaraan"));
                LocalDate tglPinjam = LocalDate.parse(request.getParameter("tanggal_pinjam"));
                LocalDate tglKembali = LocalDate.parse(request.getParameter("tanggal_kembali"));

                long lamaSewa = ChronoUnit.DAYS.between(tglPinjam, tglKembali);
                if (lamaSewa <= 0) {
                    lamaSewa = 1;
                }

                BigDecimal hargaPerHari = BigDecimal.ZERO;
                String sqlHarga = "SELECT harga_per_hari FROM data_kendaraan_rental WHERE id_kendaraan = ?";
                try (PreparedStatement psHarga = conn.prepareStatement(sqlHarga)) {
                    psHarga.setInt(1, idKendaraan);
                    try (ResultSet rs = psHarga.executeQuery()) {
                        if (rs.next()) {
                            hargaPerHari = rs.getBigDecimal("harga_per_hari");
                        }
                    }
                }

                BigDecimal totalBiaya = hargaPerHari.multiply(BigDecimal.valueOf(lamaSewa));

                String sqlTrx = "INSERT INTO transaksi_rental (id_data_pelanggan, id_kendaraan, tanggal_pinjam, tanggal_kembali, lama_sewa, total_biaya_sewa) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement psTrx = conn.prepareStatement(sqlTrx)) {
                    psTrx.setInt(1, idPelanggan);
                    psTrx.setInt(2, idKendaraan);
                    psTrx.setDate(3, Date.valueOf(tglPinjam));
                    psTrx.setDate(4, Date.valueOf(tglKembali));
                    psTrx.setInt(5, (int) lamaSewa);
                    psTrx.setBigDecimal(6, totalBiaya);
                    psTrx.executeUpdate();
                }

                String sqlUpdateStatus = "UPDATE data_kendaraan_rental SET status_kendaraan = 'Disewa' WHERE id_kendaraan = ?";
                try (PreparedStatement psUpd = conn.prepareStatement(sqlUpdateStatus)) {
                    psUpd.setInt(1, idKendaraan);
                    psUpd.executeUpdate();
                }
            }

            response.sendRedirect("index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h3>Terjadi Kesalahan Database:</h3><p>" + e.getMessage() + "</p><a href='index.jsp'>Kembali</a>");
        }
    }
}