<?php

class LoadDiscussionPost {
  static public $postArray = [];
    
  public function __construct() {
    SELF::$postArray = $this->loadPosts();
  }
  
  private function loadPosts() {
    global $con; moreResCheck($con);
    $sql = "CALL usermanage_load_discussion()";
    $array = [];
    $result = $con->query($sql) or die($con->error);
    while($item = $result->fetch_assoc()) {
      array_push($array, $item);
    }
    return $array;
  }
}


?>