<?php
!isset($_SESSION) ? session_start() : NULL;
include_once 'data/dbfile.php';
include_once 'createutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';

!isset($userInfo) ? $userInfo = new NameClass : NULL;
!isset($addr) ? $addr = new AddressClass : NULL;
!isset($phone) ? $phone = new PhoneClass : NULL;
!isset($security) ? $security = new SecurityQuestionClass : '';

if(isset($_POST['register'])) {
  $userInfo->fname = $_POST['firstname']; validInput($userInfo->fname, 'firstname');
  $userInfo->lname = $_POST['lastname']; validInput($userInfo->lname, 'lastname');
  $userInfo->email = $_POST['email']; validInput($userInfo->email, 'email');
  $userInfo->password = $_POST['pass1']; validInput($userInfo->password, 'pass1');
  $userInfo->confirmPass = $_POST['pass2']; validInput($userInfo->confirmPass, 'pass2');
  validPassword($userInfo->password, $userInfo->confirmPass, 'passCheck');

  $addr->adrs = $_POST['address']; validInput($addr->adrs, 'address');
  $addr->ste = $_POST['suite'];
  $addr->city = $_POST['city']; validInput($addr->city, 'city');
  $addr->prov = $_POST['province'];
  $addr->post = $_POST['postal']; validInput($addr->post, 'postal');
  $addr->ctry = $_POST['country'];

  $phone->num1 = $_POST['phonenum1']; validInput($phone->num1, 'phonenum1');
  lenInputCheck($phone->num1, 10, 'phonenum1Len');
  $phone->ext1 = $_POST['ext1'];
  $phone->type1 = $_POST['ptype1'];

  $phone->num2 = $_POST['phonenum2'];
  !empty($phone->num2) ? lenInputCheck($phone->num2, 10, 'phonenum2Len') : NULL;
  $phone->ext2 = $_POST['ext2'];
  $phone->type2 = $_POST['ptype2'];

  $security->question = $_POST['securityquestion'];
  $security->answer = $_POST['securityanswer'];
  validInput($security->answer, 'securityanswer');

  if(count($errors) < 1 ) {
    $lastID = $userInfo->insertCustomerInfo($userInfo->fname, $userInfo->lname, $userInfo->email, $userInfo->password);
    
    if($lastID > 0) {
      // $lastAddr = $addr->insertAddress($addr->adrs, $addr->ste, $addr->city, $addr->prov, $addr->post, $addr->ctry, $lastID);
      $lastAddr = $addr->insertAddress($addr->adrs, $addr->ste, $addr->city, $addr->prov, $addr->post, $addr->ctry);
      
      if($lastAddr > 0 && (!empty($phone->num1))) {
        // $phone1ValCheck = $phone->insertPhone($phone->num1, $phone->ext1, $phone->type1, $lastID);
        $phone1ValCheck = $phone->insertPhone($phone->num1, $phone->ext1, $phone->type1);

        if($phone1ValCheck > 0 && !empty($phone->num2)) {
          // $phone->insertPhone($phone->num2, $phone->ext2, $phone->type2, $lastID);
          $phone->insertPhone($phone->num2, $phone->ext2, $phone->type2);
        }
      }
        
      // $security->insertUserQuestion($lastID, $security->question, $security->answer);
      $security->insertUserQuestion($security->question, $security->answer);
    }
    
    $_SESSION['message'] = 'your user account has been created... please login below ';
    
    exit(header("location: index.php"));
    ob_end_flush();
}};

// load function
function showInputVal($inputVal) {
  return isset($inputVal) ? $inputVal : '';
}


?>

