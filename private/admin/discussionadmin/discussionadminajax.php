<?php
  ob_start();
  include_once '../../../data/dbfile.php';
  include_once '../../util/functions.php';

  if(isset($_GET['postID'])) {
    $postIdVal = intval($_GET['postID']);
    removePost($postIdVal);
  }

  function removePost($id) {
    global $con; moreResCheck($con);
    $sql = "CALL discussion_post_remove($id)";
    $con->query($sql) or die($con);

    echo $con->affected_rows ? 1 : 0; 
  }

?>