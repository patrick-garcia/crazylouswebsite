<?php
!isset($_SESSION) ? session_start() : NULL;
include_once 'dbfile.php';
include_once 'variables.php';
include_once 'functions.php';
  
!isset($ordercomplete) ? $ordercomplete = [] : NULL;

if(isset($_SESSION['orderLastId'])) {
  $lastorderid = $_SESSION['orderLastId'];
  getInfoFromOrders($lastorderid);
  getInfoFromOrderpayment($lastorderid);

  unset($_SESSION['orderLastId']);
  clearCart();

} else {
  exit(header("location: history.php"));
  ob_end_flush();
}

function getInfoFromOrders($idval) {
  global $con, $ordercomplete;
  $con->next_result();
  $sql = "CALL ordcomplete_get_order_info($idval)";
  $result = $con->query($sql)->fetch_assoc();
  $ordercomplete['order_ref'] = $result['id'];
  $ordercomplete['date'] = $result['date'];
}

function getInfoFromOrderpayment($idval) {
  global $con, $ordercomplete;
  $con->next_result();
  $sql = "CALL ordcomplete_get_pay_info($idval)";
  $result = $con->query($sql)->fetch_assoc();
  $ordercomplete['invoice_ref'] = $result['id'];
  $ordercomplete['total'] = $result['total'];
}

?>