<?php
  ob_start();
  include_once '../../../data/dbfile.php';
  include_once '../../util/functions.php';

  if(isset($_GET['id'])) {
    $idnum = $_GET['id'];
    global $con; moreResCheck($con);

    if(isset($_GET['subscriber'])) {
      $subNum = $_GET['subscriber'];
      $sql = "CALL usermanage_update_subscriber($idnum, $subNum)";
      $con->query($sql) or die($con);
      echo $con->affected_rows ? 1 : 0; 

    } elseif (isset($_GET['expert'])) {
      $expNum = $_GET['expert'];
      $sql = "CALL usermanage_update_expert($idnum, $expNum)";
      $con->query($sql) or die($con);
      echo $con->affected_rows ? 1 : 0; 
    }
  }

?>