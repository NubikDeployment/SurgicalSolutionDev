$(function() {
  $('body').on('click', '[data-tab]', function(e) {
    e.preventDefault();
    var $el = $(this);

    var $frame = $('iframe[data-tab=' + $el.data('tab') + ']');
    $('[data-tab]').removeClass('active');
    $el.addClass('active');
    $frame.addClass('active');
  });
});
