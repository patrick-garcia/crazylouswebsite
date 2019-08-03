<?php
  class blogClass {
    public $row = [];
    public $testVal = 'test val workaskdjfkaj';
    public $testVal2;
    public $sql = "CALL blogs_load_all()";

    public function loadBlogs() {
      global $con;
      moreResCheck($con);
      $sql = "CALL blogs_load_all()";
      $res = $con->query($sql) or die($con->error);
      $resArr = [];
      while ($item = $res->fetch_assoc()) {
        array_push($resArr, $item);
      }

      return $resArr;
    }


  }



?>