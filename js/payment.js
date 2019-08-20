// function clearPayFields() {
//   let inputArray = [...document.getElementsByClassName('pay-input')];
//   inputArray.forEach((elem) => elem.value = '');
// }

// function checkBox() {
//   const checkboxElem = document.getElementById('addressCheckbox');
//   const shipInfo = [...document.getElementsByClassName('ship-info')];
//   shipInfo.forEach(elem => {!checkboxElem.checked ? elem.setAttribute('readonly', true) : elem.removeAttribute('readonly')});
// }

// // load ****
// window.onload = checkBox;

// window.addEventListener("change", function() {
//   checkBox();
// }, false);

pay = {
  inputArray: [...document.getElementsByClassName('pay-input')],
  clearBtnElem: document.getElementById('clear-btn'),
  checkboxElem: document.getElementById('addressCheckbox'),
  shipInfo: [...document.getElementsByClassName('ship-info')]
}

pay.clearPayFields = function() {
  this.inputArray.forEach(elem => elem.value = '')
}

pay.checkBox = function() {
  this.shipInfo.forEach(elem => {
    !this.checkboxElem.checked ? elem.setAttribute('readonly', true) : elem.removeAttribute('readonly')
  })
}

// load
window.onload = pay.checkBox()
window.addEventListener('change', () => {
  pay.checkBox()
}, false)

pay.clearBtnElem.addEventListener('click', (e) => {
  e.preventDefault()
  pay.clearPayFields()
}, false)