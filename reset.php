<?php
  ob_start();
  !isset($_SESSION) ? session_start() : NULL;
  include 'private/reset/resetprocess.php';
  include 'public/template/header.html';
  include 'public/visitor/reset.html';

?>