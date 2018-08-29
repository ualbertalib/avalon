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

  // deposit agreement checkbox
  var checkbox = $("#agreement_checkbox");
  var saveButton = $("input[value='Save']");
  var saveAndContinueButton = $("input[value='Save and continue']");
  checkbox.attr("checked",false);
  if (checkbox.length>0) {
    // if the #agreement_checkbox exists on the page then prevent save
    // not present on the file upload page
    saveButton.attr("disabled",true);
    saveAndContinueButton.attr("disabled",true);
  }
  console.log(saveButton);

  var cb = checkbox.change(function() {
    var t = $(this).is(":checked");
    if ($(this).is(":checked")) {
      console.log("checked!");
      saveButton.attr("disabled",false);
      saveAndContinueButton.attr("disabled",false);
    }
    else {
      console.log("unchecked!");
      saveButton.attr("disabled",true);
      saveAndContinueButton.attr("disabled",true);
    }
  });

});
