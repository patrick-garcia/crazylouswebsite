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
  !isset($catval) ? $catval = 6 : $catval;
  !isset($sortby) ? $sortby = 'album' : $sortby;
  !isset($_SESSION['orderalbumID']) ? $_SESSION['orderalbumID'] = [] : NULL;
}

if(isset($_POST['sortsubmit'])) {
  $catval = $_POST['category'];
  $sortby = $_POST['sortby'];
}

if(isset($_GET['getalbumID'])) {
  addAlbumId($_GET['getalbumID']);
}

if(isset($_GET['clearcart'])) {
  clearCart();
}

function albumOrArtist($sortOption) {
  return $sortOption == 'album' ? "albumname" : "artistgroupname";
};

// call is catid equals 6
function showAllCategory($sortOptVal) {
  $val = albumOrArtist($sortOptVal);
  return "SELECT * FROM album, artistgroup WHERE album.artistgroupid = artistgroup.artistgroupid ORDER BY " . $val . " ASC";

  // return "CALL album_load_all('" . $val . "')";
  // $val to sort based on album or artist not working
}

function showSelectedCat($sortOptVal, $catIdVal) {
  $val = albumOrArtist($sortOptVal);
  return 'SELECT * FROM album, albumcreation, category, artistgroup WHERE album.artistgroupid = artistgroup.artistgroupid AND album.albumid = albumcreation.albumid AND albumcreation.categoryid = category.categoryid AND category.categoryid = ' . $catIdVal . ' ORDER BY ' . $val . ' ASC';
  
  // return "CALL album_load_by_catid('" . $val . "', " . $catIdVal . ")";
  // $val to sort based on album or artist not working
}

function addAlbumId($id) {
  if(!in_array($id, $_SESSION['orderalbumID'])) {
    $_SESSION['orderalbumID'][] = $id;
}}

function cartShow() {
  if(!isset($_SESSION['orderalbumID']) || count($_SESSION['orderalbumID']) < 1) {
    return 'style="display: none;"';
}}

?>
