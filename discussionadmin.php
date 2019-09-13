<?php
  ob_start();
  !isset($_SESSION) ? session_start() : NULL;
  include 'private/admin/discussionadmin/discussionadminprocess.php';
  include 'public/template/header.html';
  include 'public/template/banner.html';
  include 'public/template/nav.html';
  include 'public/admin/discussionadmin.html';
  include 'public/template/footer.html';

?>