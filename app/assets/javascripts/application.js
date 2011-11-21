//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require lsystem/lsystems
//= require lsystem/jquery.lsystem
//= require cluetip/jquery.cluetip.all.min.js
//= require_self

//= require exercises

$(document).ready(function() {
  function request_info (){
    this.controller = $('body').attr('data-controller');
    this.action = $('body').attr('data-action');
  }
  window.request = new request_info();
});
