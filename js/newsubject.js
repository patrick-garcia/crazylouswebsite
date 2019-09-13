let newSubj = {
  fieldInput:     document.getElementsByName("newSubjField"),
  btn:            document.getElementsByName("btnNewSubj"),
  subjPostError:  document.getElementById('subjposterror'),
  events:         ['change', 'mouseleave']
}

newSubj.runValidation = function() {
  let fieldVal = this.fieldInput[0].value
  this.checkIfEmpty(fieldVal)
}

newSubj.checkIfEmpty = function(subject) {
  if (subject.length != 0) {
    this.btn[0].removeAttribute("disabled")
    this.btn[0].focus()
    this.subjPostError.innerHTML = ''

  } else {
    this.btn[0].setAttribute("disabled", "true")
    subject.length == 0 ? this.subjPostError.innerHTML = '*** required field' : this.subjPostError.innerHTML = ''
    
  }
}

newSubj.events.forEach(evt => {
  newSubj.fieldInput[0].addEventListener(evt, () => {
    newSubj.runValidation()
  }, false)
});