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
  if(isset($_POST['loginsubmit'])) {
    $login = new LoginUser($_POST['userlogin'], $_POST['passlogin']);
    validInput($login->username, 'userlogin');
    validInput($login->password, 'passlogin');
    
    if(count($errors) == 0) {
      $_SESSION['loggedID'] = $login->getloginID($login->username, $login->password);
      
      if($login->loggedID > 0) {
        new ClearPrevLogin($login->loggedID);

        if($newSess = new NewSessionClass()) {
          header("location: albums.php");
          ob_end_flush();
      }}
  }}
}

// required for password reset section
$_SESSION['prevUrl'] = $_SERVER['REQUEST_URI'];

?>


