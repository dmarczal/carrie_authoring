// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(function() {

    if (request.namespace === "published" && request.controller === "fractals") {
       if (request.action == "show" && $('.exercise').size() !== 0) {
          show_exercise();
       }
    }

});
