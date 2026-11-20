package com.rental;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("register".equals(action)) {
            String namaLengkap = request.getParameter("nama_lengkap");
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            try (Connection conn = KoneksiDB.getConnection()) {
                // Cek apakah username sudah dipakai
                String cekSql = "SELECT id_user FROM users WHERE username = ?";
                try (PreparedStatement psCek = conn.prepareStatement(cekSql)) {
                    psCek.setString(1, username);
                    try (ResultSet rsCek = psCek.executeQuery()) {
                        if (rsCek.next()) {
                            response.sendRedirect("login.jsp?mode=register&error=exists");
                            return;
                        }
                    }
                }

                // Simpan akun user baru
                String insertSql = "INSERT INTO users (username, password, nama_lengkap, role) VALUES (?, ?, ?, 'user')";
                try (PreparedStatement psIns = conn.prepareStatement(insertSql)) {
                    psIns.setString(1, username);
                    psIns.setString(2, password);
                    psIns.setString(3, namaLengkap);
                    psIns.executeUpdate();
                }

                response.sendRedirect("login.jsp?registered=1");
            } catch (Exception e) {
                throw new ServletException("Gagal mendaftarkan akun: " + e.getMessage(), e);
            }
            return;
        }

        // Proses Login
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = KoneksiDB.getConnection()) {
            String sql = "SELECT nama_lengkap, role FROM users WHERE username = ? AND password = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        session.setAttribute("nama_lengkap", rs.getString("nama_lengkap"));
                        session.setAttribute("role", rs.getString("role"));
                        response.sendRedirect("index.jsp");
                    } else {
                        response.sendRedirect("login.jsp?error=1");
                    }
                }
            }
        } catch (Exception e) {
            throw new ServletException("Gagal memproses login: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp");
        }
    }
}