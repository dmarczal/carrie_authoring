// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.i

$(function() {
  $("#learning_group_learning_object_tokens").tokenInput("/learning_objects.json", {
    crossDomain: false,
    prePopulate: $("#learning_object_tokens").data("pre"),
    preventDuplicates: true,
    theme: "facebook"
  });
});
