<?php
!isset($_SESSION) ? session_start() : NULL;
include_once 'data/dbfile.php';
include_once 'resetutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';

// set new password
if(isset($_POST['resetPassBtn'])) {
  $passOne = $_POST['passInput1'];
  $passTwo = $_POST['passInput2'];

  $confirmNewPass = NewPasswordClass::updateNewPass($_SESSION['custid'], $passOne);

  if($confirmNewPass > 0) {
    $_SESSION['message'] = 'your password has been updated... please login below ';
    unsetSessionVals();
    exit(header("location: index.php"));
    ob_end_flush();
  }
}

// back btn
if(isset($_POST['resetBackToLogin'])) {
  unsetSessionVals();
  exit(header("location: index.php"));
  ob_end_flush();
}

// load functions
function unsetSessionVals() {
  unset($_SESSION['custid']);
}

?>
