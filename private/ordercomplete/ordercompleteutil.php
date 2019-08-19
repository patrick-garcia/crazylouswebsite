<?php

class OrderCompleteClass {
  public $lastorderID;
  static public $orderdetails = [];
  private $headings = [
    'tstamp' => 'order date',
    'order_ref' => 'reference #',
    'invoice_ref' => 'invoice #',
    'total' => 'order total'
  ];
  static public $html;
    
  public function __construct($orderid) {
    $this->getInfoFromOrders($orderid);
    $this->getInfoFromOrderpayment($orderid);
    SELF::$html = $this->convert2String();
  }

  private function getInfoFromOrders($idval) {
    global $con; moreResCheck($con);
    $sql = "CALL ordcomplete_get_order_info($idval)";
    $result = $con->query($sql)->fetch_assoc();
    SELF::$orderdetails['order_ref'] = $result['id'];
    SELF::$orderdetails['date'] = $result['date'];
    SELF::$orderdetails['tstamp'] = $result['tstamp'];
  }

  private function getInfoFromOrderpayment($idval) {
    global $con; moreResCheck($con);
    $sql = "CALL ordcomplete_get_pay_info($idval)";
    $result = $con->query($sql)->fetch_assoc();
    SELF::$orderdetails['invoice_ref'] = $result['id'];
    SELF::$orderdetails['total'] = $result['total'];
  }

  private function convert2String() {
    $string = '';
    foreach($this->headings as $key => $val) {
      $string .= '<ul class="d-flex mb-2 p-0"><li class="text-right mr-3">';
      $string .= $val . ':';
      $string .= '</li><li class="text-left">';
      $string .= $this->htmlConvertCheck($key);
      $string .= '</li></ul>';
    }
    return $string;
  }

  private function htmlConvertCheck($key) {
    if($key == 'tstamp') {
      return date("M j, Y", strtotime(SELF::$orderdetails[$key]));

    } elseif ($key == 'total') {
      return '$' . SELF::$orderdetails[$key];
    
    } else {
      return SELF::$orderdetails[$key];
    }
  }
 
}

?>