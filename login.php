<?php
  ob_start();
  !isset($_SESSION) ? session_start() : NULL;
  session_regenerate_id();
  include 'private/login/loginprocess.php';
  include 'public/template/header.html';
  include 'public/visitor/login.html';

?>