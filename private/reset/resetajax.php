<?php
!isset($_SESSION) ? session_start() : NULL;
include_once '../../data/dbfile.php';
include_once '../util/functions.php';
include_once 'resetutil.php';

if (isset($_GET['email']) && !isset($_GET['answer'])) {
  $email  = $_GET['email'];
  
  $newUser = new EmailCheck($email);
  $_SESSION['custid'] = $newUser->userID;
  $newUser->questionID = $newUser->userID ? $newUser->getQuestionInfo() : '';
  $questionStr = $newUser->questionID ? $newUser->getQuestionString() : '';

  $data = ['userid' => $newUser->userID, 'string' => $questionStr];
  echo json_encode($data);

} else if (isset($_GET['answer'])) {
  $answer = strtolower($_GET['answer']);
  $ansObj = new AnswerCheck($_GET['email']);
  $dbAnswer = strtolower($ansObj->getQuestionInfo('answer'));
  
  echo $answer == $dbAnswer ? 1 : 0;
}

?>