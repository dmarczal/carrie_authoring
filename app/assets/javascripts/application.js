//= require jquery
//= require jquery-ui
//= require jquery_ujs

//= require twitter/bootstrap
//= require jquery.tablesorter
//= require jquery.dragtable

//= require lsystem/prototype
//= require lsystem/lsystems
//= require lsystem/jquery.lsystem
//= require lsystem/jquery.observe_field

// require on_the_spot
//= require_self

//= require fractal
//= require exercises
//= require learning_objects

//= require jquery.purr
//= require best_in_place

$j = jQuery.noConflict();

$j(document).ready(function() {
  function request_info (){
    this.controller = $j('body').attr('data-controller');
    this.action = $j('body').attr('data-action');
    this.url = $j('body').attr('data-url');
  }
  window.request = new request_info();

  $j('.best_in_place').best_in_place();

  //$('.best_in_place').bind("ajax:success", function () {}
});
