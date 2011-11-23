//= require jquery
//= require jquery-ui
//= require jquery_ujs

//= require twitter/bootstrap
//= require jquery.tablesorter

//= require lsystem/lsystems
//= require lsystem/jquery.lsystem

//= require on_the_spot
//= require_self

//= require exercises
//= require learning_objects

$(document).ready(function() {
  function request_info (){
    this.controller = $('body').attr('data-controller');
    this.action = $('body').attr('data-action');
  }
  window.request = new request_info();

  /** Navigation active **/
  $("#navigation > ul > li > a ").parent().removeClass("active");
  if (request.controller == "site")
    $("#navigation > ul > li > a[href='/']").parent().addClass("active");
  else
    $("#navigation > ul > li > a[href *='" + request.controller + "']").parent().addClass("active");
});
