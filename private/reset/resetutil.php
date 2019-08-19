<?php

class StepOneClass {
  static public $custid;
  static protected $questionid, $answer;

  public $email;
  public $questionString;
  public $answerInput;
  
  // check if email is in db, assign custid val
  public function checkEmail($useremail) {
    global $con; moreResCheck($con);
    $sql = "CALL reset_check_email('$useremail')";
    $result = $con->query($sql)->fetch_assoc();

    if($result['id'] > 0 && $result['active'] == 1) {
      SELF::$custid = $result['id'];
      $this->getUserQuestionInfo(); // call function
      return SELF::$custid;
    
    } else return 0;
  }

  public function getUserQuestionInfo() {
    $idval = SELF::$custid;
    global $con; moreResCheck($con);
    $sql = "CALL reset_get_userquestion('$idval')";
    $result = $con->query($sql);

    if($row = $result->fetch_assoc()) {
      SELF::$questionid = $row['questionid'];
      SELF::$answer = $row['answer'];
      $this->getSecurityQuestion();
    
    } else return 0;
  }

  public function getSecurityQuestion() {
    $idval = SELF::$questionid;
    global $con; moreResCheck($con);
    $sql = "CALL reset_show_question('$idval')";
    $result = $con->query($sql)->fetch_assoc();

    $_SESSION['questionString'] = $result['question'];
  }

// ****
  public function checkAnswerOLD($custid, $answerInput) {
    global $con; moreResCheck($con);
    $sql = "CALL reset_get_userquestion('$custid')";
    $result = $con->query($sql)->fetch_assoc();

    $result['answer'] == $answerInput ? $_SESSION['check2'] = 1 : $_SESSION['check2'] = 0;
  }

// ****

  public function updateNewPassOLD($idnum, $pass) {
    global $con; moreResCheck($con);
    $sql = "CALL reset_update_pass('$idnum', '$pass')";
    $result = $con->query($sql);

    return $con->affected_rows ? $con->affected_rows : 0;
  }


  
}

class StepTwoClass extends StepOneClass {
  public $answerInput;
  public $idval;

  public function __construct($answerInput, $id) {
    $this->answerInput = $answerInput;
    $this->idval = $id;
  }
  
  public function checkAnswer() {
    // <PARENT::$custid> will not transfer from ParentClass ????
    $id = $this->idval;
    global $con; moreResCheck($con);
    $sql = "CALL reset_get_userquestion('$id')";
    $result = $con->query($sql)->fetch_assoc();

    $result['answer'] == $this->answerInput ? $_SESSION['check2'] = 1 : $_SESSION['check2'] = 0;
  }
}

class NewPasswordClass {  
  static function updateNewPass($idnum, $pass) {
    $encrypted = md5($pass);
    global $con; moreResCheck($con);
    $sql = "CALL reset_update_pass('$idnum', '$encrypted')";
    $result = $con->query($sql);

    return $con->affected_rows ? $con->affected_rows : 0;
  }
}

class MessageClass {
  public $msg1, $msg2, $msg3;
  public $checkmark = '&#10003';
  public $url = '/crazylouswebsite/login.php';
}


?>

