$('#meet_table').DataTable({
    'ordering': true
});

// $('#all_athlete_table').DataTable({
//     'ordering': true
// });

$('#school_table').DataTable({
    'ordering': true
});

$('#mde_table').DataTable({
    'ordering': true
});


$(document).ready(function() {
    $('#athlete_table').DataTable( {
        initComplete: function () {
            this.api().columns().every( function () {
                let column = this;
                let select = $('<select><option value=""></option></select>')
                    .appendTo( $(column.footer()).empty() )
                    .on( 'change', function () {
                        var val = $.fn.dataTable.util.escapeRegex(
                            $(this).val()
                        );
 
                        column
                            .search( val ? '^'+val+'$' : '', true, false )
                            .draw();
                    } );
 
                column.data().unique().sort().each( function ( d, j ) {
                    select.append( '<option value="'+d+'">'+d+'</option>' )
                } );
            } );
        }
    } );
} );