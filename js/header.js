//login section
function addBgToBody() {
  let urlArray = window.location.pathname.split('/')
  let val = splitUrlArray(urlArray)
  checkUrl(val)
}

function checkUrl(val) {
  let urlCheck = 'login.php';
  let classVal = 'login-bg-color';
  val == urlCheck ? document.body.classList.add(classVal) : null;
}

//navlinks
function highlightNavLink() {
  let urlArray = window.location.pathname.split('/')
  let val = splitUrlArray(urlArray)
  let navLinks = [...document.getElementsByClassName('nav-item')]
  loopThruNavLinks(navLinks, val)
}

function loopThruNavLinks(navArray, valCheck) {
  navArray.forEach((elem) => {
    let urlArray = elem.href.split('/')
    let urlEnding = splitUrlArray(urlArray)
    urlEnding == valCheck ? elem.className += ' navlink-active' : null;
  })
}

// shared function ****
function splitUrlArray(urlArr) {
  return urlArr[urlArr.length - 1];
}

// onload ****
window.addEventListener("load", function() {
  addBgToBody();
  highlightNavLink();
}, false);

