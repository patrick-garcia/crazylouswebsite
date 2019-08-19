<?php
session_id();
include_once 'data/dbfile.php';
include_once 'resetutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';

!isset($stp1) ? $stp1 = new StepOneClass : '';
!isset($message) ? $message =  new MessageClass : '';

// clear vals when coming from login page
if(!isset($_SESSION['prevUrl'])) {
  !isset($_SESSION['check1']) ? $_SESSION['check1'] = 0 : NULL;

} else {
  if($_SESSION['prevUrl'] == $message->url) {
    $_SESSION['check1'] = $_SESSION['check2'] = 0;
    unset($_SESSION['prevUrl']);
  } else {
    !isset($_SESSION['check1']) ? $_SESSION['check1'] = 0 : NULL;
    !isset($_SESSION['check2']) ? $_SESSION['check2'] = 0 : NULL;
}}

// email check
if(isset($_POST['emailCheckBtn']) ) {
  $stp1->email = $_POST['resetEmailInput'];
  validInput($stp1->email, 'resetemail');

  if(count($errors) < 1) {
    $idCheck1 = $_SESSION['custid'] = $stp1->checkEmail($stp1->email);

    if($idCheck1 > 0) {
      $_SESSION['check1'] = 1;
      $message->msg1 = '';

    } else {
      $_SESSION['check1'] = 0;
      $_SESSION['check2'] = 0;
      $message->msg1 = '*** email NOT found, you can go back to login to create new account ***';
    }
  
  } else {
    $_SESSION['check1'] = 0;
  }

  $_SESSION['check2'] = 0;  
}

// security check
if(isset($_POST['answerCheckBtn'])) {
  $answerCheck = new StepTwoClass($_POST['resetAnswerInput'], $_SESSION['custid']);

  validInput($answerCheck->answerInput, 'resetanswer');

  if(count($errors) < 1) {
    $answerCheck->checkAnswer(); // assigns new val to check2
    $_SESSION['check2'] == 0 ? $message->msg2 = '*** incorrect answer, try again ***' : NULL;
  }  
}

// set new password
if(isset($_POST['resetPassBtn'])) {
  $passOne = $_POST['passInput1'];
  $passTwo = $_POST['passInput2'];

  validInput($passOne, 'passOne');
  validInput($passTwo, 'passTwo');
  validPassword($passOne, $passTwo, 'passCheck');

  if(count($errors) < 1) {
    $confirmNewPass = NewPasswordClass::updateNewPass($_SESSION['custid'], $passOne);

    if($confirmNewPass > 0) {
      $_SESSION['message'] = 'your password has been updated... please login below ';
      unsetSessionVals();
      exit(header("location: index.php"));
      ob_end_flush();
    } else {
      $message->msg3 = '*** cannot use your old password ***';
    }
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
  unset($_SESSION['check1'], $_SESSION['check2'], $_SESSION['questionString'], $_SESSION['custid'], $_SESSION['prevUrl']);
}

function displayMsgInvResult($msg) {
  return '<p class="text-danger small">' . $msg . '</p>';
}


?>