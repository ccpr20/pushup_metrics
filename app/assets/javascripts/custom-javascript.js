$(document).on('turbolinks:load', function() {
  var myEle = document.getElementById("dashboard-header");
  if(myEle) {
    $('.footer').removeClass('bottom');
  }

})
