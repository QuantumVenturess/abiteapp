$(document).ready(function() {
  $('.table_form .seatButton').click(function() {
    var value = $(this).attr('data-value');
    $('.table_form .max_seats_hidden').val(value);
    $(this).closest('form').submit();
  });
});