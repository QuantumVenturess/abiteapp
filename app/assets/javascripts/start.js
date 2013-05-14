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
  // Typing in the search box returns results
  var typingTimer;
  var doneTypingInterval = 500;
  var search = $('.place_search .placeName input');
  search.keyup(function() {
    typingTimer = setTimeout(doneTypingSearch, doneTypingInterval);
  });
  search.keydown(function() {
    clearTimeout(typingTimer);
  });
});

function doneTypingSearch() {
  var location = $('.place_search .location input').val();
  var term     = $('.place_search .placeName input').val();
  if (term != '') {
    $.ajax({
      data: {
        location: location,
        term: term
      },
      dataType: 'script',
      type: 'GET'
    });
  };
};