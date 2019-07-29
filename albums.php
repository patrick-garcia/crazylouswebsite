<?php
  ob_start();
  !isset($_SESSION) ? session_start() : NULL;
  include 'private/album/albumsprocess.php';
  include 'public/template/header.html';
  include 'public/template/banner.html';
  include 'public/template/nav.html';
  include 'public/customer/albums.html';
  include 'public/template/footer.html';

?>

