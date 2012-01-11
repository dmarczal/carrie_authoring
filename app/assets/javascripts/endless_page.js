$(document).ready(function () {
  $(window).scroll(function (){
     url = $('.pagination .next a').attr('href');
     if (url && ($(window).scrollTop() > ($(document).height() - $(window).height() - 50))) {
        $('.pagination').text("Fetching more products...")
        $.getScript(url);
     }
  });
});

//var currentPage = 1;
//alert("oi");
//
//function checkScroll() {
//  if (nearBottomOfPage()) {
//    currentPage++;
//    new Ajax.Request('/products.js?page=' + currentPage, {asynchronous:true, evalScripts:true, method:'get'});
//  } else {
//    setTimeout("checkScroll()", 250);
//  }
//}
//
//function nearBottomOfPage() {
//  return scrollDistanceFromBottom() < 150;
//}
//
//function scrollDistanceFromBottom(argument) {
//  return pageHeight() - (window.pageYOffset + self.innerHeight);
//}
//
//function pageHeight() {
//  return Math.max(document.body.scrollHeight, document.body.offsetHeight);
//}
//
//document.observe('dom:loaded', checkScroll);
