<?php

!isset($_SESSION) ? session_start() : NULL;
include_once 'data/dbfile.php';
include_once 'discussionutil.php';
include_once 'private/util/variables.php';
include_once 'private/util/functions.php';

if(!isset($_SESSION['loggedID'])) {
  exit(header("location: index.php"));
  ob_end_flush();

} else {
  !isset($posts) ? $posts = new DiscussionClass : '';
  !isset($subj) ? $subj = new SubjectClass : '';
  !isset($posts->rows) ? $posts->rows = $posts->loadDiscussionPosts() : NULL;
  $posts->id = $_SESSION['loggedID'];
}

!isset($posts) ? $posts = new DiscussionClass : '';
!isset($posts->rows) ? $posts->rows = $posts->loadDiscussionPosts() : NULL;

// new post
if(isset($_POST['btnNewPost'])) {
  if(!empty($_POST['titleNewPost']) && !empty($_POST['textNewPost'])) {
    $newPost = new NewPostClass(
      $_POST['subjectNewPost'], $_POST['titleNewPost'],
      $_POST['textNewPost'], $_SESSION['loggedID']
    );
  
    if($newPost->$valCheckforMsg > 0) {
      $_SESSION['message'] = 'your post has been submitted ';

      exit(header("location: discussion.php"));
      ob_end_flush();
    }
  }
}

// sort/filter
if(isset($_POST['subjecttitle'])) {
  $subj->subjectVal = $_POST['subjecttitle'];

  if($subj->subjectVal != 7) {
    $posts->rows = $posts->loadDiscPostsBySubj($subj->subjectVal);

  } else {
    $posts->rows = $posts->loadDiscussionPosts();
  }
  
} else {
  $posts->rows = $posts->loadDiscussionPosts();
}

//leave comment on  post
foreach($posts->btnAndInputArray as $key => $val) {
  if(isset($_POST[$val['btn']])) {
    $errorCheckInputVal2 = 'errorCheckInputVal' . $val['postid'];
    
    if(empty($_POST[$val['input']])) {
      global $errors;
      $errors[$errorCheckInputVal2] = '*** input field cannot be empty ***';
    }
    
    if(count($errors) < 1) {
      $newComment = new NewCommentClass(
        $_SESSION['loggedID'],
        $_POST[$val['input']],
        $val['postid']
      );

      if($newComment->valCheckforMsg > 0) {
        $_SESSION['message'] = 'your comment has been submitted ';

        exit(header("location: discussion.php"));
        ob_end_flush();
    }}
}}

  
?>