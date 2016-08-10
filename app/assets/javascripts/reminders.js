$(function() {
  $('select').selectpicker(); 

  $('#timepicker').timepicker({
      showInputs: false,
      defaultTime: false,
      minuteStep: 5
  });
});