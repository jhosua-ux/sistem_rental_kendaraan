<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.math.BigDecimal, com.rental.KoneksiDB" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Sistem Manajemen Rental Kendaraan</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; margin: 20px; color: #333; }
        .container { max-width: 1100px; margin: auto; }
        h1 { text-align: center; color: #2c3e50; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .card { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
        .card h3 { margin-top: 0; border-bottom: 2px solid #3498db; padding-bottom: 8px; color: #2980b9; }
        label { display: block; margin-top: 10px; font-weight: bold; font-size: 14px; }
        input, select { width: 100%; padding: 8px; margin-top: 4px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { margin-top: 15px; width: 100%; padding: 10px; background: #3498db; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; }
        button:hover { background: #2980b9; }
        table { width: 100%; border-collapse: collapse; background: #fff; margin-bottom: 25px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; font-size: 14px; }
        th { background: #2c3e50; color: white; }
        .badge-tersedia { background: #27ae60; color: white; padding: 3px 8px; border-radius: 4px; font-size: 12px; }
        .badge-disewa { background: #e74c3c; color: white; padding: 3px 8px; border-radius: 4px; font-size: 12px; }
    </style>
</head>
<body>
<div class="container">
    <h1>Sistem Manajemen Rental Kendaraan</h1>

    <div class="grid">
        <!-- Form 1: Tambah Pelanggan -->
        <div class="card">
            <h3>1. Tambah Pelanggan</h3>
            <form action="rental" method="post">
                <input type="hidden" name="aksi" value="tambah_pelanggan">
                <label>Nama Lengkap</label>
                <input type="text" name="nama_lengkap" required>
                <label>No. KTP</label>
                <input type="text" name="no_ktp" required>
                <label>No. HP</label>
                <input type="text" name="no_hp" required>
                <label>Alamat</label>
                <input type="text" name="alamat" required>
                <button type="submit">Simpan Pelanggan</button>
            </form>
        </div>

        <!-- Form 2: Tambah Kendaraan -->
        <div class="card">
            <h3>2. Tambah Kendaraan</h3>
            <form action="rental" method="post">
                <input type="hidden" name="aksi" value="tambah_kendaraan">
                <label>Jenis Kendaraan</label>
                <select name="jenis_kendaraan" required>
                    <option value="Mobil">Mobil</option>
                    <option value="Motor">Motor</option>
                </select>
                <label>Merk & Tipe</label>
                <input type="text" name="merk_tipe" placeholder="Contoh: Toyota Avanza / Honda Vario" required>
                <label>Plat Nomor</label>
                <input type="text" name="plat_nomor" placeholder="Contoh: DB 1234 AB" required>
                <label>Harga Sewa / Hari (Rp)</label>
                <input type="number" name="harga_per_hari" required>
                <button type="submit">Simpan Kendaraan</button>
            </form>
        </div>

        <!-- Form 3: Proses Rental -->
        <div class="card">
            <h3>3. Proses Rental Kendaraan</h3>
            <form action="rental" method="post">
                <input type="hidden" name="aksi" value="proses_rental">
                <label>Pilih Pelanggan</label>
                <select name="id_data_pelanggan" required>
                    <%
                        try (Connection conn = KoneksiDB.getConnection();
                             Statement st = conn.createStatement();
                             ResultSet rs = st.executeQuery("SELECT * FROM id_data_pelanggan")) {
                            while (rs.next()) {
                    %>
                        <option value="<%= rs.getInt("id_data_pelanggan") %>"><%= rs.getString("nama_lengkap") %> (<%= rs.getString("no_ktp") %>)</option>
                    <%      }
                        } catch (Exception e) { out.println("<option>Error DB: " + e.getMessage() + "</option>"); }
                    %>
                </select>
                <label>Pilih Kendaraan (Tersedia)</label>
                <select name="id_kendaraan" required>
                    <%
                        try (Connection conn = KoneksiDB.getConnection();
                             Statement st = conn.createStatement();
                             ResultSet rs = st.executeQuery("SELECT * FROM data_kendaraan_rental WHERE status_kendaraan='Tersedia'")) {
                            while (rs.next()) {
                    %>
                        <option value="<%= rs.getInt("id_kendaraan") %>">[<%= rs.getString("jenis_kendaraan") %>] <%= rs.getString("merk_tipe") %> - <%= rs.getString("plat_nomor") %> (Rp <%= String.format("%,.0f", rs.getBigDecimal("harga_per_hari")) %>/hari)</option>
                    <%      }
                        } catch (Exception e) { out.println("<option>Error DB</option>"); }
                    %>
                </select>
                <label>Tanggal Pinjam</label>
                <input type="date" name="tanggal_pinjam" required>
                <label>Tanggal Kembali</label>
                <input type="date" name="tanggal_kembali" required>
                <button type="submit">Proses & Hitung Biaya</button>
            </form>
        </div>
    </div>

    <!-- Tabel Daftar Kendaraan -->
    <h3>Daftar Kendaraan (Mobil & Motor)</h3>
    <table>
        <tr>
            <th>ID</th><th>Jenis</th><th>Merk & Tipe</th><th>Plat Nomor</th><th>Harga / Hari</th><th>Status</th>
        </tr>
        <%
            try (Connection conn = KoneksiDB.getConnection();
                 Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery("SELECT * FROM data_kendaraan_rental ORDER BY jenis_kendaraan, id_kendaraan")) {
                while (rs.next()) {
                    String status = rs.getString("status_kendaraan");
        %>
        <tr>
            <td><%= rs.getInt("id_kendaraan") %></td>
            <td><%= rs.getString("jenis_kendaraan") %></td>
            <td><%= rs.getString("merk_tipe") %></td>
            <td><%= rs.getString("plat_nomor") %></td>
            <td>Rp <%= String.format("%,.0f", rs.getBigDecimal("harga_per_hari")) %></td>
            <td><span class="<%= "Tersedia".equalsIgnoreCase(status) ? "badge-tersedia" : "badge-disewa" %>"><%= status %></span></td>
        </tr>
        <%      }
            } catch (Exception e) { out.println("<tr><td colspan='6'>Gagal memuat data: " + e.getMessage() + "</td></tr>"); }
        %>
    </table>

    <!-- Tabel Daftar Pelanggan -->
    <h3>Daftar Pelanggan</h3>
    <table>
        <tr>
            <th>ID</th><th>Nama Lengkap</th><th>No. KTP</th><th>No. HP</th><th>Alamat</th>
        </tr>
        <%
            try (Connection conn = KoneksiDB.getConnection();
                 Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery("SELECT * FROM id_data_pelanggan")) {
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id_data_pelanggan") %></td>
            <td><%= rs.getString("nama_lengkap") %></td>
            <td><%= rs.getString("no_ktp") %></td>
            <td><%= rs.getString("no_hp") %></td>
            <td><%= rs.getString("alamat") %></td>
        </tr>
        <%      }
            } catch (Exception e) { out.println("<tr><td colspan='5'>Gagal memuat data: " + e.getMessage() + "</td></tr>"); }
        %>
    </table>

    <!-- Tabel Riwayat Transaksi -->
    <h3>Riwayat Transaksi Rental</h3>
    <table>
        <tr>
            <th>ID Transaksi</th><th>Pelanggan</th><th>Kendaraan</th><th>Tgl Pinjam</th><th>Tgl Kembali</th><th>Lama Sewa</th><th>Total Biaya</th>
        </tr>
        <%
            String sqlTrx = "SELECT t.*, p.nama_lengkap, k.jenis_kendaraan, k.merk_tipe, k.plat_nomor FROM transaksi_rental t " +
                            "JOIN id_data_pelanggan p ON t.id_data_pelanggan = p.id_data_pelanggan " +
                            "JOIN data_kendaraan_rental k ON t.id_kendaraan = k.id_kendaraan";
            try (Connection conn = KoneksiDB.getConnection();
                 Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(sqlTrx)) {
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id_transaksi_rental") %></td>
            <td><%= rs.getString("nama_lengkap") %></td>
            <td>[<%= rs.getString("jenis_kendaraan") %>] <%= rs.getString("merk_tipe") %> (<%= rs.getString("plat_nomor") %>)</td>
            <td><%= rs.getDate("tanggal_pinjam") %></td>
            <td><%= rs.getDate("tanggal_kembali") %></td>
            <td><%= rs.getInt("lama_sewa") %> hari</td>
            <td><strong>Rp <%= String.format("%,.0f", rs.getBigDecimal("total_biaya_sewa")) %></strong></td>
        </tr>
        <%      }
            } catch (Exception e) { out.println("<tr><td colspan='7'>Gagal memuat transaksi: " + e.getMessage() + "</td></tr>"); }
        %>
    </table>
</div>
</body>
</html>