<?php
$errors = [];
$loggedID = '';

$provinces = [];
if(empty($provinces)) {
  global $con; //$con->next_result();
  $prov_result = $con->query("CALL provinces_load()");
  while($row = $prov_result->fetch_assoc()) {
    $provinces[$row['display']] = $row['shortval'];
}}

$countries = [];
if(empty($countries)) {
  global $con; $con->next_result();
  $ctry_result = $con->query("CALL countries_load()");
  while($row = $ctry_result->fetch_assoc()) {
    $countries[$row['display']] = $row['shortval'];
}}

$phonetype = [];
if(empty($phonetype)) {
  global $con; $con->next_result();
  $ptype_res = $con->query("CALL phonetype_load()");
  while($row = $ptype_res->fetch_assoc()) {
    $phonetype[$row['display']] = $row['shortval'];
}}

$securityquestions = [];
if(empty($securityquestions)) {
  global $con; $con->next_result();
  $question_res = $con->query("CALL securityquestions_load()");
  while($row = $question_res->fetch_assoc()) {
    $securityquestions[$row['question']] = $row['id'];
}}

?>
