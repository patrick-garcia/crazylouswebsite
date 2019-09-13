<?php

class EmailCheck {
  public $userID, $questionID;

  public function __construct($email) {
    $this->userID = $this->checkEmail($email);
  }
  
  private function checkEmail($useremail) {
    global $con; moreResCheck($con);
    $sql = "CALL reset_check_email('$useremail')";
    $result = $con->query($sql)->fetch_assoc();

    if($result['id'] > 0 && $result['active'] == 1) {
      return $result['id'];

    } else {
      return 0;
    }
  }

  // get question id
  public function getQuestionInfo($sqlResult = 'questionid') {
    $idval = $this->userID;
    global $con; moreResCheck($con);
    $sql = "CALL reset_get_userquestion('$idval')";
    $result = $con->query($sql)->fetch_assoc();
    return $result[$sqlResult];
  }

  public function getQuestionString() {
    $idval = $this->questionID;
    global $con; moreResCheck($con);
    $sql = "CALL reset_show_question('$idval')";
    $result = $con->query($sql)->fetch_assoc();
    return $result['question'];
  }
}

class AnswerCheck extends EmailCheck {}

class NewPasswordClass {  
  static function updateNewPass($idnum, $pass) {
    $encrypted = md5($pass);
    global $con; moreResCheck($con);
    $sql = "CALL reset_update_pass('$idnum', '$encrypted')";
    $result = $con->query($sql);

    return $con->affected_rows ? $con->affected_rows : 0;
  }
}

?>