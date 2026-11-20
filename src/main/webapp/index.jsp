<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.math.BigDecimal, java.text.NumberFormat, java.util.Locale, com.rental.KoneksiDB" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String role = (String) session.getAttribute("role");
    String namaUser = (String) session.getAttribute("nama_lengkap");
    NumberFormat nf = NumberFormat.getInstance(new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistem Informasi Rental Kendaraan</title>
    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body {
            margin: 0;
            min-height: 100vh;
            color: #1e293b;
            background: linear-gradient(rgba(241, 245, 249, 0.86), rgba(226, 232, 240, 0.92)),
                        url('https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1600&q=80') center/cover no-repeat fixed;
        }
        .navbar {
            background: linear-gradient(135deg, #0f172a, #1e293b);
            color: #fff;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar .brand { font-size: 19px; font-weight: bold; }
        .navbar .user-info { display: flex; align-items: center; gap: 15px; font-size: 14px; }
        .badge-role { background: #3b82f6; padding: 4px 11px; border-radius: 12px; font-size: 11px; font-weight: bold; text-transform: uppercase; }
        .btn-logout { background: #ef4444; color: #fff; text-decoration: none; padding: 8px 15px; border-radius: 8px; font-weight: bold; font-size: 13px; }
        .btn-logout:hover { background: #dc2626; }
        .container { max-width: 1180px; margin: 28px auto; padding: 0 20px; }
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 25px; }
        .menu-card { background: rgba(255,255,255,0.95); border-radius: 14px; padding: 20px; text-align: center; cursor: pointer; border: 2px solid transparent; box-shadow: 0 4px 10px rgba(0,0,0,0.06); transition: 0.25s; }
        .menu-card:hover, .menu-card.active { border-color: #2563eb; transform: translateY(-3px); }
        .menu-icon { font-size: 34px; margin-bottom: 8px; display: block; }
        .menu-title { font-weight: bold; font-size: 15px; color: #0f172a; }
        .menu-desc { font-size: 12px; color: #64748b; margin-top: 4px; }
        .card { background: rgba(255,255,255,0.96); border-radius: 14px; padding: 24px; margin-bottom: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.07); }
        .card h3 { margin-top: 0; color: #0f172a; border-bottom: 2px solid #f1f5f9; padding-bottom: 12px; }
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 14px; }
        label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 5px; color: #475569; }
        input, select { width: 100%; padding: 10px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; background: #fff; }
        button.btn-primary { background: linear-gradient(135deg, #2563eb, #1d4ed8); color: #fff; border: none; padding: 11px 22px; border-radius: 8px; font-weight: bold; cursor: pointer; margin-top: 15px; font-size: 14px; }
        table { width: 100%; border-collapse: collapse; margin-top: 14px; font-size: 14px; }
        th, td { padding: 12px; border-bottom: 1px solid #e2e8f0; text-align: left; }
        th { background: #f8fafc; color: #334155; font-weight: 600; }
        .status-tersedia { background: #dcfce7; color: #166534; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .status-disewa { background: #fee2e2; color: #991b1b; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .hero-user { background: linear-gradient(rgba(15,23,42,0.72), rgba(30,58,138,0.85)), url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1400&q=80') center/cover no-repeat; color: #fff; padding: 34px 28px; border-radius: 16px; margin-bottom: 26px; }
        .hero-user h2 { margin: 0 0 8px 0; font-size: 26px; }
        .hero-user p { margin: 0; opacity: 0.92; font-size: 15px; }
        .vehicle-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 22px; }
        .vehicle-card { background: rgba(255,255,255,0.97); border-radius: 16px; overflow: hidden; box-shadow: 0 6px 16px rgba(0,0,0,0.08); transition: 0.25s; display: flex; flex-direction: column; justify-content: space-between; }
        .vehicle-card:hover { transform: translateY(-5px); }
        .vehicle-photo-wrap { position: relative; width: 100%; height: 185px; background: #e2e8f0; overflow: hidden; }
        .vehicle-photo-wrap img { width: 100%; height: 100%; object-fit: cover; }
        .badge-ready { position: absolute; top: 12px; right: 12px; background: rgba(16,185,129,0.95); color: #fff; font-size: 11px; padding: 5px 11px; border-radius: 20px; font-weight: bold; }
        .badge-jenis { position: absolute; top: 12px; left: 12px; background: rgba(15,23,42,0.8); color: #fff; font-size: 11px; padding: 4px 10px; border-radius: 8px; font-weight: 600; text-transform: uppercase; }
        .vehicle-body { padding: 18px; }
        .vehicle-name { font-size: 19px; font-weight: bold; color: #0f172a; margin: 0 0 8px 0; }
        .vehicle-plat { display: inline-block; background: #f1f5f9; color: #334155; border: 1px solid #cbd5e1; padding: 4px 10px; border-radius: 6px; font-family: monospace; font-size: 13px; font-weight: bold; }
        .vehicle-footer { padding: 14px 18px; background: #f8fafc; border-top: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .price { color: #2563eb; font-weight: bold; font-size: 17px; }
        .price span { font-size: 12px; color: #64748b; font-weight: normal; }
        .ready-note { font-size: 12px; color: #059669; font-weight: bold; background: #d1fae5; padding: 4px 10px; border-radius: 6px; }
    </style>
    <script>
        function tampilkanFitur(idSection, el) {
            document.querySelectorAll('.admin-section').forEach(sec => {
                sec.style.display = (idSection === 'semua' || sec.id === idSection) ? 'block' : 'none';
            });
            document.querySelectorAll('.menu-card').forEach(card => card.classList.remove('active'));
            if (el) el.classList.add('active');
        }
    </script>
</head>
<body>

<div class="navbar">
    <div class="brand">&#128664; Sistem Rental Kendaraan</div>
    <div class="user-info">
        <span>Halo, <strong><%= namaUser %></strong></span>
        <span class="badge-role"><%= role %></span>
        <a href="LoginServlet?action=logout" class="btn-logout">Logout</a>
    </div>
</div>

<div class="container">
<% if ("admin".equals(role)) { %>
    <div class="menu-grid">
        <div class="menu-card active" onclick="tampilkanFitur('semua', this)"><span class="menu-icon">&#128202;</span><div class="menu-title">Semua Panel</div><div class="menu-desc">Tampilkan seluruh menu</div></div>
        <div class="menu-card" onclick="tampilkanFitur('sec-pelanggan', this)"><span class="menu-icon">&#128100;</span><div class="menu-title">Tambah Pelanggan</div><div class="menu-desc">Registrasi penyewa</div></div>
        <div class="menu-card" onclick="tampilkanFitur('sec-kendaraan', this)"><span class="menu-icon">&#128663;</span><div class="menu-title">Tambah Kendaraan</div><div class="menu-desc">Kelola armada</div></div>
        <div class="menu-card" onclick="tampilkanFitur('sec-transaksi', this)"><span class="menu-icon">&#129534;</span><div class="menu-title">Transaksi &amp; Riwayat</div><div class="menu-desc">Proses sewa &amp; log</div></div>
    </div>

    <div id="sec-pelanggan" class="card admin-section">
        <h3>Manajemen Data Pelanggan</h3>
        <form action="rental" method="post">
            <input type="hidden" name="aksi" value="tambah_pelanggan">
            <div class="form-grid">
                <div><label>No. KTP</label><input type="text" name="no_ktp" required placeholder="7171012345670001"></div>
                <div><label>Nama Lengkap</label><input type="text" name="nama_lengkap" required placeholder="Nama penyewa"></div>
                <div><label>No. HP</label><input type="text" name="no_hp" required placeholder="0812xxxxxxxx"></div>
                <div><label>Alamat</label><input type="text" name="alamat" required placeholder="Alamat domisili"></div>
            </div>
            <button type="submit" class="btn-primary">+ Simpan Pelanggan</button>
        </form>
        <table><thead><tr><th>ID</th><th>No. KTP</th><th>Nama Lengkap</th><th>No. HP</th><th>Alamat</th></tr></thead><tbody>
        <% try (Connection conn = KoneksiDB.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT * FROM id_data_pelanggan ORDER BY id_data_pelanggan DESC")) {
            while (rs.next()) { %>
            <tr><td><%= rs.getInt("id_data_pelanggan") %></td><td><%= rs.getString("no_ktp") %></td><td><%= rs.getString("nama_lengkap") %></td><td><%= rs.getString("no_hp") %></td><td><%= rs.getString("alamat") %></td></tr>
        <% } } catch (Exception e) { out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>"); } %>
        </tbody></table>
    </div>

    <div id="sec-kendaraan" class="card admin-section">
        <h3>Manajemen Armada Kendaraan</h3>
        <form action="rental" method="post">
            <input type="hidden" name="aksi" value="tambah_kendaraan">
            <div class="form-grid">
                <div><label>Jenis Kendaraan</label><select name="jenis_kendaraan" required><option value="Mobil">Mobil</option><option value="Motor">Motor</option></select></div>
                <div><label>Merk / Tipe</label><input type="text" name="merk_tipe" required placeholder="Contoh: Toyota Avanza / Honda Vario"></div>
                <div><label>Plat Nomor</label><input type="text" name="plat_nomor" required placeholder="Contoh: DB 1234 AB"></div>
                <div><label>Harga Sewa / Hari (Rp)</label><input type="number" name="harga_per_hari" required placeholder="350000"></div>
            </div>
            <button type="submit" class="btn-primary">+ Tambah Armada</button>
        </form>
        <table><thead><tr><th>ID</th><th>Jenis</th><th>Merk / Tipe</th><th>Plat Nomor</th><th>Tarif / Hari</th><th>Status</th></tr></thead><tbody>
        <% try (Connection conn = KoneksiDB.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT * FROM data_kendaraan_rental ORDER BY id_kendaraan DESC")) {
            while (rs.next()) { String status = rs.getString("status_kendaraan"); BigDecimal harga = rs.getBigDecimal("harga_per_hari"); %>
            <tr><td><%= rs.getInt("id_kendaraan") %></td><td><%= rs.getString("jenis_kendaraan") %></td><td><%= rs.getString("merk_tipe") %></td><td><strong><%= rs.getString("plat_nomor") %></strong></td><td>Rp <%= (harga != null) ? nf.format(harga) : "0" %></td><td><span class="<%= "Tersedia".equalsIgnoreCase(status) ? "status-tersedia" : "status-disewa" %>"><%= status %></span></td></tr>
        <% } } catch (Exception e) { out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>"); } %>
        </tbody></table>
    </div>

    <div id="sec-transaksi" class="card admin-section">
        <h3>Transaksi Penyewaan &amp; Riwayat</h3>
        <form action="rental" method="post">
            <input type="hidden" name="aksi" value="proses_rental">
            <div class="form-grid">
                <div><label>Pilih Pelanggan</label><select name="id_data_pelanggan" required>
                <% try (Connection conn = KoneksiDB.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT id_data_pelanggan, nama_lengkap, no_ktp FROM id_data_pelanggan")) {
                    while (rs.next()) { %><option value="<%= rs.getInt("id_data_pelanggan") %>"><%= rs.getString("nama_lengkap") %> (<%= rs.getString("no_ktp") %>)</option><% } } catch (Exception e) {} %>
                </select></div>
                <div><label>Pilih Kendaraan (Tersedia)</label><select name="id_kendaraan" required>
                <% try (Connection conn = KoneksiDB.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT id_kendaraan, merk_tipe, plat_nomor, harga_per_hari FROM data_kendaraan_rental WHERE status_kendaraan = 'Tersedia'")) {
                    while (rs.next()) { BigDecimal hrg = rs.getBigDecimal("harga_per_hari"); %><option value="<%= rs.getInt("id_kendaraan") %>"><%= rs.getString("merk_tipe") %> - <%= rs.getString("plat_nomor") %> (Rp <%= (hrg != null) ? nf.format(hrg) : "0" %>/hari)</option><% } } catch (Exception e) {} %>
                </select></div>
                <div><label>Tanggal Pinjam</label><input type="date" name="tanggal_pinjam" required></div>
                <div><label>Tanggal Kembali</label><input type="date" name="tanggal_kembali" required></div>
            </div>
            <button type="submit" class="btn-primary">Proses Transaksi Sewa</button>
        </form>
        <table><thead><tr><th>ID Transaksi</th><th>Pelanggan</th><th>Kendaraan</th><th>Tgl Pinjam</th><th>Tgl Kembali</th><th>Lama</th><th>Total Biaya</th></tr></thead><tbody>
        <% String sqlTrans = "SELECT t.id_transaksi_rental, p.nama_lengkap, k.merk_tipe, k.plat_nomor, t.tanggal_pinjam, t.tanggal_kembali, t.lama_sewa, t.total_biaya_sewa FROM transaksi_rental t JOIN id_data_pelanggan p ON t.id_data_pelanggan = p.id_data_pelanggan JOIN data_kendaraan_rental k ON t.id_kendaraan = k.id_kendaraan ORDER BY t.id_transaksi_rental DESC";
           try (Connection conn = KoneksiDB.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sqlTrans)) {
            boolean adaTrans = false;
            while (rs.next()) { adaTrans = true; BigDecimal total = rs.getBigDecimal("total_biaya_sewa"); %>
            <tr><td>#<%= rs.getInt("id_transaksi_rental") %></td><td><%= rs.getString("nama_lengkap") %></td><td><%= rs.getString("merk_tipe") %> (<%= rs.getString("plat_nomor") %>)</td><td><%= rs.getDate("tanggal_pinjam") %></td><td><%= rs.getDate("tanggal_kembali") %></td><td><%= rs.getInt("lama_sewa") %> hari</td><td><strong>Rp <%= (total != null) ? nf.format(total) : "0" %></strong></td></tr>
        <% } if (!adaTrans) { out.println("<tr><td colspan='7' style='text-align:center;'>Belum ada data transaksi penyewaan.</td></tr>"); }
           } catch (Exception e) { out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>"); } %>
        </tbody></table>
    </div>
<% } else { %>
    <div class="hero-user">
        <h2>Katalog Armada Kendaraan Siap Sewa</h2>
        <p>Temukan unit mobil keluarga, SUV, maupun sepeda motor terbaik untuk kebutuhan perjalanan Anda hari ini.</p>
    </div>

    <div class="vehicle-grid">
        <%
            boolean adaUnit = false;
            try (Connection conn = KoneksiDB.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT * FROM data_kendaraan_rental WHERE status_kendaraan = 'Tersedia' ORDER BY jenis_kendaraan, merk_tipe")) {
                while (rs.next()) {
                    adaUnit = true;
                    String jenis = rs.getString("jenis_kendaraan");
                    String merk = rs.getString("merk_tipe");
                    String merkLower = (merk != null) ? merk.toLowerCase() : "";
                    BigDecimal hargaUnit = rs.getBigDecimal("harga_per_hari");
                    String fotoUrl;
                    if ("Motor".equalsIgnoreCase(jenis)) {
                        if (merkLower.contains("nmax") || merkLower.contains("pcx") || merkLower.contains("aerox")) {
                            fotoUrl = "https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=800&q=80";
                        } else if (merkLower.contains("vespa") || merkLower.contains("scoopy")) {
                            fotoUrl = "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?auto=format&fit=crop&w=800&q=80";
                        } else {
                            fotoUrl = "https://images.unsplash.com/photo-1609630875171-b1321377ee65?auto=format&fit=crop&w=800&q=80";
                        }
                    } else {
                        if (merkLower.contains("pajero") || merkLower.contains("fortuner") || merkLower.contains("rush") || merkLower.contains("terios") || merkLower.contains("crv")) {
                            fotoUrl = "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=800&q=80";
                        } else if (merkLower.contains("brio") || merkLower.contains("agya") || merkLower.contains("ayla") || merkLower.contains("jazz") || merkLower.contains("yaris")) {
                            fotoUrl = "https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80";
                        } else if (merkLower.contains("innova") || merkLower.contains("alphard") || merkLower.contains("xpander")) {
                            fotoUrl = "https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?auto=format&fit=crop&w=800&q=80";
                        } else {
                            fotoUrl = "https://images.unsplash.com/photo-1550355291-bbee04a92027?auto=format&fit=crop&w=800&q=80";
                        }
                    }
                    String fallbackFoto = "Motor".equalsIgnoreCase(jenis) ? "https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=800&q=80" : "https://images.unsplash.com/photo-1550355291-bbee04a92027?auto=format&fit=crop&w=800&q=80";
        %>
        <div class="vehicle-card">
            <div class="vehicle-photo-wrap">
                <span class="badge-jenis"><%= jenis %></span>
                <span class="badge-ready">&#9679; TERSEDIA</span>
                <img src="<%= fotoUrl %>" alt="<%= merk %>" onerror="this.onerror=null;this.src='<%= fallbackFoto %>';">
            </div>
            <div class="vehicle-body">
                <div class="vehicle-name"><%= merk %></div>
                <div class="vehicle-plat"><%= rs.getString("plat_nomor") %></div>
            </div>
            <div class="vehicle-footer">
                <div class="price">Rp <%= (hargaUnit != null) ? nf.format(hargaUnit) : "0" %> <span>/ hari</span></div>
                <span class="ready-note">Siap Sewa</span>
            </div>
        </div>
        <% } } catch (Exception e) { out.println("<p>Gagal memuat armada: " + e.getMessage() + "</p>"); }
           if (!adaUnit) { %>
        <div class="card" style="grid-column: 1 / -1; text-align: center;"><h3>Maaf, saat ini semua unit kendaraan sedang disewa.</h3></div>
        <% } %>
    </div>

    <div class="card" style="margin-top: 30px;">
        <h3>&#128203; Riwayat Transaksi Penyewaan</h3>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Penyewa</th>
                    <th>Kendaraan</th>
                    <th>Tgl Pinjam</th>
                    <th>Tgl Kembali</th>
                    <th>Durasi</th>
                    <th>Total Biaya</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String sqlUserTrans = "SELECT t.id_transaksi_rental, p.nama_lengkap, k.merk_tipe, k.plat_nomor, t.tanggal_pinjam, t.tanggal_kembali, t.lama_sewa, t.total_biaya_sewa FROM transaksi_rental t JOIN id_data_pelanggan p ON t.id_data_pelanggan = p.id_data_pelanggan JOIN data_kendaraan_rental k ON t.id_kendaraan = k.id_kendaraan ORDER BY t.id_transaksi_rental DESC";
                    try (Connection conn = KoneksiDB.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sqlUserTrans)) {
                        boolean adaRiwayat = false;
                        while (rs.next()) {
                            adaRiwayat = true;
                            BigDecimal totalU = rs.getBigDecimal("total_biaya_sewa");
                %>
                <tr>
                    <td>#<%= rs.getInt("id_transaksi_rental") %></td>
                    <td><%= rs.getString("nama_lengkap") %></td>
                    <td><%= rs.getString("merk_tipe") %> (<%= rs.getString("plat_nomor") %>)</td>
                    <td><%= rs.getDate("tanggal_pinjam") %></td>
                    <td><%= rs.getDate("tanggal_kembali") %></td>
                    <td><%= rs.getInt("lama_sewa") %> hari</td>
                    <td><strong>Rp <%= (totalU != null) ? nf.format(totalU) : "0" %></strong></td>
                </tr>
                <%
                        }
                        if (!adaRiwayat) {
                            out.println("<tr><td colspan='7' style='text-align:center;'>Belum ada riwayat transaksi penyewaan.</td></tr>");
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7'>Error memuat riwayat: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
<% } %>
</div>
</body>
</html>