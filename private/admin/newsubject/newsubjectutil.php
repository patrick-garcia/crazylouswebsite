<?php
  class SubjectClass {
    static public $subjectArr = [];
    public $admin;
    public $expert;

    public function __construct() {
      $this->loadSubject();
    }

    private function loadSubject() {
      global $con; moreResCheck($con);
      $sql = "CALL subject_posts_count()";
      $subject = $con->query($sql) or die($con->error);
      while($item = $subject->fetch_assoc()) {
        if ($item['subjectname'] != 'all') {
          array_push(SELF::$subjectArr, $item);
        }
      }
    }
  }

  class NewSubject {
    public $valCheck;
    
    public function __construct($subject) {
      $sortval = $this->getMaxSortval();
      $this->newSubjectInsert($subject, $sortval);
    }

    private function getMaxSortval() {
      global $con; moreResCheck($con);
      $sql = "CALL subject_max_sortval()";
      $result = $con->query($sql)->fetch_assoc() or die($con->error);
      return intval($result['max_sortval']) + 1;
    }

    private function newSubjectInsert($subject, $sortval) {
      global $con; moreResCheck($con);
      $sql = "CALL subject_insert_new('$subject', $sortval)";
      $con->query($sql) or die($con->error);
      $con->affected_rows ? $this->$valCheck = $con->affected_rows : 0;
    }
  }


?>