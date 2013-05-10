$(document).ready(function() {
  $('.table_form .seatButton').click(function() {
    var value = $(this).attr('data-value');
    $('.table_form .field input').val(value);
  });
});