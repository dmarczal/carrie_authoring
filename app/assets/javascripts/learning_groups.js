// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.i

$(function() {
	$("#learning_group_learning_object_tokens").tokenInput("/learning_objects.json", {
		crossDomain: false,
		prePopulate: $("#learning_object_tokens").data("pre"),
		preventDuplicates: true,
		theme: "facebook"
	});

	$("a.load").bind("ajax:success",
	function(evt, data, status, xhr){
		$("div.loading").hide();
	}).bind("ajax:error", function(evt, data, status, xhr){
		alert('Error');
	}).bind("ajax:before", function(evt, data, status, xhr){
		$("div.loading").show();
	});

});
