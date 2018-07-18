$(document).ready(function() {
  $('.license-select').on('click', function() {
    var license = $(this).data('uri');

    // Show brief description for selected license only
    $('.license-description').addClass('hidden');
    $('.license-description[data-uri="' + license + '"]').removeClass('hidden');

    if (license == 'CUSTOM') {
      // Show text box for custom license text
      $('#media_object_terms_of_use_custom').removeClass('hidden');
    }
    else {
      // Hide text box for non-custom license text
      $('#media_object_terms_of_use_custom').addClass('hidden');
    }
  });
});
