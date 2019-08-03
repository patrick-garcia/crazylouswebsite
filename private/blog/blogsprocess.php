<?php
  !isset($_SESSION) ? session_start() : NULL;
  include_once 'data/dbfile.php';
  include_once 'blogsutil.php';
  include_once 'private/util/variables.php';
  include_once 'private/util/functions.php';


  !isset($blog) ? $blog = new blogClass : '';

  // $blog->row = $blog->testVal;
  $blog->row = $blog->loadBlogs();
  
?>