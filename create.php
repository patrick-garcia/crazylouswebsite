<?php
  ob_start();
  !isset($_SESSION) ? session_start() : NULL;
  include 'private/create/createprocess.php';
  include 'public/template/header.html';
  include 'public/template/banner.html';
  include 'public/visitor/create.html';
  include 'public/template/footer.html';
?>