<?php

class OrderSummaryClass {
  public $orderSummary;
  public $payTotals;
  
  public function __construct($orderSummary, $payTotals) {
    $this->payTotals = $payTotals;
    $this->orderSummary = $this->convertOrderSummaryToHTML($orderSummary);
    $this->payTotals = $this->convertPayTotalsToHTML($payTotals);
  }

  private function convertOrderSummaryToHTML($array) {
    $string = '';
    foreach($array as $key => $val) {
      $string .= '<tr class="text-center"><td>';
      $string .= ($key + 1) . ': "' . $val['album'] . '" ';
      $string .= 'by ' . $val['artist'] . ' ~ qty: ' . $val['qty'];
      $string .= '</td></tr>';
    }
    return $string;
  }

  private function convertPayTotalsToHTML($array) {
    $string = '<td>subtotal: $' . number_format($array['sub'], 2) . '</td>';
    $string .= '<td>tax: $' . number_format($array['tax'], 2) . '</td>';
    $string .= '<td>total: $' . number_format($array['total'], 2) . '</td>';
    return $string;
  }
}

class ShipAddressClass {
  static public $shipInfo;
  public $id;
    
  public function __construct($id) {
    $this->loadCustAddress($id);
  }
  
  private function loadCustAddress($id) {
    global $con; moreResCheck($con);
    $sql = "CALL payment_load_address($id)";
    $result = $con->query($sql)->fetch_assoc();
    SELF::$shipInfo = $result;
  }
}

class NewOrderClass {
  public $custid;
  public $orderid;
    
  public function __construct($id) {
    $this->custid = $id;
    $this->orderid = $this->newOrder($id);
  }

  private function newOrder($id) {
    global $con; moreResCheck($con);
    $sql = "CALL order_insert($id)";

    if($con->query($sql)) {
      moreResCheck($con);
      $sql = "CALL order_get_lastid($id)";
      $result = $con->query($sql)->fetch_assoc();
      return $result['lastid']; // yield orderID for follow up sql CALLs

    } else return 0;
  }
}

class NewOrderDetails {
  public $orderDetails;
  public $orderid;
  static public $rowCheck;

  public function __construct($array, $orderid) {
    $this->orderDetails = $array;
    $this->orderid = $orderid;
    $this->loopThruOrderDetails($this->orderDetails, $this->orderid);
  }

  public function loopThruOrderDetails($array, $orderid) {
    foreach($array as $key => $val) {
      $this->eachOrderDetailInsert($orderid, $key);
    }
  }

  public function eachOrderDetailInsert($lastid, $index) {
    $albumid = $this->orderDetails[$index]['albumid'];
    $price = $this->orderDetails[$index]['price'];
    $qty = $this->orderDetails[$index]['qty'];

    global $con; moreResCheck($con);
    $sql = "CALL orderdetails_insert($lastid, $albumid, $price, $qty)";
    $con->query($sql);
    SELF::$rowCheck = $con->affected_rows ? $con->affected_rows : 0;
  }
}

class NewCreditCardOrder {
  static public $rowCheck;

  public function __construct($payTotals, $name, $num, $type, $mon, $year, $csv,$orderid) {
    $this->creditcardInsert($payTotals, $name, $num, $type, $mon, $year, $csv,$orderid);
  }

  private function creditcardInsert($payTotals, $name, $num, $type, $mon, $year, $csv, $orderid) {

    $expiry = $mon . "/" . $year;
    $subtotal = $payTotals['sub'];
    $tax = $payTotals['tax'];
    $total = $payTotals['total'];

    global $con; moreResCheck($con);
    $sql = "CALL ordercc_insert('$name', $num, '$type', '$expiry', $csv, $subtotal, $tax, $total, $orderid)";
    $con->query($sql);
    SELF::$rowCheck = $con->affected_rows ? $con->affected_rows : 0;
    $_SESSION['test22'] = $con->affected_rows ? $con->affected_rows : 0;
  }
}

class NewShipToOrder {
  static public $rowCheck;

  public function __construct($adrs, $ste, $city, $prov, $post, $ctry, $orderid) {
    $this->shipAddressInsert($adrs, $ste, $city, $prov, $post, $ctry, $orderid);
  }

  private function shipAddressInsert($adrs, $ste, $city, $prov, $post, $ctry, $orderid) {
    global $con; moreResCheck($con);
    $sql = "CALL ordershipto_insert('$adrs', '$ste', '$city', '$prov', '$post', '$ctry', $orderid)";
    $con->query($sql);
    SELF::$rowCheck = $con->affected_rows ? $con->affected_rows : 0;
    $_SESSION['test33'] = $con->affected_rows ? $con->affected_rows : 0;
  }
}

class MessageClass {
  static public $incompleteMsg = '<td>order incomplete: please go back to order section</td>';
}

?>