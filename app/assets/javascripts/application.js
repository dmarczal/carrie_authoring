//= require jquery
//= require jquery-ui
//= require jquery_ujs

//= require twitter/bootstrap
//= require jquery/jquery.tablesorter
//= require jquery/jquery.dragtable
//= require jquery/jquery.tablesorter.js

//= require lsystem/lsystems
//= require lsystem/jquery.lsystem
//= require lsystem/jquery.observe_field

//= require_self

//= require fractal
//= require endless_page
//= require exercises
//= require learning_objects
//= require learning_groups

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

  //$('.best_in_place').bind("ajax:success", function () {}
});


function remove_fields(link) {
	console.log($(link));
	$(link).previous("input[type=hidden]").value = 1;
	$(link).up("fields").hide();
}

