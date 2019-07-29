<?php
!isset($_SESSION) ? session_start() : NULL;
include_once 'data/dbfile.php';
include_once 'createutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';

!isset($reg) ? $reg = [] : '';

if(isset($_POST['register'])) {
  $reg['fname'] = $_POST['firstname']; $reg['lname'] = $_POST['lastname'];
  $reg['email'] = $_POST['email'];
  $reg['pword'] = $_POST['pass1']; $reg['confirmPass'] = $_POST['pass2'];

  $reg['adrs'] = $_POST['address']; $reg['ste'] = $_POST['suite'];
  $reg['city'] = $_POST['city']; $reg['prov'] = $_POST['province'];
  $reg['post'] = $_POST['postal']; $reg['ctry'] = $_POST['country'];
  
  $reg['phone1'] = $_POST['phonenum1']; $reg['ext1'] = $_POST['ext1']; $reg['ptype1'] = $_POST['ptype1'];
  $reg['phone2'] = $_POST['phonenum2']; $reg['ext2'] = $_POST['ext2']; $reg['ptype2'] = $_POST['ptype2'];

  validInput($reg['fname'], 'firstname');
  validInput($reg['lname'], 'lastname');
  validInput($reg['email'], 'email');
  validInput($reg['pword'], 'pass1');
  validInput($reg['confirmPass'], 'pass2');
  validInput($reg['adrs'], 'address');
  validInput($reg['city'], 'city');
  validInput($reg['post'], 'postal');
  validInput($reg['phone1'], 'phonenum1');
  lenInputCheck($reg['phone1'], 10, 'phonenum1Len');
  !empty($reg['phone2']) ? lenInputCheck($reg['phone2'], 10, 'phonenum2Len') : NULL;
  validPassword($reg['pword'], $reg['confirmPass'], 'passCheck');

  if(count($errors) < 1 ) {
    $lastID = insertCust($reg['fname'], $reg['lname'], $reg['email'], md5($reg['pword']));
    
    if($lastID > 0) {
      $lastAddr = insertAddress($reg['adrs'], $reg['ste'], $reg['city'], $reg['prov'], $reg['post'], $reg['ctry'], $lastID);
      
      if($lastAddr > 0 && (!empty($reg['phone1']))) {
        $phone1ValCheck = insertPhone($reg['phone1'], $reg['ext1'], $reg['ptype1'], $lastID);

        if($phone1ValCheck > 0 && !empty($reg['phone2'])) {
          insertPhone($reg['phone2'], $reg['ext2'], $reg['ptype2'], $lastID);
        }
    }}
    
    $_SESSION['message'] = 'your user account has been created... please login below ';
    unset($reg);
    
    exit(header("location: index.php"));
    ob_end_flush();
}};

function getInsertedId($email) {
  global $con; $con->next_result();
    $sql = "CALL create_get_inserted_id('$email')";
    $result = $con->query($sql);
    while($row = $result->fetch_assoc()) {
      return $row['lastid'];
}}

function insertCust($fn, $ln, $em, $pw) {
  echo 'testtest';
  global $con; $con->next_result();
  $sql = "CALL insert_new_cust('$fn', '$ln', '$em', '$pw')";
  if($result = $con->query($sql)) {
    return getInsertedId($em);
}}

function insertAddress($adrs, $ste, $city, $prov, $postal, $ctry, $custid) {
  global $con; $con->next_result();
  $sql = "CALL insert_new_address('$adrs', '$ste', '$city', '$prov', '$postal', '$ctry', '$custid')";
  $result = $con->query($sql);

  // yield val to check to proceed to phone
  return $con->affected_rows ? $con->affected_rows : 0;
}

function insertPhone($num, $ext, $type, $custid) {
  global $con; $con->next_result();
  $sql = "CALL insert_new_phone('$num', '$ext', '$type', '$custid')";
  $result = $con->query($sql);

  // yield val to check to proceed to NEXT phone
  return $con->affected_rows ? $con->affected_rows : 0;
}

function inputCreateVal($val) {
  global $reg;
  return isset($reg[$val]) ? $reg[$val] : '';
}

?>

