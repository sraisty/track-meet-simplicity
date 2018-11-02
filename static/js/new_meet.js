"use strict";

$(document).ready(function() {

  $('#meet-date').datepicker({
        uiLibrary: 'bootstrap4'
      });


  // https://github.com/johnny/jquery-sortable
  $("#meet-eventlist").sortable();

  $("#meet-divlist").sortable();

  var group = $(".meet-ordered-list.serialization").sortable({
    group: 'serialization',
    delay: 500,
    onDrop: function ($item, container, _super) {
      var data = group.sortable("serialize").get();

      var jsonString = JSON.stringify(data, null, ' ');

      $('#serialize_output2').text(jsonString);
      _super($item, container);
    }
  });

});
