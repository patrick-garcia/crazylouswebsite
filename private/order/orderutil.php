<?php

class OrderClass {
  public $selectedAlbumID;
  public $startSubTotal = 0;
  public $order = [];
  public $orderQtys;
  public $totalsArray = [];
  public $totalsArrayNames = ['sub', 'tax', 'total'];
    
  public function __construct($param) {
    $this->selectedAlbumID = $param;
    $this->addAlbumidToOrder($this->selectedAlbumID);
  }
  
  public function addAlbumidToOrder($albumIDArray) {
    foreach($albumIDArray as $key => $val) {
      global $con; moreResCheck($con);
      $result = $con->query("CALL album_get_price($val)")->fetch_assoc();
      $this->order[] = $result;
  }}

  public function addQtyToOrder($orderArray) {
    foreach($this->order as $key => $val) {
      $this->order[$key]['qty'] = $this->orderQtys[$key];
    }
  }

  public function getTotals($input) {
    if(!is_array($input)) {
      $newArray = explode(',', $input);
      $this->createTotalsArray($newArray);

    } else $this->createTotalsArray($input);

    $_SESSION['payTotals'] = $this->totalsArray;
  }

  public function createTotalsArray($array) {
    foreach($array as $key => $val) {
      $this->totalsArray[$this->totalsArrayNames[$key]] = $val;
    }
  }

}

?>