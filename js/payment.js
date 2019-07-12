function clearPayFields() {
  let inputArray = [...document.getElementsByClassName('pay-input')];
  inputArray.forEach((elem) => elem.value = '');
}

function checkBox() {
  const checkboxElem = document.getElementById('addressCheckbox');
  const shipInfo = [...document.getElementsByClassName('ship-info')];
  shipInfo.forEach(elem => {!checkboxElem.checked ? elem.setAttribute('readonly', true) : elem.removeAttribute('readonly')});
}

// load ****
window.onload = checkBox;

window.addEventListener("change", function() {
  checkBox();
}, false);