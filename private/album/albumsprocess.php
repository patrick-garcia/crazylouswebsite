<?php
!isset($_SESSION) ? session_start() : NULL;
include_once 'data/dbfile.php';
include_once 'albumsutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';

if(!isset($_SESSION['loggedID'])) {
  exit(header("location: index.php"));
  ob_end_flush();

} else {
  // default settings, 6 equals all category
  $category = new CategoryClass();
  !isset($catval) ? $catval = 6 : '';
  !isset($sortby) ? $sortby = 'albumname' : '';
  !isset($_SESSION['orderalbumID']) ? $_SESSION['orderalbumID'] = [] : NULL;
}

if(isset($_POST['category']) || isset($_POST['sortby'])) {
  $showAlbum = new DisplayAlbumsClass($_POST['category'], $_POST['sortby']);
  $catval = $showAlbum->catval;
  $sortby = $showAlbum->sortby;
  
} else {
  $showAlbum = new DisplayAlbumsClass(6, 'albumname');
  $catval = $showAlbum->catval;
  $sortby = $showAlbum->sortby;
}

if(isset($_GET['getalbumID'])) {
  CartClass::addAlbumId($_GET['getalbumID']);
}

if(isset($_GET['clearcart'])) {
  CartClass::clearCart();
}

// load show cart if necessary
function cartShow() {
  if(!isset($_SESSION['orderalbumID']) || count($_SESSION['orderalbumID']) < 1) {
    return 'style="display: none;"';
}}


?>
