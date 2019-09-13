<?php

class SubjectClass {
  public $subjVal = 7;
  private $subjectArr = [];

  public function __construct() {
    $this->loadSubject();
  }
  
  public function loadSubject() {
    global $con; moreResCheck($con);
    $sql = "CALL subject_load_all()";
    $subject = $con->query($sql) or die($con->error);
    while($item = $subject->fetch_assoc()) array_push($this->subjectArr, $item);
  }

  public function showSortSubj($subjVal = 7) {
    $htmlStr = '';
    foreach($this->subjectArr as $key => $val) {
      $htmlStr .= '<option value="' . $val['id'] .'" ';
      $htmlStr .= $this->selectedCheck($subjVal, $val['id']) . '>';
      $htmlStr .= $val['subjectname'] . '</option>';
    }
    return $htmlStr;
  }

  public function showNewPostSubj($subjVal = 1) {
    $htmlStr = '';
    foreach($this->subjectArr as $key => $val) {
      if($val['subjectname'] != 'all') {
        $htmlStr .= '<option value="' . $val['id'] . '">';
        $htmlStr .= $val['subjectname'] . '</option>';
    }}
    
    return $htmlStr;
  }

  public function selectedCheck($subjValSelected, $optVal) {
    return $subjValSelected == $optVal ? 'selected' : NULL;
  }
}

class DiscussionClass {
  public $rows = [];
  public $btnAndInputArray = [];
  public $userid;
  public $id;
  public $commenttext;
  public $postid;

  public function loadDiscussionPosts() {
    global $con; moreResCheck($con);
    $sql = "CALL discussion_load_all()";
    $res = $con->query($sql) or die($con->error);
    $resArr = [];
    while ($item = $res->fetch_assoc()) {
      array_push($resArr, $item);
    }

    $this->assignBtnAndInputNames($resArr);
    return $resArr;
  }

  public function assignBtnAndInputNames($array) {
    foreach($array as $key => $val) {
      $this->btnAndInputArray[$key]['postid'] = $val['postid'];
      $this->btnAndInputArray[$key]['btn'] = 'postCommBtn' . $val['postid'];
      $this->btnAndInputArray[$key]['input'] = 'postCommInput' . $val['postid'];
    }
  }

  public function loadDiscPostsBySubj($val) {
    global $con; moreResCheck($con);
    $sql = "CALL discussion_based_on_subj('$val')";
    $res = $con->query($sql) or die($con->error);
    $resArr = [];
    while ($item = $res->fetch_assoc()) {
      array_push($resArr, $item);
    }

    return $resArr;
  }

  public function loadComments($postid) {
    global $con; moreResCheck($con);
    $sql = "CALL comment_load_based_on_postid($postid)";
    $result = $con->query($sql);
    $resArray = [];
    while($item = $result->fetch_assoc()) array_push($resArray, $item);
    return $resArray;
  }
}

class DisplayName {
  static function username($userid) {
    global $con; moreResCheck($con);
    $sql = "CALL discussion_get_username($userid)";
    $result = $con->query($sql)->fetch_assoc();
    $expert = $result['expert'] ? '<i class="fas fa-user-graduate ml-2"></i>' : '';
    $username = $result['firstname'] . ' ' . $result['lastname'][0] . '.';
    $username .= $expert;
    return $username ;
  }

  static function username2($userid) {
    global $con; moreResCheck($con);
    $sql = "CALL discussion_get_username($userid)";
    $result = $con->query($sql)->fetch_assoc();
    $expert = $result['expert'] ? '<i class="fas fa-user-graduate mr-2"></i>' : '';
    $username = $expert;
    $username .= $result['firstname'] . ' ' . $result['lastname'][0] . '.';
    return $username;
  }

  static function adminCheck($id) {
    global $con; moreResCheck($con);
    $sql = "CALL admin_check($id)";
    $result = $con->query($sql)->fetch_assoc() or die($con);
    return $result['admin'];
  }
}

class NewPostClass {
  public $valCheckforMsg;
    
  public function __construct($subjNew, $titleNew, $textNew, $userid) {
    $this->newPostInsert($subjNew, $titleNew, $textNew, $userid);
  }
  
  public function newPostInsert($subjVal, $title, $text, $userid) {
    global $con; moreResCheck($con);
    $sql = "CALL discussion_insert_new('$subjVal', '$title', '$text', '$userid')";
    $con->query($sql);
    $con->affected_rows ? $this->$valCheckforMsg = $con->affected_rows : 0;
  }
}

class NewCommentClass {
  public $valCheckforMsg;

  public function __construct($userid, $text, $postid) {
    $this->commentInsertNew($userid, $text, $postid);
  }

  public function commentInsertNew($userid, $text, $postid) {
    global $con; moreResCheck($con);
    $sql = "CALL comment_insert_new('$userid', '$text' , '$postid')";
    $con->query($sql);
    $con->affected_rows ? $this->valCheckforMsg = $con->affected_rows : 0;
  }
}

?>
