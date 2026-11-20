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
        body { margin: 0; background: #f0f2f5; color: #333; }
        
        .navbar {
            background: linear-gradient(135deg, #1e293b, #0f172a);
            color: #fff;
            padding: 14px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .navbar .brand { font-size: 18px; font-weight: bold; }
        .navbar .user-info { display: flex; align-items: center; gap: 15px; font-size: 14px; }
        .badge-role { background: #3b82f6; padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
        .btn-logout {
            background: #ef4444; color: #fff; text-decoration: none;
            padding: 7px 14px; border-radius: 6px; font-weight: bold; font-size: 13px;
        }
        .btn-logout:hover { background: #dc2626; }

        .container { max-width: 1150px; margin: 25px auto; padding: 0 20px; }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 25px;
        }
        .menu-card {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            border: 2px solid transparent;
            box-shadow: 0 2px 6px rgba(0,0,0,0.06);
            transition: all 0.25s ease;
        }
        .menu-card:hover, .menu-card.active {
            border-color: #2563eb;
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(37, 99, 235, 0.15);
        }
        .menu-icon { font-size: 36px; margin-bottom: 8px; display: block; }
        .menu-title { font-weight: bold; font-size: 15px; color: #1e293b; }
        .menu-desc { font-size: 12px; color: #64748b; margin-top: 4px; }

        .card {
            background: #fff;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .card h3 { margin-top: 0; color: #1e293b; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px; }
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 14px; }
        label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 5px; color: #475569; }
        input, select {
            width: 100%; padding: 10px; border: 1px solid #cbd5e1;
            border-radius: 6px; font-size: 14px;
        }
        button.btn-primary {
            background: #2563eb; color: #fff; border: none; padding: 11px 20px;
            border-radius: 6px; font-weight: bold; cursor: pointer; margin-top: 15px; font-size: 14px;
        }
        button.btn-primary:hover { background: #1d4ed8; }

        table { width: 100%; border-collapse: collapse; margin-top: 12px; font-size: 14px; }
        th, td { padding: 11px 12px; border-bottom: 1px solid #e2e8f0; text-align: left; }
        th { background: #f8fafc; color: #334155; font-weight: 600; }
        .status-tersedia { background: #dcfce7; color: #166534; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .status-disewa { background: #fee2e2; color: #991b1b; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }

        .hero-user {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #fff; padding: 28px; border-radius: 14px; margin-bottom: 24px;
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.25);
        }
        .hero-user h2 { margin: 0 0 6px 0; font-size: 24px; }
        .hero-user p { margin: 0; opacity: 0.9; font-size: 14px; }
        .vehicle-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 20px;
        }
        .vehicle-card {
            background: #fff;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.07);
            transition: transform 0.2s;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .vehicle-card:hover { transform: translateY(-4px); }
        .vehicle-banner {
            background: #f8fafc;
            padding: 24px;
            text-align: center;
            font-size: 48px;
            border-bottom: 1px solid #f1f5f9;
            position: relative;
        }
        .badge-ready {
            position: absolute; top: 12px; right: 12px;
            background: #10b981; color: #fff; font-size: 11px;
            padding: 4px 10px; border-radius: 20px; font-weight: bold;
        }
        .vehicle-body { padding: 18px; }
        .vehicle-type { font-size: 12px; color: #64748b; text-transform: uppercase; font-weight: bold; }
        .vehicle-name { font-size: 18px; font-weight: bold; color: #0f172a; margin: 4px 0; }
        .vehicle-plat {
            display: inline-block; background: #e2e8f0; color: #334155;
            padding: 3px 8px; border-radius: 4px; font-family: monospace; font-size: 13px; font-weight: bold;
        }
        .vehicle-footer {
            padding: 14px 18px;
            background: #f8fafc;
            border-top: 1px solid #f1f5f9;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .price { color: #2563eb; font-weight: bold; font-size: 16px; }
        .price span { font-size: 12px; color: #64748b; font-weight: normal; }
    </style>
    <script>
        function tampilkanFitur(idSection, el) {
            const sections = document.querySelectorAll('.admin-section');
            sections.forEach(sec => {
                if (idSection === 'semua') {
                    sec.style.display = 'block';
                } else {
                    sec.style.display = (sec.id === idSection) ? 'block' : 'none';
                }
            });
            document.querySelectorAll('.menu-card').forEach(card => card.classList.remove('active'));
            if (el) el.classList.add('active');
        }
    </script>
</head>
<body>

<div class="navbar">
    <div class="brand">Sistem Rental Kendaraan</div>
    <div class="user-info">
        <span>Halo, <strong><%= namaUser %></strong></span>
        <span class="badge-role"><%= role %></span>
        <a href="LoginServlet?action=logout" class="btn-logout">Logout</a>
    </div>
</div>

<div class="container">

<%
    if ("admin".equals(role)) {
%>
    <div class="menu-grid">
        <div class="menu-card active" onclick="tampilkanFitur('semua', this)">
            <span class="menu-icon">&#128202;</span>
            <div class="menu-title">Semua Panel</div>
            <div class="menu-desc">Tampilkan seluruh menu &amp; data</div>
        </div>
        <div class="menu-card" onclick="tampilkanFitur('sec-pelanggan', this)">
            <span class="menu-icon">&#128100;</span>
            <div class="menu-title">Tambah Pelanggan</div>
            <div class="menu-desc">Registrasi &amp; daftar penyewa</div>
        </div>
        <div class="menu-card" onclick="tampilkanFitur('sec-kendaraan', this)">
            <span class="menu-icon">&#128663;</span>
            <div class="menu-title">Tambah Kendaraan</div>
            <div class="menu-desc">Kelola armada mobil &amp; motor</div>
        </div>
        <div class="menu-card" onclick="tampilkanFitur('sec-transaksi', this)">
            <span class="menu-icon">&#129534;</span>
            <div class="menu-title">Transaksi &amp; Riwayat</div>
            <div class="menu-desc">Proses sewa &amp; log transaksi</div>
        </div>
    </div>

    <div id="sec-pelanggan" class="card admin-section">
        <h3>Manajemen Data Pelanggan</h3>
        <form action="rental" method="post">
            <input type="hidden" name="aksi" value="tambah_pelanggan">
            <div class="form-grid">
                <div>
                    <label>No. KTP</label>
                    <input type="text" name="no_ktp" required placeholder="Contoh: 7171012345670001">
                </div>
                <div>
                    <label>Nama Lengkap</label>
                    <input type="text" name="nama_lengkap" required placeholder="Nama penyewa">
                </div>
                <div>
                    <label>No. HP</label>
                    <input type="text" name="no_hp" required placeholder="0812xxxxxxxx">
                </div>
                <div>
                    <label>Alamat</label>
                    <input type="text" name="alamat" required placeholder="Alamat domisili">
                </div>
            </div>
            <button type="submit" class="btn-primary">+ Simpan Pelanggan</button>
        </form>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>No. KTP</th>
                    <th>Nama Lengkap</th>
                    <th>No. HP</th>
                    <th>Alamat</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = KoneksiDB.getConnection();
                         Statement st = conn.createStatement();
                         ResultSet rs = st.executeQuery("SELECT * FROM id_data_pelanggan ORDER BY id_data_pelanggan DESC")) {
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id_data_pelanggan") %></td>
                    <td><%= rs.getString("no_ktp") %></td>
                    <td><%= rs.getString("nama_lengkap") %></td>
                    <td><%= rs.getString("no_hp") %></td>
                    <td><%= rs.getString("alamat") %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>

    <div id="sec-kendaraan" class="card admin-section">
        <h3>Manajemen Armada Kendaraan</h3>
        <form action="rental" method="post">
            <input type="hidden" name="aksi" value="tambah_kendaraan">
            <div class="form-grid">
                <div>
                    <label>Jenis Kendaraan</label>
                    <select name="jenis_kendaraan" required>
                        <option value="Mobil">Mobil</option>
                        <option value="Motor">Motor</option>
                    </select>
                </div>
                <div>
                    <label>Merk / Tipe Kendaraan</label>
                    <input type="text" name="merk_tipe" required placeholder="Contoh: Toyota Avanza">
                </div>
                <div>
                    <label>Plat Nomor</label>
                    <input type="text" name="plat_nomor" required placeholder="Contoh: DB 1234 AB">
                </div>
                <div>
                    <label>Harga Sewa / Hari (Rp)</label>
                    <input type="number" name="harga_per_hari" required placeholder="350000">
                </div>
            </div>
            <button type="submit" class="btn-primary">+ Tambah Armada</button>
        </form>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Jenis</th>
                    <th>Merk / Tipe</th>
                    <th>Plat Nomor</th>
                    <th>Tarif / Hari</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = KoneksiDB.getConnection();
                         Statement st = conn.createStatement();
                         ResultSet rs = st.executeQuery("SELECT * FROM data_kendaraan_rental ORDER BY id_kendaraan DESC")) {
                        while (rs.next()) {
                            String status = rs.getString("status_kendaraan");
                            BigDecimal harga = rs.getBigDecimal("harga_per_hari");
                %>
                <tr>
                    <td><%= rs.getInt("id_kendaraan") %></td>
                    <td><%= rs.getString("jenis_kendaraan") %></td>
                    <td><%= rs.getString("merk_tipe") %></td>
                    <td><strong><%= rs.getString("plat_nomor") %></strong></td>
                    <td>Rp <%= (harga != null) ? nf.format(harga) : "0" %></td>
                    <td>
                        <span class="<%= "Tersedia".equalsIgnoreCase(status) ? "status-tersedia" : "status-disewa" %>">
                            <%= status %>
                        </span>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>

    <div id="sec-transaksi" class="card admin-section">
        <h3>Transaksi Penyewaan &amp; Riwayat</h3>
        <form action="rental" method="post">
            <input type="hidden" name="aksi" value="proses_rental">
            <div class="form-grid">
                <div>
                    <label>Pilih Pelanggan</label>
                    <select name="id_data_pelanggan" required>
                        <%
                            try (Connection conn = KoneksiDB.getConnection();
                                 Statement st = conn.createStatement();
                                 ResultSet rs = st.executeQuery("SELECT id_data_pelanggan, nama_lengkap, no_ktp FROM id_data_pelanggan")) {
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id_data_pelanggan") %>">
                            <%= rs.getString("nama_lengkap") %> (<%= rs.getString("no_ktp") %>)
                        </option>
                        <%
                                }
                            } catch (Exception e) { }
                        %>
                    </select>
                </div>
                <div>
                    <label>Pilih Kendaraan (Tersedia)</label>
                    <select name="id_kendaraan" required>
                        <%
                            try (Connection conn = KoneksiDB.getConnection();
                                 Statement st = conn.createStatement();
                                 ResultSet rs = st.executeQuery("SELECT id_kendaraan, merk_tipe, plat_nomor, harga_per_hari FROM data_kendaraan_rental WHERE status_kendaraan = 'Tersedia'")) {
                                while (rs.next()) {
                                    BigDecimal hrg = rs.getBigDecimal("harga_per_hari");
                        %>
                        <option value="<%= rs.getInt("id_kendaraan") %>">
                            <%= rs.getString("merk_tipe") %> - <%= rs.getString("plat_nomor") %> (Rp <%= (hrg != null) ? nf.format(hrg) : "0" %>/hari)
                        </option>
                        <%
                                }
                            } catch (Exception e) { }
                        %>
                    </select>
                </div>
                <div>
                    <label>Tanggal Pinjam</label>
                    <input type="date" name="tanggal_pinjam" required>
                </div>
                <div>
                    <label>Tanggal Kembali</label>
                    <input type="date" name="tanggal_kembali" required>
                </div>
            </div>
            <button type="submit" class="btn-primary">Proses Transaksi Sewa</button>
        </form>

        <table>
            <thead>
                <tr>
                    <th>ID Transaksi</th>
                    <th>Pelanggan</th>
                    <th>Kendaraan</th>
                    <th>Tgl Pinjam</th>
                    <th>Tgl Kembali</th>
                    <th>Lama</th>
                    <th>Total Biaya</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String sqlTrans = "SELECT t.id_transaksi, p.nama_lengkap, k.merk_tipe, k.plat_nomor, t.tanggal_pinjam, t.tanggal_kembali, t.lama_sewa, t.total_biaya_sewa " +
                                      "FROM transaksi_rental t " +
                                      "JOIN id_data_pelanggan p ON t.id_data_pelanggan = p.id_data_pelanggan " +
                                      "JOIN data_kendaraan_rental k ON t.id_kendaraan = k.id_kendaraan " +
                                      "ORDER BY t.id_transaksi DESC";
                    try (Connection conn = KoneksiDB.getConnection();
                         Statement st = conn.createStatement();
                         ResultSet rs = st.executeQuery(sqlTrans)) {
                        while (rs.next()) {
                            BigDecimal total = rs.getBigDecimal("total_biaya_sewa");
                %>
                <tr>
                    <td>#<%= rs.getInt("id_transaksi") %></td>
                    <td><%= rs.getString("nama_lengkap") %></td>
                    <td><%= rs.getString("merk_tipe") %> (<%= rs.getString("plat_nomor") %>)</td>
                    <td><%= rs.getDate("tanggal_pinjam") %></td>
                    <td><%= rs.getDate("tanggal_kembali") %></td>
                    <td><%= rs.getInt("lama_sewa") %> hari</td>
                    <td><strong>Rp <%= (total != null) ? nf.format(total) : "0" %></strong></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7'>Belum ada transaksi atau error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
<%
    } else {
%>
    <div class="hero-user">
        <h2>Katalog Armada Kendaraan Tersedia</h2>
        <p>Pilih mobil atau motor siap pakai berikut untuk melakukan pemesanan langsung melalui petugas rental kami.</p>
    </div>

    <div class="vehicle-grid">
        <%
            boolean adaUnit = false;
            try (Connection conn = KoneksiDB.getConnection();
                 Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery("SELECT * FROM data_kendaraan_rental WHERE status_kendaraan = 'Tersedia' ORDER BY jenis_kendaraan, merk_tipe")) {
                while (rs.next()) {
                    adaUnit = true;
                    String jenis = rs.getString("jenis_kendaraan");
                    String ikon = "Motor".equalsIgnoreCase(jenis) ? "&#127949;" : "&#128663;";
                    BigDecimal hargaUnit = rs.getBigDecimal("harga_per_hari");
        %>
        <div class="vehicle-card">
            <div class="vehicle-banner">
                <span class="badge-ready">&#9679; TERSEDIA</span>
                <%= ikon %>
            </div>
            <div class="vehicle-body">
                <div class="vehicle-type"><%= jenis %></div>
                <div class="vehicle-name"><%= rs.getString("merk_tipe") %></div>
                <div class="vehicle-plat"><%= rs.getString("plat_nomor") %></div>
            </div>
            <div class="vehicle-footer">
                <div class="price">
                    Rp <%= (hargaUnit != null) ? nf.format(hargaUnit) : "0" %> <span>/ hari</span>
                </div>
                <span style="font-size:12px; color:#10b981; font-weight:bold;">Siap Sewa</span>
            </div>
        </div>
        <%
                }
            } catch (Exception e) {
                out.println("<p>Gagal memuat armada: " + e.getMessage() + "</p>");
            }
            if (!adaUnit) {
        %>
        <div class="card" style="grid-column: 1 / -1; text-align: center;">
            <h3>Maaf, saat ini semua unit kendaraan sedang disewa.</h3>
            <p>Silakan cek kembali beberapa saat lagi.</p>
        </div>
        <%
            }
        %>
    </div>
<%
    }
%>

</div>
</body>
</html>