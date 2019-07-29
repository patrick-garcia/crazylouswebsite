<?php
  ob_start();
  !isset($_SESSION) ? session_start() : NULL;
  include 'private/history/historyprocess.php';
  include 'public/template/header.html';
  include 'public/template/banner.html';
  include 'public/template/nav.html';
  include 'public/customer/history.html';
  include 'public/template/footer.html';
?>