<?php
(!isset($_SESSION)) ? session_start() : NULL;
include_once 'dbfile.php';
include_once 'variables.php';
include_once 'functions.php';

if(!isset($_SESSION['loggedID'])) {
  exit(header("location: index.php"));
  ob_end_flush();

} else {
  $id = $_SESSION['loggedID'];
}

function displayOrderHistory($fetchArr) {
  echo '<tr>
    <td class="pl-4">' . $fetchArr["ordernum"] . '</td>
    <td>' . $fetchArr["invnum"] . '</td>
    <td>' . $fetchArr["date"] . '</td>
    <td>$' . number_format($fetchArr["total"], 2) . '</td>
  </tr>';
}

function noOrderHistory() {
  echo '<tr>
    <td class="pl-4">--</td>
    <td>--</td>
    <td>--</td>
    <td>--</td>
  </tr>';
}

?>