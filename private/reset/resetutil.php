<?php

class resetClass {
  public $email, $custid;
  public $questionid, $questionString;
  private $answer;
  public $answerInput;
  public $passOne, $passTwo, $msg1, $msg2;
  public $checkMark = '&#10003';
  public $loginPageUrl = '/crazylouswebsite/login.php';
  
  // check if email is in db, assign custid val
  public function checkEmail($useremail) {
    global $con;
    moreResCheck($con);
    $sql = "CALL reset_check_email('$useremail')";
    $result = $con->query($sql);
  
    if($row = $result->fetch_assoc()) {
      $_SESSION['resetcustid'] = $row['id'];
      return $row['id'];
    
    } else {
      unset($_SESSION['resetcustid']);
      return 0;
    }
  }

  // get question id
  public function getUserQuestionInfo($custid) {
    global $con; moreResCheck($con);
    $sql = "CALL reset_get_userquestion('$custid')";
    $result = $con->query($sql);

    if($row = $result->fetch_assoc()) {
      $this->questionid = $row['questionid'];
    }
  }

  public function getSecurityQuestion($questionid) {
    global $con; moreResCheck($con);
    $sql = "CALL reset_show_question('$questionid')";
    $result = $con->query($sql)->fetch_assoc();
    
    $_SESSION['questionString'] = $this->questionString = $result['question'];
  }

  public function checkAnswer($custid, $answerInput) {
    global $con; moreResCheck($con);
    $sql = "CALL reset_get_userquestion('$custid')";
    $result = $con->query($sql)->fetch_assoc();

    $result['answer'] == $answerInput ? $_SESSION['check2'] = 1 : $_SESSION['check2'] = 0;
  }

  public function updateNewPass($idnum, $pass) {
    global $con; moreResCheck($con);
    $sql = "CALL reset_update_pass('$idnum', '$pass')";
    $result = $con->query($sql);

    return $con->affected_rows ? $con->affected_rows : 0;
  }
  
  // cancel go back to login, clear vars
  public function unsetSessionVals() {
    unset($_SESSION['check1'], $_SESSION['check2'], $_SESSION['questionString'], $_SESSION['resetcustid'], $_SESSION['resetemail']);
  }

  public function displayMsgInvResult($msg) {
    return '<p class="text-danger small">' . $msg . '</p>';
  }

}

?>