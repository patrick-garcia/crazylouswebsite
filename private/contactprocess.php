<?php
include_once 'siteinfo.php';

function openNewTab($index) {
  return $index == 'My Website' ? 'target="_blank"' : NULL;
}

?>