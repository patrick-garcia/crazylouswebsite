<?php
session_id();
include_once 'data/dbfile.php';
include_once 'resetutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';

!isset($reset) ? $reset = new resetClass : '';
global $errors;

// clear vals when coming from login page
if(!isset($_SESSION['prevUrl'])) {
  !isset($_SESSION['check1']) ? $_SESSION['check1'] = 0 : NULL;

} else {
  if($_SESSION['prevUrl'] == $reset->loginPageUrl) {
    $_SESSION['check1'] = $_SESSION['check2'] = 0;
    unset($_SESSION['prevUrl']);
  } else {
    !isset($_SESSION['check1']) ? $_SESSION['check1'] = 0 : NULL;
    !isset($_SESSION['check2']) ? $_SESSION['check2'] = 0 : NULL;
}}

// email check
if(isset($_POST['resetEmailBtn']) ) {
  $reset->email = $_SESSION['resetemail'] = $_POST['resetEmailInput'];
  validInput($reset->email, 'resetemail');

  if(count($errors) < 1) {
    $reset->custid = $reset->checkEmail($reset->email);

    if($reset->custid > 0) {
      $_SESSION['check1'] = 1;
      $reset->getUserQuestionInfo($reset->custid);

      if($reset->questionid > 0) {
        $reset->getSecurityQuestion($reset->questionid);
      }

    } else {
      $_SESSION['check1'] = 0;
      $_SESSION['check2'] = 0;
      $reset->msg1 = '* email NOT found';
    }
  
  } else {
    $_SESSION['check1'] = 0;
    unset($_SESSION['resetemail']);
  }

  $_SESSION['check2'] = 0;  
}

// security check
if(isset($_POST['resetAnswerBtn'])) {
  $reset->answerInput = $_POST['resetAnswerInput'];
  validInput($reset->answerInput, 'resetanswer');

  if(count($errors) < 1) {

    $reset->email = $_SESSION['resetemail'];
    $reset->custid = $reset->checkEmail($reset->email);

    $reset->checkAnswer($reset->custid, $reset->answerInput); // assigns new val to check2
    $_SESSION['check2'] == 0 ? $reset->msg2 = '* incorrect answer' : NULL;
  }  
}

// set new password
if(isset($_POST['resetPassBtn'])) {
  $reset->passOne = $_POST['passInput1'];
  $reset->passTwo = $_POST['passInput2'];

  validInput($reset->passOne, 'passOne');
  validInput($reset->passTwo, 'passTwo');
  validPassword($reset->passOne, $reset->passTwo, 'passCheck');

  if(count($errors) < 1) {
    $reset->custid = $_SESSION['resetcustid'];
    $reset->passOne = md5($reset->passOne);

    $row = $reset->updateNewPass($reset->custid, $reset->passOne);
    if($row > 0) {
      $_SESSION['message'] = 'your password has been updated... please login below ';
      $reset->unsetSessionVals();
      exit(header("location: index.php"));
      ob_end_flush();
    }
  }
}

// back btn
if(isset($_POST['resetBackToLogin'])) {
  $reset->unsetSessionVals();
  exit(header("location: index.php"));
  ob_end_flush();
}

?>