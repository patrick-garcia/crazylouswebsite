<?php 

class CustomerList {
  static public $customerListArray;
    
  public function __construct() {
    SELF::$customerListArray = $this->getAllCustomers();
  }

  public function getAllCustomers() {
    global $con; moreResCheck($con);
    $sql = "CALL usermanage_get_all_customers()";
    $result = $con->query($sql);
    $array = [];

    while($item = $result->fetch_assoc()) {
      $array[] = $item;
    }
    return $array;
  }
}

class AdminCheck {
  static public $adminVal;

  static public function userAdminCheck($id) {
    global $con; moreResCheck($con);
    $sql = "CALL usermanage_admin_check($id)";
    $result = $con->query($sql)->fetch_assoc();
    SELF::$adminVal = $result['admin'];
  }
}

?>