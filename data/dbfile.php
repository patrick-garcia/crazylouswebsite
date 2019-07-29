<?php
  $host = "localhost";
  $user = "root";
  $pass = "root";
  // $db = "CrazyLouGarcia";
  $db = "php_project3";
  $con = new mysqli($host, $user, $pass, $db) or die(mysqli_error($con));
?>