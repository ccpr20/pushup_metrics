$(document).on('turbolinks:load', function() {
  var myEle = document.getElementById("dashboard-header");
  if(myEle) {
    $('.footer').removeClass('bottom');
  }
  $('#dropdownid').val('selectedvalue')
  $("#change-leaderboard").on("click", function(){
    let trailingValue = $("#selected-Trailing").val();
    const url = new URL(window.location.href);
    url.searchParams.set('trailing_value', trailingValue);
    console.log(url.search)
    // search_params.set('trailing_value', trailingValue);
    // url.search = search_params.toString()
    var new_url = url.toString();
    console.log(new_url);
    window.location=url;

    //  changeLeaderboard();
  })

  // function changeLeaderboard(){

  //   $.ajax({
  //     url: "/trailing",
  //     type: "post",
  //     dataType: "html",
  //     data: {
  //       trailing: trailingValue,
  //     },
  //       action: 'update_trailing',
  //       _method: 'put',
  //     success: function(data) {
  //       return
  //     }, error: function (obj){
  //       return
  //     }
  //   })
  // }
})
