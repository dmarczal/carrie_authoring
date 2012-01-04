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

  $('.best_in_place').bind("ajax:success", function () {

    if ($(this).hasClass('inline_key')) {

      // Need redefined id of the model
      url_split = window.location.toString().split('/');
      old_id = url_split[url_split.length-1];
      new_id = $(this).text().trim().toLowerCase().replace(/(\s+-\s+)|(\s)/g, '-');

      url = $(this).attr('data-url');
      obj_id = $(this).attr('id');

      $(this).attr('data-url', url.replace(old_id, new_id));
      $(this).attr('id', url.replace(old_id, new_id));

      jQuery(this).data('bestInPlaceEditor').initOptions();
    }
  });
});
