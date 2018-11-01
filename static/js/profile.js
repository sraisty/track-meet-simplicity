"use strict";

$(document).ready(function() {

  $('#school_selector').on('change', function() {
    if (this.value == "") {
      $('.tms-get-school').removeClass("d-none");
    } else {
      $('.tms-get-school').addClass("d-none");
    }
  });

  // $('#new_school_code').on('change', () => {
  //   if 
  // })

});