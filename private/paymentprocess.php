<?php
!isset($_SESSION) ? session_start() : NULL;
include_once 'dbfile.php';
include_once 'variables.php';
include_once 'functions.php';

if(!isset($_SESSION['loggedID'])) {
  exit(header("location: index.php"));
  ob_end_flush();
  
} else {
  isset($_SESSION['payTotals']) ? $payTotals = $_SESSION['payTotals'] : $payTotals = [];
  isset($_SESSION['orderDetails']) ? $orderDetails = $_SESSION['orderDetails'] : $orderDetails = [];
  $cc = [];
  $shipto = [];

  if(empty($orderDetails) || empty($payTotals)) {
    $_SESSION['message'] = 'order incomplete, please go back to order section ';
  }
}

if(isset($_POST['confirmOrder'])) {
  $cc['name'] = $_POST['cardname']; validInput($cc['name'], 'cardname');
  $cc['num'] = $_POST['cardnum']; validInput($cc['num'], 'cardnum');
  $cc['type'] = $_POST['cardtype'];
  $cc['month'] = $_POST['cardmonth'];
  $cc['year'] = $_POST['cardyear'];
  $cc['csv'] = $_POST['csv']; validInput($cc['csv'], 'csv');

  $shipto['adrs'] = $_POST['ship-adrs']; validInput($shipto['adrs'], 'ship-adrs');
  $shipto['ste'] = $_POST['ship-ste'];
  $shipto['city'] = $_POST['ship-city']; validInput($shipto['city'], 'ship-city');
  $shipto['prov'] = $_POST['ship-prov'];
  $shipto['post'] = $_POST['ship-post']; validInput($shipto['post'], 'ship-post');
  $shipto['ctry'] = $_POST['ship-ctry'];

  if(count($errors) < 1) {
    $custid = $_SESSION['loggedID'];
    $lastid = $_SESSION['orderLastId'] = orderInsert($custid);

    if($lastid > 0) {
      foreach($orderDetails as $key => $val) {
        orderDetailsInsert($lastid, $key);
      }
      creditcardInsert($lastid);
      shipAddressInsert($lastid);
      
      exit(header("location: ordercomplete.php"));
      ob_end_flush();
    }
}}

function getLastOrderId($idval) {
  global $con; $con->next_result();
  $sql = "CALL order_get_lastid($idval)";
  $result = $con->query($sql)->fetch_assoc();
  return $result['lastid'];
}

function orderInsert($custid) {
  global $con; $con->next_result();
  $sql = "CALL order_insert($custid)";
  return $con->query($sql) ? getLastOrderId($custid) : 0;
}

function orderDetailsInsert($lastid, $index) {
  global $orderDetails;
  $albumid = $orderDetails[$index]['albumid'];
  $price = $orderDetails[$index]['price'];
  $qty = $orderDetails[$index]['qty'];

  global $con; $con->next_result();
  $sql = "CALL orderdetails_insert($lastid, $albumid, $price, $qty)";
  $con->query($sql);
}

function creditcardInsert($lastid) {
  global $cc;
  $name = $cc['name'];
  $num = $cc['num'];
  $type = $cc['type'];
  $expiry = $cc['month'] . "/" . $cc['year'];
  $csv = $cc['csv'];

  $payTotals = $_SESSION['payTotals'];
  $subtotal = $payTotals['sub'];
  $tax = $payTotals['tax'];
  $total = $payTotals['total'];

  global $con; $con->next_result();
  $sql = "CALL ordercc_insert('$name', $num, '$type', '$expiry', $csv, $subtotal, $tax, $total, $lastid)";
  $con->query($sql);
}

function shipAddressInsert($lastid) {
  global $shipto;
  $adrs = $shipto['adrs']; $ste = $shipto['ste'];
  $city = $shipto['city']; $prov = $shipto['prov'];
  $post = $shipto['post']; $ctry = $shipto['ctry'];

  global $con; $con->next_result();
  $sql = "CALL ordershipto_insert('$adrs', '$ste', '$city', '$prov', '$post', '$ctry', $lastid)";
  $con->query($sql);
}

function cardmonthLoad() {
  $months = array('jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec');
  foreach($months as $mon) {
    echo '<option value="' . $mon . '">' . strtoupper($mon) . '</option>';
}}

function cardyearLoad($y = 5) {
  $year = date("Y");
  $yrsForward = $year + $y;
  while($year <= $yrsForward) {
    echo '<option value="' . $year . '">' . $year . '</option>';
    $year++;
}}

// ****
$creditcard = [];
if(empty($creditcard)) {
  global $con; $con->next_result();
  $cards_result = $con->query("CALL creditcard_load()");
  while($cards_row = $cards_result->fetch_assoc()) {
    $creditcard[] = $cards_row['name'];
}}

function cardsOptions() {
  global $creditcard;
  foreach($creditcard as $card) echo '<option value="' . $card . '">' . strtoupper($card) . '</option>';
}

function payTotalsCheck($val) {
  global $payTotals;
  return !empty($payTotals) ? number_format($payTotals[$val], 2) : '0.00';
}

?>