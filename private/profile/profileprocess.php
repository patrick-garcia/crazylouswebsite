<?php
session_id();
include_once 'data/dbfile.php';
include_once 'profileutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';

if(!isset($_SESSION['loggedID'])) {
  exit(header("location: index.php"));
  ob_end_flush();

} else {
  $edtTgl = ['name' => 0, 'pass' => 0, 'adrs' => 0, 'phone' => 0, 'question' => 0];
  !isset($profile) ? $profile = new ProfileClass($_SESSION['loggedID']) : NULL;
  $loadprofile = new LoadProfile($_SESSION['loggedID']);
}

// edit name & email
if(isset($_POST['edit_name']) && $edtTgl['name'] == 0) {
  $edtTgl['name'] = 1;
}

if(isset($_POST['save_name'])) {
  $profile->fname = $_POST['firstname']; validInput($profile->fname, 'firstname');
  $profile->lname = $_POST['lastname']; validInput($profile->lname, 'lastname');
  $profile->email = $_POST['email']; validInput($profile->email, 'email');

  if(count($errors) > 0) {
    $edtTgl['name'] = 1;

  } else {
    $edtTgl['name'] = 0;
    $profile->saveName($profile->fname, $profile->lname, $profile->email);
    $_SESSION['message'] = 'your user info has been updated ';
    exit(header("location: profile.php"));
    ob_end_flush();
}}

// edit password
if(isset($_POST['change_pass']) && $edtTgl['pass'] == 0) {
  $edtTgl['pass'] = 1;
}

if(isset($_POST['save_pass'])) {
  !isset($passObj) ? $passObj = new PasswordClass($_SESSION['loggedID']) : NULL;
  $passObj->password = $_POST['pass1']; validInput($passObj->password, 'pass1');
  $passObj->confirmPass = $_POST['pass2']; validInput($passObj->confirmPass, 'pass2');
  validPassword($passObj->password, $passObj->confirmPass, 'passCheck');

  if(count($errors) > 0) {
    $edtTgl['pass'] = 1;
    
  } else {
    $edtTgl['pass'] = 0;
    $passObj->savePass($passObj->password);
    $_SESSION['message'] = 'your password has been updated ';
    exit(header("location: profile.php"));
    ob_end_flush();
}}

// edit address
if(isset($_POST['edit_adrs']) && $edtTgl['adrs'] == 0) {
  $edtTgl['adrs'] = 1;
}

if(isset($_POST['save_adrs'])) {
  !isset($adrs) ? $adrs = new AddressClass($_SESSION['loggedID']) : NULL;
  $adrs->adrs = $_POST['address']; validInput($adrs->adrs, 'address');
  $adrs->ste = $_POST['suite']; // optional input, no validation required
  $adrs->city = $_POST['city']; validInput($adrs->city, 'city');
  $adrs->prov = $_POST['province'];
  $adrs->post = $_POST['postal']; validInput($adrs->post, 'postal');
  $adrs->ctry = $_POST['country'];
  
  if(count($errors) > 0) {
    $edtTgl['adrs'] = 1;
  
  } else {
    $adrs->saveAddress($adrs->adrs, $adrs->ste, $adrs->city, $adrs->post, $adres->prov, $adrs->ctry);
    $edtTgl['adrs'] = 0;
    $_SESSION['message'] = 'your address has been updated ';
    exit(header("location: profile.php"));
    ob_end_flush();
}}

// **** delete ****
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
  !isset($phone) ? $phone = new PhoneClass($_SESSION['loggedID']) : NULL;
  
  $phone->num1 = $_POST['phoneinput1'];
  validInput($phone->num1, 'phoneinput1');
  lenInputCheck($phone->num1, 10, 'phonenum1Len');
  $phone->ext1 = $_POST['ext1'];
  $phone->ptype1 = $_POST['phonetype1'];
  $phone->phId1 = $_POST['phoneid1'];
  
  if(isset($_POST['phoneid2'])) {
    $phone->num2 = $_POST['phoneinput2'];
    validInput($phone->num2, 'phoneinput2');
    lenInputCheck($phone->num2, 10, 'phonenum2Len');
    $phone->ext2 = $_POST['ext2'];
    $phone->ptype2 = $_POST['phonetype2'];
    $phone->phId2 = $_POST['phoneid2'];
  }

  if(count($errors) > 0) {
    $edtTgl['phone'] = 1;

  } else {
    $phone->savePhone($phone->phId1, $phone->num1, $phone->ext1, $phone->ptype1);

    if(isset($_POST['phoneid2'])) {
      $phone->savePhone($phone->phId2, $phone->num2, $phone->ext2, $phone->ptype2);   
    }

    $edtTgl['phone'] = 0;
    $_SESSION['message'] = 'your phone info has been updated ';
    exit(header("location: profile.php"));
    ob_end_flush();
}}

// edit security question
if(isset($_POST['edit_question']) && $edtTgl['question'] == 0) {
  $edtTgl['question'] = 1;
}

if(isset($_POST['save_question'])) {
  !isset($secQuestion) ? $secQuestion = new SecurityQuestionClass($_SESSION['loggedID']) : NULL;
  $secQuestion->question = $_POST['securityquestion'];
  $secQuestion->answer = $_POST['securityanswer']; validInput($secQuestion->answer, 'securityanswer');
  
  if(count($errors) > 0) {
    $edtTgl['question'] = 1;

  } else {
    $secQuestion->saveQuestion($secQuestion->question, $secQuestion->answer);
    $edtTgl['question'] = 0;
    $_SESSION['message'] = 'your security has been updated ';
    exit(header("location: profile.php"));
    ob_end_flush();
}}

// load functions
function displayEditBtn($attr, $text) {
  return '<button type="submit" class="btn btn-primary profile-edit-btn" name="' . $attr . '">' . $text . '</button>';
}

function displayEditBtnToggle($editVal, $attr1, $text1, $attr2, $text2) {
  if(!$editVal) {
    return '<button type="submit" class="btn btn-primary profile-edit-btn" name="' . $attr1 . '">' . $text1 . '</button>';
  } else {
    return '<button type="submit" class="btn btn-success profile-edit-btn" name="' . $attr2 . '">' . $text2 . '</button>';
}}


?>