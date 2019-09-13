<?php 
!isset($_SESSION) ? session_start() : NULL;
include_once 'data/dbfile.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';
include_once 'newsubjectutil.php';
include_once 'private/admin/adminutil.php';

if(!isset($_SESSION['loggedID'])) {
  exit(header("location: index.php"));
  ob_end_flush();

} else {
  $adminCheck = AdminCheckClass::adminCheck($_SESSION['loggedID']);
  $expertCheck = AdminCheckClass::expertCheck($_SESSION['loggedID']);
  if ($adminCheck > 0 || $expertCheck > 0) {
    new SubjectClass();

  } else {
    exit(header("location: discussion.php"));
    ob_end_flush();
  }
}


if(isset($_POST['btnNewSubj'])) {
  if(!empty($_POST['newSubjField'])) {
    $newSubj = new NewSubject($_POST['newSubjField']);

    if($newSubj->$valCheck > 0) {
      $_SESSION['message'] = 'new subject was added ';

      exit(header("location: newsubject.php"));
      ob_end_flush();
    }
  }
}

?>

