$(document).ready(function() {
  if (request.controller == "learning_objects") {

    if (request.action == "index"){
        $("#learning_objects").tablesorter({ sortList: [[0,1]], headers: {
            2: { sorter: false },
            3: { sorter: false },
            4: { sorter: false }
         }});
    }

    $("#exercises").sortable({
       axis: 'y',
       handle: '.handle',
       update: function(event, ui) {
          $.post($(this).data('update-url'), { 'exercise' : $(this).sortable('toArray') });
       }
    });

  }
});
