<?php
  include_once 'data/siteinfo.php';
  include_once 'contactutil.php';

  function openNewTab($index) {
    return $index == 'My Website' ? 'target="_blank"' : NULL;
  }

  function displayBold($key, $val, $stingCheck) {
    echo $key == $stingCheck ? '<span style="font-weight: normal">' . $val . '</span>' : $val;
  }

  $course1 = new CourseClass($course, 'Course Title', 'bold');
  $course2 = new CourseClass($course2, 'Course Title', 'bold');
  $name = new NameInfoClass($student, 'Name', 'bold');
  $contact = new ContactInfoClass($contact);
?>