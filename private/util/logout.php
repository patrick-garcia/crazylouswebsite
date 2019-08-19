<?php
!isset($_SESSION) ? session_start() : NULL;
include_once '../../data/dbfile.php';
include_once 'variables.php';
include_once 'functions.php';

if (verifySession() > 0) {
  if(isset($_SESSION['session_id_num'])) {
    $val = $_SESSION['session_id_num'];
    unset($_SESSION['session_id_num']);
    updateLogoutDate($val);
    
  } else redirectToIndex();
} else redirectToIndex();

function verifySession() {
  if(isset($_SESSION['sessionid']) && isset($_SESSION['loggedID'])) {
    $sessval = $_SESSION['sessionid'];
    $id = $_SESSION['loggedID'];

    global $con; $con->next_result();
    $sql = "CALL session_check($id, '$sessval')";

    if($result = $con->query($sql)) {
      $row = $result->fetch_assoc();
      $_SESSION['session_id_num'] = $row['id'];
      return $row['id'];

    } else return 0;
  } else return 0;
};

function updateLogoutDate($idnum) {
  global $con; $con->next_result();
  $sql = "CALL session_update_logout_date($idnum)";
  $con->query($sql);
  redirectToIndex();
}

function redirectToIndex() {
  session_destroy();
  exit(header("location: ../../index.php"));
}

?>

