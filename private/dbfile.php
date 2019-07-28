<?php
  $host = "localhost";
  $user = "root";
  $pass = "root";
  // $db = "CrazyLouGarcia";
  $db = "db_test2";
  $con = new mysqli($host, $user, $pass, $db) or die(mysqli_error($con));
?>