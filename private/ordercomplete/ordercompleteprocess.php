<?php
  !isset($_SESSION) ? session_start() : NULL;
  include_once 'data/dbfile.php';
  include_once 'data/siteinfo.php';
  include_once 'ordercompleteutil.php';
  include_once 'private/util/variables.php';
  include_once 'private/util/functions.php';
  
  
  if(isset($_SESSION['orderLastId'])) {
    !isset($ordercomplete) ? $ordercomplete = new OrderCompleteClass($_SESSION['orderLastId']) : NULL;

    new OrderCompleteClass($_SESSION['orderLastId']);

    unset($_SESSION['orderLastId']);
    clearCart();

  } else {
    exit(header("location: history.php"));
    ob_end_flush();
  }

?>