$(document).ready(function () {

   if ($('.pagination').length > 0) {
      $(window).scroll(function (){
         url = $('.pagination .next a').attr('href');
         if (url && ($(window).scrollTop() > ($(document).height() - $(window).height() - 50))) {
            $('.pagination').text("Fetching more products...")
         $.getScript(url);
         }
      });
      $(window).scroll();
   }

});
