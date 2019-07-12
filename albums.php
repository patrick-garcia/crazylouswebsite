<?php
ob_start();
!isset($_SESSION) ? session_start() : NULL;
include './public/template/header.html';
include './public/template/banner.html';
include './public/template/nav.html';
include './public/albums.html';
include './public/template/footer.html';
?>

