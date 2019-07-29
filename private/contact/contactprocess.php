<?php
  include_once 'data/siteinfo.php';

  function openNewTab($index) {
    return $index == 'My Website' ? 'target="_blank"' : NULL;
  }

?>