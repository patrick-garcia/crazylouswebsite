let userMgr = {
  checkboxes: [...document.querySelectorAll('[data-id]')]
}

userMgr.LoadEventListeners = function() {
  userMgr.checkboxes.forEach(elem => {
    elem.addEventListener('change', (e) => userMgr.ajaxCall(e) )
  })
}

userMgr.ajaxCall = function(e) {
  e.preventDefault();
  const elemTarget = e.target
  const id = e.target.dataset.id
  const xhr = new XMLHttpRequest();

  if(elemTarget.hasAttribute('data-subscriber')) {
    let subscriberVal = parseInt(elemTarget.dataset.subscriber) ? 0 : 1;
    xhr.open('GET', `private/admin/user/userajax.php?id=${id}&subscriber=${subscriberVal}`, true)

    xhr.onload = function() {
      if(this.status == 200) {
        const successCheck = parseInt(this.responseText)
        successCheck == 1 ? elemTarget.setAttribute('data-subscriber', subscriberVal) : '';
      }
    }

  }
  
  if (elemTarget.hasAttribute('data-expert')) {
    let expertVal = parseInt(elemTarget.dataset.expert) ? 0 : 1;
    xhr.open('GET', `private/admin/user/userajax.php?id=${id}&expert=${expertVal}`, true)

    xhr.onload = function() {
      successCheck(e)
      if(this.status == 200) {
        const successCheck = parseInt(this.responseText)
        successCheck == 1 ? elemTarget.setAttribute('data-expert', expertVal) : '';
      }
    }
  }

  xhr.send()
}

// **** load  ****
window.onload = userMgr.LoadEventListeners()
