$(document).ready(function() {
  var readySwitch = $('.readySwitch');
  var ready = $('.sitting .ready');
  var waitingSwitch = $('.waitingSwitch');
  var waiting = $('.sitting .waiting');
  readySwitch.click(function() {
    readySwitch.addClass('active');
    ready.addClass('active');
    waitingSwitch.removeClass('active');
    waiting.removeClass('active');
    $.ajax({
      type: 'GET',
      url: '/sitting-switch'
    });
  });
  waitingSwitch.click(function() {
    readySwitch.removeClass('active');
    ready.removeClass('active');
    waitingSwitch.addClass('active');
    waiting.addClass('active');
    $.ajax({
      type: 'GET',
      url: '/sitting-switch'
    });
  });
});