<?php
session_start();

// Hủy toàn bộ session
$_SESSION = array();
session_destroy();

// Chuyển hướng về trang đăng nhập
header('Location: index.php');
exit;
