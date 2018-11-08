/* Put Flash Messages In a Modal */

$(document).ready(function() {
    let messages = "{{ get_flashed_message() }}";

    if (typeof messages != "undefined" && messages != '[]') {
        $("#flashMessageModal").modal();
    };

});
