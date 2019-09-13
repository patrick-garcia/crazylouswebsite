let reset = {
  resetBtns:          [...document.querySelectorAll('[data-resetBtn]')],
  checkMarkClass:     [...document.getElementsByClassName('checkmark')], // output 2 elems
  inputMsgs:          [...document.getElementsByClassName('input-msgs')],

  passwordInput:      document.querySelector('input[name="passInput1"]'),
  confirmPassInput:   document.querySelector('input[name="passInput2"]'),
  updatePassBtn:      document.querySelector('button[name="resetPassBtn"]'),

  emptyMsg:           '*** input field cannot be empty ***',
  invEmailMsg:        '*** not a valid email ***',
  emailNotFound:      '*** email does not exist, please create a new account ***',
  incorrectAns:       '*** incorrect answer to security question ***',
  passMismatch:       '*** passwords do NOT match ****',
  checkMark:          '&#10003'
}

reset.runPassValidation = function () {
  const pass1 = this.passwordInput.value.trim()
  const pass2 = this.confirmPassInput.value.trim()

  $valChk = this.checkIfEmpty(pass1, pass2)
  $valChk ? this.passMatch(pass1, pass2) : '';
}

reset.checkIfEmpty = function (pass1, pass2) {
  if (pass1.length != 0 && pass2.length != 0) {
    this.inputMsgs[2].innerHTML = ''
    this.inputMsgs[3].innerHTML = ''
    return 1;

  } else {
    pass1.length == 0 ? this.inputMsgs[2].innerHTML = this.emptyMsg : this.inputMsgs[2].innerHTML = ''
    pass2.length == 0 ? this.inputMsgs[3].innerHTML = this.emptyMsg : this.inputMsgs[3].innerHTML = ''
    return 0;
  }
}

reset.passMatch = function(pass1, pass2) {
  if (pass1 == pass2) {
    this.updatePassBtn.removeAttribute("disabled")
    this.inputMsgs[2].innerHTML = ''
    this.inputMsgs[3].innerHTML = ''
  
  } else {
    this.updatePassBtn.setAttribute("disabled", true)
    this.inputMsgs[2].innerHTML = this.passMismatch
    this.inputMsgs[3].innerHTML = this.passMismatch
  }
}

// listeners
reset.elemAddListen = function () {
  this.resetBtns.forEach(elem => {
    elem.addEventListener('click', (e) => {
      reset.ajaxCall(e)
    })
  })
}

reset.passInputListen = function () {
  ['change', 'mouseleave'].forEach(evt => {
    this.passwordInput.addEventListener(evt, () => {
      this.runPassValidation()
    }, false)

    this.confirmPassInput.addEventListener(evt, () => {
      this.runPassValidation()
    }, false)
  })
}

// AJAX
reset.ajaxCall = function(e) {
  e.preventDefault()
  const elemTarget = e.target;
  const email = document.querySelector('input[name="resetEmailInput"]').value.trim()

  if (email.length == 0) {
    emailValidation(0, reset.emptyMsg)
    
  } else if(emailIsValid(email) == false) {
    emailValidation(0, reset.invEmailMsg)
  
  } else {
    const xhr = new XMLHttpRequest();
    
    if(elemTarget.hasAttribute('data-emailChk')) {
      xhr.open('GET', `private/reset/resetajax.php?email=${email}`, true)

      xhr.onload = function() {
        if(this.status == 200) {
          const data = JSON.parse(this.responseText)
          // selectors
          const button = document.querySelector('button[name="answerCheckBtn"]')
          const answerField = document.querySelector('input[name="resetAnswerInput"]')
          const question = document.getElementById('questionString')
          const checkMark = reset.checkMarkClass[0]
          const elemArray = [button, answerField]

          if (data.userid > 0) {
            emailValidation(0)
            elemArray.forEach(elem => elem.removeAttribute('disabled'))
            question.innerHTML = data.string;
            checkMark.innerHTML = reset.checkMark

          } else {
            emailValidation(0, reset.emailNotFound)
            button.setAttribute('disabled', true)
            answerField.setAttribute('disabled', true)
            question.innerHTML = 'security question'
            checkMark.innerHTML = ''
          }
        }
      }

      xhr.send()
    }

    if(elemTarget.hasAttribute('data-questionChk')) {
      let answer = document.querySelector('input[name="resetAnswerInput"]').value.trim()

      if(answer.length == 0) {
        emailValidation(1, reset.emptyMsg)
      
      } else {
        xhr.open('GET', `private/reset/resetajax.php?email=${email}&answer=${answer}`, true)

        xhr.onload = function() {
          if(this.status == 200) {
            const successCheck = parseInt(this.responseText) // response is 1 or 0
            const passField = reset.passwordInput
            const confPassField = reset.confirmPassInput
            const checkMark = reset.checkMarkClass[1]
            elemArray = [passField, confPassField]

            if (successCheck > 0) {
              emailValidation(1)
              elemArray.forEach(elem => elem.removeAttribute('disabled'))
              checkMark.innerHTML = reset.checkMark

            } else {
              emailValidation(1, reset.incorrectAns)
              elemArray.forEach(elem => elem.setAttribute('disabled', true))
              checkMark.innerHTML = ''
            }
          }
        }

        xhr.send()
      }      
    }
  }
}

// email validation - 0 index is email input field
function emailValidation(index = 0, msg = '') {
  reset.inputMsgs[index].innerHTML = msg 
}

// regex
function emailIsValid(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
}

reset.init = function () {
  reset.elemAddListen();
  reset.passInputListen();
}

window.onload = reset.init()
