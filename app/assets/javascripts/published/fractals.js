// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Published Fractal

$(document).ready(function() {

   if (request.namespace === "published" && request.controller === "fractals") {
      if ($('.exercise').size() !== 0 && (request.action === "show" || request.action === "preview")) {
         show_exercise();
      }
   }

});
