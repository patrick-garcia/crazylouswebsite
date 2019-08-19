<?php

class LoadProfile {
  public $nameArray = [];
  public $addrArray = [];
  public $secQuesArray = [];
  public $phoneArray = [];
    
  public function __construct($id) {
    $this->loadName($id);
    $this->loadSecurity($id);
    $this->loadAddress($id);
    $this->loadPhone($id);
  }

  public function loadName($id) {
    global $con; moreResCheck($con);
    $sql = "CALL profile_load_user($id)";
    $result = $con->query($sql) or die($con->error);
    while($item = $result->fetch_assoc()) array_push($this->nameArray, $item);
  }

  public function loadAddress($id) {
    global $con; moreResCheck($con);
    $sql = "CALL profile_load_address($id)";
    $result = $con->query($sql) or die($con->error);
    while($item = $result->fetch_assoc()) array_push($this->addrArray, $item);
  }

  public function loadSecurity($id) {
    global $con; moreResCheck($con);
    $sql = "CALL profile_load_securityquestion($id)";
    $result = $con->query($sql) or die($con->error);
    while($item = $result->fetch_assoc()) array_push($this->secQuesArray, $item);
  }

  public function loadPhone($id) {
    global $con; moreResCheck($con);
    $sql = "CALL profile_load_phone($id)";
    $result = $con->query($sql) or die($con->error);
    while($item = $result->fetch_assoc()) array_push($this->phoneArray, $item);
  }
  
}

class ProfileClass {
  public $id;
  public $fname, $lname, $email;

  public function __construct($param) {
    $this->id = $param;
  }

  public function saveName($fn, $ln, $email) {
    global $con; moreResCheck($con);
    $sql = "CALL profile_update_name('$fn', '$ln', '$email', $this->id)";
    $con->query($sql);
  }
}

class PasswordClass {
  public $id;
  public $password, $confirmPass;

  public function __construct($param) {
    $this->id = $param;
  }

  public function savePass($password) {
    global $con; moreResCheck($con);
    $encrypted = md5($password);
    $sql = "CALL profile_update_pass('$encrypted', $this->id)";
    $con->query($sql);
  }
}

class AddressClass {
  public $id;
  public $adrs, $ste, $city, $prov, $post, $crty;

  public function __construct($param) {
    $this->id = $param;
  }

  public function saveAddress($adrs, $ste, $city, $post, $prov, $ctry) {
    global $con; moreResCheck($con);
    $sql = "CALL profile_update_address($this->id, '$adrs', '$ste', '$city', '$post', '$prov', '$ctry')";
    $con->query($sql);
  }
}

class PhoneClass {
  public $id;
  public $num1, $ext1, $ptype1, $phId1;
  public $num2, $ext2, $ptype2, $phId2; 

  public function __construct($param) {$this->id = $param;}

  public function savePhone($phoneID, $num, $ext, $type) {
    global $con; moreResCheck($con);
    $sql = "CALL profile_update_phone($phoneID, '$num', '$ext', '$type')";
    $con->query($sql);
  }
}

class SecurityQuestionClass {
  public $id;
  public $question, $answer;

  public function __construct($param) {
    $this->id = $param;
  }

  public function saveQuestion($question, $answer) {
    global $con; moreResCheck($con);
    $sql = "CALL profile_update_question('$question', '$answer', $this->id)";
    $con->query($sql);
  } 
}

?>