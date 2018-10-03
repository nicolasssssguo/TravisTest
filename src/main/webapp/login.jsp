<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
</head>
<style>
    body {
        background: #fff;
        position: absolute;
        width: 100%;
        height: 100%;
    }
    .content {
        max-width: 400px;
        margin: 10% auto;
        border-radius: 10px;
        padding: 48px 40px 36px;
        box-shadow: 0 2px 2px 0 rgba(0,0,0,0.14), 0 3px 1px -2px rgba(0,0,0,0.12), 0 1px 5px 0 rgba(0,0,0,0.2);
    }
    .logo {
        height: 30px;
        width: 20%;
        margin: 0 auto;
    }
    img {
        width: 100%;
        height: 100%;
    }
    p {
        text-align: center;
        font-size: 24px;
    }
    a {
        display: block;
        line-height: 60px;
        color: #000000;
        font-size: 16px;
        text-decoration:none;
        margin: auto -40px;
        padding: 0 40px;
    }
    a:hover{
        background-color: #f3f3f3;
    }
    a img {
        width: 36px;
        height: 36px;
        vertical-align: middle;
        margin-right: 20px;
    }
</style>
<body>
    <div class="content">
        <div class="logo">
            <img src="/images/logo.png" alt="">
        </div>
        <p>Choose an types</p>
        <a href="/login?student=student">
            <img src="/images/icon_student.png" alt="">
            Student Login
        </a>
        <a href="/login?instructor=instructor">
            <img src="/images/icon_instructor.png" alt="">
            Instructor Login
        </a>
        <a href="/login?admin=admin">
            <img src="/images/icon_admin.png" alt="">
            Admin Login
        </a>
    </div>
</body>
</html>
