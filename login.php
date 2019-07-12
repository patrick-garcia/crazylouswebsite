<?php
ob_start();
!isset($_SESSION) ? session_start() : NULL;
session_regenerate_id();
include './public/template/header.html';
include './public/login.html';
?>