<?php
!isset($_SESSION) ? session_start() : NULL;
include_once 'dbfile.php';
include_once 'variables.php';
include_once 'functions.php';

if(!isset($_SESSION['loggedID'])) {
  exit(header("location: index.php"));
  ob_end_flush();

} else {
  $order = [];
  if(!empty($_SESSION['orderalbumID'])) {
    $tempid = $_SESSION['orderalbumID'];

    foreach($tempid as $val) {
      global $con, $order;
      $con->next_result();
      $result = $con->query("CALL album_get_price($val)")->fetch_assoc();
      $order[] = $result;
    }
  } else {
    $_SESSION['message'] = 'no album selected, please go back to album section ';
  }  
}

if(isset($_POST['placeorder'])) {
  !is_array($_POST['itemqty']) ? $orderQtys = explode(',', $_POST['itemqty']) : $orderQtys = $_POST['itemqty'];
  
  foreach($order as $key => $val) {
    $order[$key]['qty'] = $orderQtys[$key];
  }
  
  $_SESSION['orderDetails'] = $order;
  getTotals($_POST['totals']);

  exit(header("location: payment.php"));
  ob_end_flush();
}

function qty_load($max = 10) {
  $count = 1;
  while($count <= $max) {
    echo '<option value="' . $count . '">' . $count . '</option>';
    $count++;
}}

function getTotals($input) {
  $totalsArray = [];
  $totalsArrayNames = ['sub', 'tax', 'total'];

  if(!is_array($input)) {
    $getArray = explode(',', $input);
    foreach($getArray as $key => $val) {
      $totalsArray[$totalsArrayNames[$key]] = $val;
  }} else {
    $getArray = $input;
    foreach($getArray as $key => $val) {
      $totalsArray[$totalsArrayNames[$key]] = $val;
  }}

  $_SESSION['payTotals'] = $totalsArray;
}

?>
