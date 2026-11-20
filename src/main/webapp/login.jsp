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
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(12px);
            width: 100%;
            max-width: 420px;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
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
            transition: border-color 0.2s;
        }
        input:focus { outline: none; border-color: #2563eb; }
        .btn-submit {
            width: 100%; padding: 12px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #fff; border: none; border-radius: 8px;
            font-size: 15px; font-weight: bold; cursor: pointer;