$(document).ready(function() {
  // Clicking the start button
  $('.table_form .seatButton').click(function() {
    var value = $(this).attr('data-value');
    $('.table_form .max_seats_hidden').val(value);
    $(this).closest('form').submit();
  });
  // Clear location and name
  var clearLocation = $('.clearLocation');
  var clearPlaceName = $('.clearPlaceName');
  var locationInput = $('.location input');
  var placeNameInput = $('.placeName input');
  locationInput.click(function() {
    clearLocation.show();
    clearPlaceName.hide();
    return false;
  });
  clearLocation.click(function() {
    locationInput.val('');
    locationInput.focus();
    return false;
  });
  placeNameInput.click(function() {
    clearLocation.hide();
    clearPlaceName.show();
    return false;
  });
  clearPlaceName.click(function() {
    placeNameInput.val('');
    placeNameInput.focus();
    return false;
  });
  $('a, button').click(function() {
    clearLocation.hide();
    clearPlaceName.hide();
  });
  $(document).click(function() {
    clearLocation.hide();
    clearPlaceName.hide();
  });
});