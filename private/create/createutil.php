<?php

class NameClass {
  public $fname, $lname, $email, $password, $confirmPass;
  protected static $lastid;

  public function getInsertedId($email) {
    global $con; moreResCheck($con);
    $sql = "CALL create_get_inserted_id('$email')";
    $result = $con->query($sql)->fetch_assoc();
    SELF::$lastid = $result['lastid'];
    return $result['lastid'];
  }

  public function insertCustomerInfo($fname, $lname, $email, $pass) {
    $encrypted = md5($pass);
    global $con; moreResCheck($con);
    $sql = "CALL insert_new_cust('$fname', '$lname', '$email', '$encrypted')";
    if($result = $con->query($sql)) {
      return $this->getInsertedId($email);
    }
  }
}

class AddressClass extends NameClass {
  public $adrs, $ste, $city, $prov, $post, $ctry;

  public function insertAddress($adrs, $ste, $city, $prov, $post, $ctry) {
    $idval = PARENT::$lastid;
    global $con; moreResCheck($con);
    $sql = "CALL insert_new_address('$adrs', '$ste', '$city', '$prov', '$post', '$ctry', $idval)";
    $con->query($sql);
    return $con->affected_rows ? $con->affected_rows : 0;
    // yield val to check to proceed to phone
  }
}

class PhoneClass extends NameClass {
  public $num1, $ext1, $type1;
  public $num2, $ext2, $type2;
  
  function insertPhone($num, $ext, $type) {
    $custid = PARENT::$lastid;
    global $con; moreResCheck($con);
    $sql = "CALL insert_new_phone('$num', '$ext', '$type', '$custid')";
    $con->query($sql);
    return $con->affected_rows ? $con->affected_rows : 0;
    // yield val to check to proceed to NEXT phone
  }
}

// security
class SecurityQuestionClass extends NameClass {
  public $question, $answer;

  public function insertUserQuestion($questionid, $answer) {
    $custid = PARENT::$lastid;
    global $con; moreResCheck($con);
    $sql = "CALL userquestion_insert('$custid', '$questionid', '$answer')";
    $result = $con->query($sql);
    return $con->affected_rows ? $con->affected_rows : 0; // return may not be necessary
  }
}

?>