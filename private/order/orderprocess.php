<?php
!isset($_SESSION) ? session_start() : NULL;
include_once 'data/dbfile.php';
include_once 'orderutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';


if(!isset($_SESSION['loggedID'])) {
  exit(header("location: index.php"));
  ob_end_flush();

} else {
  if(!empty($_SESSION['orderalbumID'])) {
    !isset($odr) ? $odr = new OrderClass($_SESSION['orderalbumID']) : '';

  } else {
    $_SESSION['message'] = 'no album selected, please go back to album section ';
  }  
}

if(isset($_POST['placeorder'])) {
  !is_array($_POST['itemqty']) ? $odr->orderQtys = explode(',', $_POST['itemqty']) : $odr->orderQtys = $_POST['itemqty'];
  
  $odr->addQtyToOrder($odr->order);
  
  $_SESSION['orderDetails'] = $odr->order;
  $odr->getTotals($_POST['totals']);

  exit(header("location: payment.php"));
  ob_end_flush();
}

// load function
function qty_load($max = 10) {
  $count = 1;
  while($count <= $max) {
    echo '<option value="' . $count . '">' . $count . '</option>';
    $count++;
}}

?>
