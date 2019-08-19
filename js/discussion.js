function runValidation() {
  let titleInput = [...document.getElementsByName("titleNewPost")];
  let textInput = [...document.getElementsByName("textNewPost")];
  let titleVal = titleInput[0].value
  let textVal = textInput[0].value
  
  checkIfEmpty(titleVal, textVal)
}

function checkIfEmpty(title, text) {
  let btn = [...document.getElementsByName("btnNewPost")];
  let titlePostError = document.getElementById('titleposterror');
  let textPostError = document.getElementById('textposterror');
    
  if(title.length != 0 && text.length != 0) {
    btn[0].removeAttribute("disabled")
    btn[0].focus()
    titlePostError.innerHTML = ''
    textPostError.innerHTML = ''
    console.log(title, text)
  } else {
    btn[0].setAttribute("disabled", "true")
    
    title.length == 0 ? titlePostError.innerHTML = '*** required field' : titlePostError.innerHTML = ''
    text.length == 0 ? textPostError.innerHTML = '*** required field' : textPostError.innerHTML = ''
  }
}

["change", "mouseleave"].forEach(function(evt) {
  let titleInput = [...document.getElementsByName("titleNewPost")];
  let textInput = [...document.getElementsByName("textNewPost")];
  titleInput[0].addEventListener(evt, runValidation, false)
  textInput[0].addEventListener(evt, runValidation, false)
})


