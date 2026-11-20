package com.rental;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class KoneksiDB {
    private static final String URL = "jdbc:mysql://rental-db-jhosuamilji0-0a3f.j.aivencloud.com:16982/defaultdb?sslMode=REQUIRED&serverTimezone=UTC";
    private static final String USER = "avnadmin";
    private static final String PASSWORD = "AVNS_SpayUzqrfPgIbVDSQRa";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver MySQL JDBC tidak ditemukan!", e);
        }
    }
}