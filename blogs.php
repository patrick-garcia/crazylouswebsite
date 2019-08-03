<?php
  ob_start();
  !isset($_SESSION) ? session_start() : NULL;
  include 'private/blog/blogsprocess.php';
  include 'public/template/header.html';
  include 'public/template/banner.html';
  include 'public/visitor/blogs.html';
  include 'public/template/footer.html';

?>