$(function () {
  var width = $(window).width();
  if (width < 576) {
    $('#cart a:first-child').removeClass('btn-outline-primary')
    $('#cart a:first-child').addClass('btn-primary')
    
  } else {
    $('#cart a:first-child').removeClass('btn-primary')
    $('#cart a:first-child').addClass('btn-outline-primary')
  }

  $(window).resize(function() {
    if (width < 576) {
      $('#cart a:first-child').removeClass('btn-outline-primary')
      $('#cart a:first-child').addClass('btn-primary')

    } else {
      $('#cart a:first-child').removeClass('btn-primary')
      $('#cart a:first-child').addClass('btn-outline-primary')
    }
  });

  if (width <= 767) {
    $('#cart a').removeClass('btn-sm')
    $('#each-album a').removeClass('btn-sm')

  } else {
    $('#cart a').addClass('btn-sm')
    $('#each-album a').addClass('btn-sm')
  }

  $(window).resize(function() {
    if (width <= 767) {
      $('#cart a').removeClass('btn-sm')
      $('#each-album a').removeClass('btn-sm')

    } else {
      $('#cart a').addClass('btn-sm')
      $('#each-album a').addClass('btn-sm')
    }
  });

});