<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    boolean isRegister = "register".equals(request.getParameter("mode"));
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masuk &amp; Daftar - Sistem Rental Kendaraan</title>
    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(rgba(15, 23, 42, 0.72), rgba(15, 23, 42, 0.85)),
                        url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1600&q=80') center/cover no-repeat fixed;
            padding: 20px;
        }
        .auth-card {
            background: #ffffff;
            width: 100%;
            max-width: 420px;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
            position: relative;
            z-index: 10;
        }
        .brand-header { text-align: center; margin-bottom: 22px; }
        .brand-icon {
            width: 56px; height: 56px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #fff; font-size: 28px;
            border-radius: 14px; display: inline-flex;
            align-items: center; justify-content: center;
            margin-bottom: 10px;
            box-shadow: 0 6px 16px rgba(37, 99, 235, 0.35);
        }
        .brand-header h2 { margin: 0; color: #0f172a; font-size: 22px; }
        .brand-header p { margin: 4px 0 0; color: #64748b; font-size: 13px; }

        .tabs {
            display: flex;
            background: #f1f5f9;
            padding: 4px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .tab-btn {
            flex: 1; padding: 9px; border: none; background: transparent;
            border-radius: 8px; font-weight: bold; font-size: 14px;
            color: #64748b; cursor: pointer; transition: 0.2s;
        }
        .tab-btn.active {
            background: #fff; color: #2563eb;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        }

        label { display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px; }
        input {
            width: 100%; padding: 11px 13px; margin-bottom: 15px;
            border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px;
        }
        input:focus { outline: none; border-color: #2563eb; }
        .btn-submit {
            width: 100%; padding: 12px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #fff; border: none; border-radius: 8px;
            font-size: 15px; font-weight: bold; cursor: pointer;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
        .btn-submit:hover { background: linear-gradient(135deg, #1d4ed8, #1e40af); }

        .alert { padding: 10px 12px; border-radius: 8px; font-size: 13px; margin-bottom: 16px; text-align: center; }
        .alert-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }

        .demo-box {
            margin-top: 18px; padding: 12px;
            background: #f8fafc; border: 1px dashed #cbd5e1;
            border-radius: 8px; font-size: 12px; color: #475569; line-height: 1.6;
        }
        .demo-box code { background: #e2e8f0; padding: 2px 5px; border-radius: 4px; color: #0f172a; }
    </style>
    <script>
        function switchTab(mode) {
            document.getElementById('form-login').style.display = (mode === 'login') ? 'block' : 'none';
            document.getElementById('form-register').style.display = (mode === 'register') ? 'block' : 'none';
            document.getElementById('tab-login').classList.toggle('active', mode === 'login');
            document.getElementById('tab-register').classList.toggle('active', mode === 'register');
        }
    </script>
</head>
<body>
    <div class="auth-card">
        <div class="brand-header">
            <div class="brand-icon">&#128664;</div>
            <h2>Rental Kendaraan</h2>
            <p>Sistem Informasi Penyewaan Mobil &amp; Motor</p>
        </div>

        <div class="tabs">
            <button type="button" id="tab-login" class="tab-btn <%= !isRegister ? "active" : "" %>" onclick="switchTab('login')">Masuk Akun</button>
            <button type="button" id="tab-register" class="tab-btn <%= isRegister ? "active" : "" %>" onclick="switchTab('register')">Buat Akun User</button>
        </div>

        <% if ("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">Username atau password salah!</div>
        <% } else if ("exists".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">Username sudah digunakan, pilih username lain!</div>
        <% } else if ("1".equals(request.getParameter("registered"))) { %>
            <div class="alert alert-success">Akun berhasil dibuat! Silakan masuk.</div>
        <% } %>

        <form id="form-login" action="LoginServlet" method="post" style="display: <%= !isRegister ? "block" : "none" %>;">
            <input type="hidden" name="action" value="login">
            <label>Username</label>
            <input type="text" name="username" required placeholder="Masukkan username Anda">
            <label>Password</label>
            <input type="password" name="password" required placeholder="Masukkan password">
            <button type="submit" class="btn-submit">Masuk Sekarang</button>
        </form>

        <form id="form-register" action="LoginServlet" method="post" style="display: <%= isRegister ? "block" : "none" %>;">
            <input type="hidden" name="action" value="register">
            <label>Nama Lengkap</label>
            <input type="text" name="nama_lengkap" required placeholder="Contoh: Budi Santoso">
            <label>Username Baru</label>
            <input type="text" name="username" required placeholder="Buat username tanpa spasi">
            <label>Password Baru</label>
            <input type="password" name="password" required placeholder="Buat password akun">
            <button type="submit" class="btn-submit">Daftar Akun User</button>
        </form>

        <div class="demo-box">
            <strong>Akun Uji Coba Tersedia:</strong><br>
            &bull; Admin: <code>admin</code> / <code>admin123</code><br>
            &bull; User: <code>user1</code> / <code>user123</code>
        </div>
    </div>
</body>
</html>