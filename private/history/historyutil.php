<?php

class HistoryClass {
  public $id;
  
  public function __construct($param) {
    $this->id = $param;
  }
  
  public function getOrderList($idval) {
    global $con; moreResCheck($con);
    $sql = "CALL history_load($idval)";
    $result = $con->query($sql);

    if($result->num_rows) {
      while($row = $result->fetch_assoc()) {
        $this->displayOrderHistory($row);
      }
    } else $this->noOrderHistory();
  }

  public function displayOrderHistory($array) {
    echo '<tr>
      <td class="pl-4 align-middle">' . $array["ordernum"] . '</td>
      <td class="align-middle">' . $array["invnum"] . '</td>
      <td class="align-middle">' . $array["date"] . '</td>
      <td class="align-middle">$' . number_format($array["total"], 2) . '</td>
    </tr>';
  }

  public function noOrderHistory() {
    echo '<tr>
      <td class="pl-4">--</td>
      <td>--</td>
      <td>--</td>
      <td>--</td>
    </tr>';
  }

}

?>