let comm = {
  removeBtns: [...document.querySelectorAll('[data-removebtn]')]
}

comm.elemAddListen = function() {
  comm.removeBtns.forEach(elem => {
    elem.addEventListener('click', (e) => {

      if(typeof Swal === "undefined") {
        alert('no internet connection :(')
      
      } else {
        Swal.fire({
          title: 'are you sure?',
          text: "you won't be able to undo this",
          type: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#3085d6',
          cancelButtonColor: '#d33',
          confirmButtonText: 'Delete'
        }).then((result) => {
          if (result.value) {
            comm.ajaxCall(e)
          }
        })
      }
    })
  })
}

comm.ajaxCall = function(e) {
  const btnID = parseInt(e.target.dataset.removebtn)
  const xhr = new XMLHttpRequest()
  xhr.open('GET', `private/discussion/discussionajax.php?commentID=${btnID}`, true)

  xhr.onload = function () {
    if (this.status == 200) {
      const successCheck = parseInt(this.responseText)
      if (successCheck == 1) {
        Swal.fire(
          'Deleted!',
          'commment has been removed',
          'success'
        )

        commentToBeRemoved = document.querySelector(`[data-commentid="${btnID}"]`)
        commentToBeRemoved.parentNode.removeChild(commentToBeRemoved)
      }
    }
  }

  xhr.send()
}

window.onload = comm.elemAddListen()

