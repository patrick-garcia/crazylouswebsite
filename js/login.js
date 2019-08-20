let log = {
  checkbox: document.getElementById('recruiter-checkbox'),
  user: 'userlogin',
  pass: 'passlogin'
}

log.checkboxToggle = function() {
  this.checkbox.checked == true ? this.showLoginValues() : this.removeLoginValues();
}

log.showLoginValues = function() {
  document.getElementsByName(this.user)[0].value = 'claire@dunphy.com';
  document.getElementsByName(this.pass)[0].value = 'dunphy';
}

log.removeLoginValues = function() {
  document.getElementsByName(this.user)[0].value = '';
  document.getElementsByName(this.pass)[0].value = '';
}

log.checkbox.addEventListener("click", () => {
  log.checkboxToggle();
});