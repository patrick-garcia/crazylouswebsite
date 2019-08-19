<?php
!isset($_SESSION) ? session_start() : NULL;
include_once 'data/dbfile.php';
include_once 'paymentutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';

if(!isset($_SESSION['loggedID'])) {
  exit(header("location: index.php"));
  ob_end_flush();
  
} else {
  new ShipAddressClass($_SESSION['loggedID']);

  if(!isset($_SESSION['orderDetails']) && !isset($_SESSION['payTotals'])) {
      $_SESSION['message'] = 'order incomplete, please go back to order section ';

  } else {
    $summary = new OrderSummaryClass($_SESSION['orderDetails'], $_SESSION['payTotals']);
  }
} 

if(isset($_POST['confirmOrder'])) {
  validInput($_POST['cardname'], 'cardname');
  validInput($_POST['cardnum'], 'cardnum');
  validInput($_POST['csv'], 'csv');

  validInput($_POST['ship-adrs'], 'ship-adrs');
  validInput($_POST['ship-city'], 'ship-city');
  validInput($_POST['ship-post'], 'ship-post');

  if(count($errors) < 1) {
    $newOrder = new NewOrderClass($_SESSION['loggedID']);

    if($newOrder->orderid > 0) {
      new NewOrderDetails($_SESSION['orderDetails'], $newOrder->orderid);
      
      new NewCreditCardOrder($_SESSION['payTotals'], $_POST['cardname'],
        $_POST['cardnum'], $_POST['cardtype'],
        $_POST['cardmonth'], $_POST['cardyear'],
        $_POST['csv'], $newOrder->orderid );
      
      new NewShipToOrder($_POST['ship-adrs'], $_POST['ship-ste'], 
        $_POST['ship-city'], $_POST['ship-prov'],
        $_POST['ship-post'], $_POST['ship-ctry'],
        $newOrder->orderid );

      if(
        NewOrderDetails::$rowCheck > 0 &&
        NewCreditCardOrder::$rowCheck > 0 &&
        NewShipToOrder::$rowCheck > 0
      ) {
        $_SESSION['orderLastId'] = $newOrder->orderid;
        exit(header("location: ordercomplete.php"));
        ob_end_flush();
      }
    }
  }
}


// load functions
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

$creditcard = [];
if(empty($creditcard)) {
  global $con; moreResCheck($con);
  $cards_result = $con->query("CALL creditcard_load()");
  while($cards_row = $cards_result->fetch_assoc()) {
    $creditcard[] = $cards_row['name'];
}}

function cardsOptions() {
  global $creditcard;
  foreach($creditcard as $card) echo '<option value="' . $card . '">' . strtoupper($card) . '</option>';
}


?>