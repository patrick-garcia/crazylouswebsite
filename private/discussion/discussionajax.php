<?php
  ob_start();
  include_once '../../data/dbfile.php';
  include_once '../util/functions.php';

  if(isset($_GET['commentID'])) {
    $commentIdVal = intval($_GET['commentID']);
    removeComment($commentIdVal);
  }

  function removeComment($id) {
    global $con; moreResCheck($con);
    $sql = "CALL comment_remove($id)";
    $con->query($sql) or die($con);

    echo $con->affected_rows ? 1 : 0; 
  }

?>