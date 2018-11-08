"use strict";

$(document).ready(function() {

    /// Tables listing MDE entrants
    // $('#home_navbar').DataTable({
    //     'ordering': true
    // });

  //   $('#meets_navbar')
  // $('#schools_navbar')
  // $('#athletes_navbar')

  $('#navbarMeetMenuLink').on('click', (evt) => {
    $('#navbarMeetMenuLink').addClass('active');
    $('#schools_navbar').removeClass('active');
    $('#athletes_navbar').removeClass('active');
  });  

  $('#schools_navbar').on('click', (evt) => {
    $('#schools_navbar').addClass('active');
    $('#navbarMeetMenuLink').removeClass('active');
    $('#athletes_navbar').removeClass('active');
  });  

  $('#athletes_navbar').on('click', (evt) => {
    $('#athletes_navbar').addClass('active');
    $('#navbarMeetMenuLink').removeClass('active');
    $('#school_navbar').removeClass('active');
  });  


})

//   $('#schools_navbar').


//     )

// $('#athletes_navbar')
// })