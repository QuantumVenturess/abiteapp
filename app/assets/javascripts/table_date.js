$(document).ready(function() {
  $('.tableStartDate .calendar .date').click(function() {
    $('.tableStartDate .calendar .date').removeClass('selected');
    $(this).addClass('selected');
    $('.tableStartDate .startDateDate').val($(this).attr('value'));
  });
});