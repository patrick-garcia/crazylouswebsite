let disadmin = {
  removeBtns: [...document.querySelectorAll('[data-remove]')]
}

disadmin.elemAddListen = function() {
  disadmin.removeBtns.forEach(elem => {
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
            disadmin.ajaxCall(e)
          }
        })
      }
    })
  })
}

disadmin.ajaxCall = function(e) {
  const btnID = parseInt(e.target.dataset.remove)
  const xhr = new XMLHttpRequest()
  xhr.open('GET', `private/admin/discussionadmin/discussionadminajax.php?postID=${btnID}`, true)

  xhr.onload = function () {
    if (this.status == 200) {
      const successCheck = parseInt(this.responseText)
      if (successCheck == 1) {
        Swal.fire(
          'Deleted!',
          'post has been removed',
          'success'
        )

        postToBeRemoved = document.querySelector(`[data-postrow="${btnID}"]`)
        postToBeRemoved.parentNode.removeChild(postToBeRemoved)
      }
    }
  }

  xhr.send()
}

window.onload = disadmin.elemAddListen()
