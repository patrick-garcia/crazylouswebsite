<?php

function moreResCheck($conVal) {
  $conVal->more_results() ? $conVal->next_result() : NULL;
}

 // error checks
function validInput($input, $inputField) {
  global $errors;
  $input = trim($input);
  if(empty($input)) {
    $errors[$inputField] = "* required field";
}}

function validPassword($pass1, $pass2, $inputField) {
  global $errors;
  if($pass1 != $pass2) {
    $errors[$inputField] = '*** passwords do not match ***';
}}

function lenInputCheck($input, $length, $inputField) {
  global $errors;
  if(strlen($input) != $length) {
    $errors[$inputField] = $length . " character minimum";
}}

function errorIssetCheck($errorName) {
  global $errors;
  return (isset($errors[$errorName])) ? '<p class="text-danger small">' . $errors[$errorName] . '</p>' : '';
}

function readonly($toggleVal) {
  return (!$toggleVal) ? 'readonly' : ''; 
}

function successMsg() {
  if(isset($_SESSION['message']) && $_SESSION['message'] != '') {
    $msg = $_SESSION['message'];
    unset($_SESSION['message']);
    return '<div class="text-center alert alert-success happy-font-awesome" role="alert">' . $msg . '</div>';
}}

function errorMsg() {
  if(isset($_SESSION['message']) && $_SESSION['message'] != '') {
    $msg = $_SESSION['message'];
    unset($_SESSION['message']);
    return '<div class="text-center alert alert-danger frown-font-awesome" role="alert">' . $msg . '</div>';
}}

function disableBtn($array) {
  return empty($array) ? 'disabled' : '';
}

function clearCart() {
  unset($_SESSION['orderalbumID']);
  $_SESSION['orderalbumID'] = [];
  unset($_SESSION['orderDetails']);
  unset($_SESSION['payTotals']);
}

function pre_r($array) {
  echo '<pre style="font-size: 12px;">';
  print_r($array);
  echo '</pre>';
}

function provinces_load() {
  global $con; $con->next_result();
  $provinces = $con->query("CALL provinces_load()") or die($con->error);
  return $provinces;
}

function countries_load() {
  global $con; $con->next_result();
  $countries = $con->query("CALL countries_load()") or die($con->error);
  return $countries;
}

function phonetype_load() {
  global $con; $con->next_result();
  $phonetype = $con->query("CALL phonetype_load()") or die($con->error);
  return $phonetype;
}

?>