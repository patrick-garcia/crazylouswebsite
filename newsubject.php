<?php
  ob_start();
  !isset($_SESSION) ? session_start() : NULL;
  include 'private/admin/newsubject/newsubjectprocess.php';
  include 'public/template/header.html';
  include 'public/template/banner.html';
  include 'public/template/nav.html';
  include 'public/admin/newsubject.html';
  include 'public/template/footer.html';

?>