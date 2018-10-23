"use strict";

$(document).ready(function() {

  $('body').addClass('tinted-image');

  $('#school_selector').on('change', function() {
    if (this.value == "False") {
      $('.tms-get-school').removeClass("d-none");
    } else {
      $('.tms-get-school').addClass("d-none");
    }
  });

  // $('#new_school_abbrev').on('change', () => {
  //   if 
  // })

});