//= require jquery
//= require jquery-ui
//= require jquery_ujs

//= require twitter/bootstrap
//= require jquery/jquery-ui-1.8.16.custom.min
//= require jquery/jquery.dragtable
//= require jquery/jquery.tablesorter
//= require jquery/jquery.tokeninput

//= require util
//= require lsystem/lsystems
//= require lsystem/jquery.lsystem
//= require lsystem/jquery.observe_field

//= require_self

//= require fractal
//= require endless_page
//= require exercises
//= require learning_objects
//= require learning_groups
//= require questions

//= require jquery.purr
//= require best_in_place

//= require published/fractals

//= require calculator/calculator
//= require ckeditor/init

$(document).ready(function() {
  function request_info (){
    this.controller = $('body').attr('data-controller');
    this.action = $('body').attr('data-action');
    this.url = $('body').attr('data-url');
    this.namespace = $('body').attr('data-namespace');
  }
  window.request = new request_info();

  $('.best_in_place').best_in_place();

// $('.best_in_place').bind("ajax:success", function () {}
//  $(".alert-message").alert()
  $(".tabs").button()
//  $(".carousel").carousel()
//  $(".collapse").collapse()
//  $(".dropdown-toggle").dropdown()
    $(".modal").modal
//  $("a[rel]").popover
//  $(".navbar").scrollspy()
//  $(".tooltip").tooltip
//  $(".typeahead").typeahead()
});
