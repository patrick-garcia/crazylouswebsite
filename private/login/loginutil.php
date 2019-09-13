<?php

class LoginUser {
  public $username;
  public $password;
  public $loggedID;
  protected static $id;
    
  public function __construct($user, $pass) {
    $this->username = $user;
    $this->password = $pass;
  }
  
  public function getloginID($user, $pass) {
    global $con; moreResCheck($con);
    $encyptedPass = md5($pass);
    $loginInfo = $con->query("CALL login_check('$user', '$encyptedPass')") or die($con->error);

    if($row = $loginInfo->fetch_assoc()) {
      $this->loggedID = SELF::$id = $row['loginid'];
      return $this->loggedID;

    } else {
      global $errors;
      $errors['incorrectLogin'] = '*** invalid username or password ***';
  }}
}

class NewSessionClass extends LoginUser {
    
  public function __construct() {
    $sessionid = $_SESSION['sessionid'] = session_id();
    $this->newSessionInDB($sessionid);
  }

  public function newSessionInDB($sessval) {
    $idval = PARENT::$id;
    global $con; moreResCheck($con);
    $sql = "CALL session_insert($idval, '$sessval')";
    $result = $con->query($sql);
    return $con->affected_rows ? $con->affected_rows : 0;
  }
}

class ClearPrevLogin extends LoginUser {

  public function __construct() {
    $idval = PARENT::$id;
    global $con; moreResCheck($con);
    $sql = "CALL logout_clear_prev($idval)";
    $con->query($sql);
  }
}

?>
