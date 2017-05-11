;(function ($, document, window, undefined) {
  var runExample = function() {
    var $btn = $(this);
    var id = $btn.attr('id');

    var sel = '#' + id.replace(/^btn/, 'div');
    eval($(sel).text());

    return false;
  };

  $(document).ready(function() {
    $('.foswikiTopic').on('click', 'a.jqButton', runExample);
  });
}(jQuery, document, window, undefined));
