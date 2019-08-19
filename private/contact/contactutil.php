<?php
class SharedFunction {
  protected function displayHTML($array, $stringCheck, $fontWeight) {
    $string = '';
    foreach($array as $key => $val) {
      $string .= '<li class="list-group-item font-weight-light">';
      $string .= $key . ': ';
      $string .= $this->highLightString($key, $val, $stringCheck, $fontWeight);
      $string .= '</li>';
    }
    
    return $string;
  }

  private function highLightString($key, $val, $stringCheck, $fontWeight) {
    return $key == $stringCheck ? '<span class="font-weight-' . $fontWeight . '">' . $val . '</span>' : $val;
  }
}

class CourseClass extends SharedFunction {
  public $string;
    
  function __construct($infoArray, $highlightString, $fontWeight = 'normal') {
    $this->string = $this->displayHTML($infoArray, $highlightString, $fontWeight);
  }
}

class NameInfoClass extends CourseClass {
  function __construct($infoArray, $highlightString, $fontWeight = 'normal') {
    parent::__construct($infoArray, $highlightString, $fontWeight);
  }
}

class ContactInfoClass {
  public $string;

  function __construct($infoArray) {
    $this->string = $this->displayHTMLForLink($infoArray);
  }

  private function displayHTMLForLink($array) {
    $string = '';
    foreach($array as $key => $val) {
      $string .= '<li class="list-group-item font-weight-light">';
      $string .= $key . ': <a href="' . $val['prefix'] . $val['display'] . '"';
      $string .= openNewTab($key);
      $string .= '>' . $val['display'] . '</a>';
      $string .= '</li>';
    }

    return $string;
  }

  private function openNewTab($index) {
    return $index == 'My Website' ? 'target="_blank"' : NULL;
  }
  
}






?>