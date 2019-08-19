<?php
(!isset($_SESSION)) ? session_start() : NULL;
include_once 'data/dbfile.php';
include_once 'historyutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';


if(!isset($_SESSION['loggedID'])) {
  exit(header("location: index.php"));
  ob_end_flush();

} else {
  !isset($hist) ? $hist = new HistoryClass($_SESSION['loggedID']) : NULL;
  $hist->id = $_SESSION['loggedID'];
}

// load function
function showHeading() {
  $heading = ['order ref #', 'invoice #', 'date', 'total'];
  foreach ($heading as $key => $val) echo '<th>' . $val . '</th>';
}

?>