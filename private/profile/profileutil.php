<?php

class profileClass {
  public $question;
  public $answer;

  public function saveQuestion($question, $answer, $userid) {
    global $con; $con->next_result();
    $sql = "CALL profile_update_question('$question', '$answer', '$userid')";
    $con->query($sql);
  }
}

?>