<?php
session_id();
include_once 'dbfile.php';
include_once 'variables.php';
include_once 'functions.php';

$edtTgl = ['name' => 0, 'pass' => 0, 'adrs' => 0, 'phone' => 0];
!isset($prf) ? $prf = [] : $prf;

if(!isset($_SESSION['loggedID'])) {
  exit(header("location: index.php"));
  ob_end_flush();

} else {
  $id = $_SESSION['loggedID'];
}

// edit name & email
if(isset($_POST['edit_name']) && $edtTgl['name'] == 0) {
  $edtTgl['name'] = 1;
}

if(isset($_POST['save_name'])) {
  $prf['fname'] = $_POST['firstname']; validInput($prf['fname'], 'firstname');
  $prf['lname'] = $_POST['lastname']; validInput($prf['lname'], 'lastname');
  $prf['email'] = $_POST['email']; validInput($prf['email'], 'email');
  
  if(count($errors) > 0) {
    $edtTgl['name'] = 1;
  } else {
    saveName($prf['fname'], $prf['lname'], $prf['email'], $id);
    $edtTgl['name'] = 0;
    $_SESSION['message'] = 'your user info has been updated ';
    exit(header("location: profile.php"));
    ob_end_flush();
}}

function saveName($fn, $ln, $email, $idval) {
  global $con; $con->next_result();
  $con->query("CALL profile_update_name('$fn', '$ln', '$email', $idval)");
}

// edit password
if(isset($_POST['change_pass']) && $edtTgl['pass'] == 0) {
  $edtTgl['pass'] = 1;
}

if(isset($_POST['save_pass'])) {
  $prf['pass'] = $_POST['pass1']; validInput($prf['pass'], 'pass1');
  $prf['confirmPass'] = $_POST['pass2']; validInput($prf['confirmPass'], 'pass2');
  validPassword($prf['pass'], $prf['pass'], 'passCheck');

  if(count($errors) > 0) {
    $edtTgl['pass'] = 1;
  } else {
    $prf['pass'] = md5($prf['pass']); // encrypt pass
    savePass($prf['pass'], $id);
    $edtTgl['pass'] = 0;
    $_SESSION['message'] = 'your password has been updated ';
    exit(header("location: profile.php"));
    ob_end_flush();
}}

function savePass($pass, $idval) {
  global $con; $con->next_result();
  $con->query("CALL profile_update_pass('$pass', $idval)");
}

// edit address
if(isset($_POST['edit_adrs']) && $edtTgl['adrs'] == 0) {
  $edtTgl['adrs'] = 1;
}

if(isset($_POST['save_adrs'])) {
  $prf['adrs'] = $_POST['address']; validInput($prf['adrs'], 'address');
  $prf['ste'] = $_POST['suite']; // optional input, no validation required
  $prf['city'] = $_POST['city']; validInput($prf['city'], 'city');
  $prf['prov'] = $_POST['province'];
  $prf['post'] = $_POST['postal']; validInput($prf['post'], 'postal');
  $prf['ctry'] = $_POST['country'];
  
  if(count($errors) > 0) {
    $edtTgl['adrs'] = 1;
  } else {
    saveAddress($id, $prf['adrs'], $prf['ste'], $prf['city'], $prf['post'], $prf['prov'], $prf['ctry']);
    $edtTgl['adrs'] = 0;
    $_SESSION['message'] = 'your address has been updated ';
    exit(header("location: profile.php"));
    ob_end_flush();
}}

function saveAddress($idval, $adrs, $ste, $city, $post, $prov, $ctry) {
  global $con; $con->next_result();
  $con->query("CALL profile_update_address($idval, '$adrs', '$ste', '$city', '$post', '$prov', '$ctry')");
}

// edit phone
// **** not using loggedID, instead using phone id because the 2 phone nums have same customer id
if(isset($_POST['edit_phone']) && $edtTgl['phone'] == 0) {
  $edtTgl['phone'] = 1;
}

if(isset($_POST['save_phone'])) {
  $prf['num1'] = $_POST['phoneinput1'];
  validInput($prf['num1'], 'phoneinput1');
  lenInputCheck($prf['num1'], 10, 'phonenum1Len');
  $prf['ext1'] = $_POST['ext1'];
  $prf['ptype1'] = $_POST['phonetype1'];
  $prf['phId1'] = $_POST['phoneid1'];
  
  if(isset($_POST['phoneid2'])) {
    $prf['num2'] = $_POST['phoneinput2'];
    validInput($prf['num2'], 'phoneinput2');
    lenInputCheck($prf['num2'], 10, 'phonenum2Len');
    $prf['ext2'] = $_POST['ext2'];
    $prf['ptype2'] = $_POST['phonetype2'];
    $prf['phId2'] = $_POST['phoneid2'];
  }

  if(count($errors) > 0) {
    $edtTgl['phone'] = 1;

  } else {
    savePhone($prf['phId1'], $prf['num1'], $prf['ext1'], $prf['ptype1']);

    if(isset($_POST['phoneid2'])) {
      savePhone($prf['phId2'], $prf['num2'], $prf['ext2'], $prf['ptype2']);      
    }

    $edtTgl['phone'] = 0;
    $_SESSION['message'] = 'your phone info has been updated ';
    exit(header("location: profile.php"));
    ob_end_flush();
}}

function savePhone($idval, $num, $ext, $type) {
  global $con; $con->next_result();
  $con->query("CALL profile_update_phone($idval, '$num', '$ext', '$type')");
}

// toggle btn
function displayEditBtn($attr, $text) {
  return '<button type="submit" class="btn btn-primary edit-btn" name="' . $attr . '">' . $text . '</button>';
}

function displayEditBtnToggle($editVal, $attr1, $text1, $attr2, $text2) {
  if(!$editVal) {
    return '<button type="submit" class="btn btn-primary edit-btn" name="' . $attr1 . '">' . $text1 . '</button>';
  } else {
    return '<button type="submit" class="btn btn-success edit-btn" name="' . $attr2 . '">' . $text2 . '</button>';
}}

?>