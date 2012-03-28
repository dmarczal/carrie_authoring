$(document).ready(function() {
  if (request.controller == "learning_objects") {

    $("#exercises").sortable({
       axis: 'y',
       handle: '.handle',
       update: function(event, ui) {
          $.post($(this).data('update-url'), { 'exercise' : $(this).sortable('toArray') });
       }
    });

    $("#introductions").sortable({
       axis: 'y',
       handle: '.handle',
       update: function(event, ui) {
          $.post($(this).data('update-url'), { 'introduction' : $(this).sortable('toArray') });
       }
    });
  }
});
