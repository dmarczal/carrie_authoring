//= require jquery
//= require jquery-ui
//= require jquery_ujs

//= require twitter/bootstrap
//= require jquery.tablesorter
//= require jquery.dragtable

//= require lsystem/lsystems
//= require lsystem/jquery.lsystem

// require on_the_spot
//= require_self

//= require fractal
//= require exercises
//= require learning_objects

//= require jquery.purr
//= require best_in_place

$(document).ready(function() {
  function request_info (){
    this.controller = $('body').attr('data-controller');
    this.action = $('body').attr('data-action');
    this.url = $('body').attr('data-url');
  }
  window.request = new request_info();

  $('.best_in_place').best_in_place();
});
