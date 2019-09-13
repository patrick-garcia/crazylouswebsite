let disc = {
  titleInput:         document.getElementsByName("titleNewPost"),
  textInput:          document.getElementsByName("textNewPost"),
  btn:                document.getElementsByName("btnNewPost"),
  titlePostError:     document.getElementById('titleposterror'),
  textPostError:      document.getElementById('textposterror'),
  events:             ['change', 'mouseleave']
}

disc.runValidation = function() {
  let titleVal = this.titleInput[0].value
  let textVal = this.textInput[0].value

  this.checkIfEmpty(titleVal, textVal)
}

disc.checkIfEmpty = function(title, text) {
  if(title.length != 0 && text.length != 0) {
    this.btn[0].removeAttribute("disabled")
    this.btn[0].focus()
    this.titlePostError.innerHTML = ''
    this.textPostError.innerHTML = ''

  } else {
    this.btn[0].setAttribute("disabled", "true")

    title.length == 0 ? this.titlePostError.innerHTML = '*** required field' : this.titlePostError.innerHTML = ''
    text.length == 0 ? this.textPostError.innerHTML = '*** required field' : this.textPostError.innerHTML = ''
  }
}

disc.events.forEach(evt => {
  disc.titleInput[0].addEventListener(evt, () => {
    disc.runValidation()
  }, false)
  
  disc.textInput[0].addEventListener(evt, () => {
    disc.runValidation()
  }, false)

});

