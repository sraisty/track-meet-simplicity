 // From: https://bootsnipp.com/snippets/ZXPqz
 
 //Initialize tooltips
 $('.nav-tabs > li a[title]').tooltip();

 //Wizard
 $('a[data-toggle="tab"]').on('show.bs.tab', function (e) {

     var $target = $(e.target);

     if ($target.hasClass('disabled')) {
         return false;
     }
 });

 $(".next-step").click(function (e) {
     var $active = $('.wizard .nav-tabs .nav-item .active');
     var $activeli = $active.parent("li");

     $($activeli).next().find('a[data-toggle="tab"]').removeClass("disabled");
     $($activeli).next().find('a[data-toggle="tab"]').click();
 });


 $(".prev-step").click(function (e) {

     var $active = $('.wizard .nav-tabs .nav-item .active');
     var $activeli = $active.parent("li");

     $($activeli).prev().find('a[data-toggle="tab"]').removeClass("disabled");
     $($activeli).prev().find('a[data-toggle="tab"]').click();

 });
