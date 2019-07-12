<?php
!isset($_SESSION) ? session_start() : NULL;
include_once 'dbfile.php';
include_once 'variables.php';
include_once 'functions.php';

if(isset($_SESSION['loggedID'])) {
  exit(header("location: albums.php"));
  ob_end_flush();
} else {
  !isset($login) ? $login = [] : '';
}

if(isset($_POST['loginsubmit'])) {
  $login['user'] = $_POST['userlogin'];
  validInput($login['user'], 'userlogin');
  
  $login['pass'] = $_POST['passlogin'];
  validInput($login['pass'], 'passlogin');
  
  if(count($errors) == 0) {
    $_SESSION['sessionid'] = $sessionval = session_id();
    $loggedID = $_SESSION['loggedID'] = getloginID($login['user'], md5($login['pass']));

    if($loggedID > 0) {
      clearPrevLogin($loggedID);

      if(new_session($loggedID, $sessionval) > 0) {
        unset($sessionval);
        header("location: albums.php");
        ob_end_flush();
    }}

    unset($login);
}}

function getloginID($user, $pass) {
  global $con; moreResCheck($con);
  $loginInfo = $con->query("CALL login_check('$user', '$pass')") or die($con->error);
  if ($row = $loginInfo->fetch_assoc()) {
    return $row['loginid'];

  } else {
    global $errors;
    $errors['incorrectLogin'] = '*** invalid username or password ***';
}}

function clearPrevLogin($loggedID) {
  global $con; moreResCheck($con);
  $con->query("CALL logout_clear_prev($loggedID)");
}

function new_session($id, $sessval) {
  global $con;
  moreResCheck($con);
  $sql = "CALL session_insert($id, '$sessval')";
  $result = $con->query($sql);

  return $con->affected_rows ? $con->affected_rows : 0;
}


?>


