<?php
  !isset($_SESSION) ? session_start() : NULL;
  include_once 'data/dbfile.php';
  include_once 'private/util/variables.php';
  include_once 'private/util/functions.php';
  include_once 'private/admin/adminutil.php';
  include_once 'discussionadminutil.php';

  if(!isset($_SESSION['loggedID'])) {
    exit(header("location: index.php"));
    ob_end_flush();

  } else {
    $adminCheck = AdminCheckClass::adminCheck($_SESSION['loggedID']);
    
    if($adminCheck == 0) {
      exit(header("location: albums.php"));
      ob_end_flush();

    } else {
      new LoadDiscussionPost;
    }
  }

?>