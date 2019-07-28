<?php

class loginUser {
  public $user;
  public $pass;

  public function getloginID($user, $pass) {
    global $con; moreResCheck($con);
    $loginInfo = $con->query("CALL login_check('$user', '$pass')") or die($con->error);

    if ($row = $loginInfo->fetch_assoc()) {
      return $row['loginid'];

    } else {
      global $errors;
      $errors['incorrectLogin'] = '*** invalid username or password ***';
  }}

  public function clearPrevLogin($loggedID) {
    global $con;
    moreResCheck($con);
    $con->query("CALL logout_clear_prev($loggedID)");
  }

  public function newSession($id, $sessval) {
    global $con;
    moreResCheck($con);
    $sql = "CALL session_insert($id, '$sessval')";
    $result = $con->query($sql);

    return $con->affected_rows ? $con->affected_rows : 0;
  }
}

?>