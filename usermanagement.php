<?php
  ob_start();
  !isset($_SESSION) ? session_start() : NULL;
  include 'private/admin/user/usermanagementprocess.php';
  include 'public/template/header.html';
  include 'public/template/banner.html';
  include 'public/template/nav.html';
  include 'public/admin/usermanagement.html';
  include 'public/template/footer.html';

?>