<?php
!isset($_SESSION) ? session_start() : NULL;
include_once 'data/dbfile.php';
include_once 'data/siteinfo.php';
include_once 'loginutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';


if(isset($_SESSION['loggedID'])) {
  exit(header("location: albums.php"));
  ob_end_flush();
} else {
  !isset($login) ? $login = new loginUser : '';
}

if(isset($_POST['loginsubmit'])) {
  $login->user = $_POST['userlogin'];
  validInput($login->user, 'userlogin');
  
  $login->pass = $_POST['passlogin'];
  validInput($login->pass, 'passlogin');
  
  if(count($errors) == 0) {
    $_SESSION['sessionid'] = $sessionval = session_id();
    $loggedID = $_SESSION['loggedID'] = $login->getloginID($login->user, md5($login->pass));

    if($loggedID > 0) {
      $login->clearPrevLogin($loggedID);

      if($login->newSession($loggedID, $sessionval) > 0) {
        unset($sessionval);
        unset($login);
        header("location: albums.php");
        ob_end_flush();
    }}
}}

$_SESSION['prevUrl'] = $_SERVER['REQUEST_URI'];

?>


