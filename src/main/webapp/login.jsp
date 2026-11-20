<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Sistem Rental Kendaraan</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 340px; }
        h2 { text-align: center; margin-bottom: 20px; color: #333; }
        input[type="text"], input[type="password"] { width: 100%; padding: 10px; margin: 8px 0 16px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #007bff; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background: #0056b3; }
        .error { color: #d9534f; text-align: center; margin-bottom: 12px; font-size: 14px; }
        .info { background: #eef5ff; padding: 10px; border-radius: 4px; font-size: 12px; color: #333; margin-top: 15px; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Login Rental Kendaraan</h2>
        <% if ("1".equals(request.getParameter("error"))) { %>
            <div class="error">Username atau password salah!</div>
        <% } %>
        <form action="LoginServlet" method="post">
            <label>Username</label>
            <input type="text" name="username" required placeholder="Masukkan username">
            <label>Password</label>
            <input type="password" name="password" required placeholder="Masukkan password">
            <button type="submit">Masuk</button>
        </form>
        <div class="info">
            <strong>Akun Uji Coba:</strong><br>
            Admin: <code>admin</code> / <code>admin123</code><br>
            User: <code>user1</code> / <code>user123</code>
        </div>
    </div>
</body>
</html>