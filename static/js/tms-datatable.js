"use strict";

$(document).ready(function() {

    /// Tables listing MDE entrants
    $('#mde_table').DataTable({
        'ordering': true
    });

    //// Tables that list Athletes 


    // // $('#all_athlete_table').DataTable({
    // //     'ordering': true
    // // });

    $('#athlete_list').DataTable({
        'ordering': true
    });

    $('#school-athletes-table').DataTable({
        'ordering': true
    });


    $('#meet-athlete-list').DataTable({
        'ordering': true
    });

    //// Tables that list meets

    $('#all-meets-list').DataTable({
        'ordering': true
    });

    // $('#meet_table').DataTable({
    //     'ordering': true
    // });

    $('#hosted-meets-list').DataTable({
        'ordering': true
    });

    $('#entered-meets-list').DataTable({
        'ordering': true
    });

    $('#athlete-meets-table').DataTable({
        'ordering': true
    });

    //// Tables that list schools
    $('#all_schools_table').DataTable({
        'ordering': true
    });

   $('#meet-school-list').DataTable({
        'ordering': true
    });

});
    
