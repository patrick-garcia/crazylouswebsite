<?php 

class AdminCheckClass {
  static function adminCheck($id) {
    global $con; moreResCheck($con);
    $sql = "CALL admin_check($id)";
    $result = $con->query($sql)->fetch_assoc() or die($con);
    return $result['admin'];
  }

  static function expertCheck($id) {
    global $con; moreResCheck($con);
    $sql = "CALL admin_check($id)";
    $result = $con->query($sql)->fetch_assoc() or die($con);
    return $result['expert'];
  }
}

?>