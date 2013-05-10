$(document).ready(function() {
  $('form button').click(function() {
    $(this).closest('form').submit();
    return false;
  });
});