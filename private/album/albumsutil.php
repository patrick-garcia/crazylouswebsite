<?php

class CategoryClass {
  public $catval = 6;
  public $sortby = 'album';
  public $categoryList = [];

  public function __construct() {
    $this->categoryList = $this->getCategoryList();
  }

  private function getCategoryList() {
    global $con; moreResCheck($con);
    $sql = "CALL category_load()";
    $result = $con->query($sql) or die($con->error);
    $array = [];
    while($item = $result->fetch_assoc()) $array[] = $item;
    return $array;
  }
}

class DisplayAlbumsClass {
  public $catval = 6;
  public $sortby = 'albumname';
  public $albumsDisplayArr = [];
    
  public function __construct($catval, $sortby) {
    $this->catval = $catval;
    $this->sortby = $sortby;
    if($catval == 6) {
      $this->albumsDisplayArr = $this->showAllCategory($sortby);
    
    } else {
      $this->albumsDisplayArr = $this->showSelectedCat($catval, $sortby);
    }
  }

  public function showAllCategory($sortby) {
    global $con; moreResCheck($con);
    // $sql = "CALL album_load_all('$sortby')"; //using sql procedure does not sort correctly ???
    $sql = "SELECT * FROM album, artistgroup
      WHERE album.artistgroupid = artistgroup.artistgroupid
      ORDER BY " . $sortby . " ASC";
    $result = $con->query($sql) or die($con->error);
    $array = [];
    while($item = $result->fetch_assoc()) $array[] = $item;
    return $array;
  }

  public function showSelectedCat($catval, $sortby) {
    global $con; moreResCheck($con);
    // $sql = "CALL album_load_by_catid('$catval', '$sortby')"; //using sql procedure does not sort correctly ???
    $sql = 'SELECT * FROM album, albumcreation, category, artistgroup
      WHERE album.artistgroupid = artistgroup.artistgroupid
      AND album.albumid = albumcreation.albumid
      AND albumcreation.categoryid = category.categoryid
      AND category.categoryid = ' . $catval . ' ORDER BY ' . $sortby . ' ASC';
    $result = $con->query($sql) or die($con->error);
    $array =  [];
    while($item = $result->fetch_assoc()) $array[] = $item;
    return $array;
  }
}

class TracklistClass {
  public $tracklistArr;
    
  public function __construct($tracklistid) {
    $this->tracklistArr = $this->loadTracklist($tracklistid);
  }
  
  public function loadTracklist($tracklistid) {
    global $con; moreResCheck($con);
    $sql = "CALL album_get_tracks($tracklistid)";
    $result = $con->query($sql);
    $array = [];
    while($item = $result->fetch_assoc()) $array[] = $item;
    return $array;
  }
}

class CartClass {
  static function addAlbumId($albumid) {
    if(!in_array($albumid, $_SESSION['orderalbumID'])) {
        $_SESSION['orderalbumID'][] = $albumid;
    }
  }

  static function clearCart() {
    unset($_SESSION['orderalbumID']);
    $_SESSION['orderalbumID'] = [];
    unset($_SESSION['orderDetails']);
    unset($_SESSION['payTotals']);
  }
}


?>