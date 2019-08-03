<?php
  class regClass {
    public $question;
    public $answer;

    public function insertUserQuestion($custid, $questionid, $answer) {
      global $con; $con->next_result();
      $sql = "CALL userquestion_insert('$custid', '$questionid', '$answer')";
      $result = $con->query($sql);
      // return below is not necessary
      return $con->affected_rows ? $con->affected_rows : 0;
    }
  }

?>