$j = jQuery.noConflict();

$j(document).ready(function() {
  if (request.controller == "learning_objects") {

    if (request.action == "index"){
        $j("#learning_objects").tablesorter({ sortList: [[0,1]], headers: {
            2: { sorter: false },
            3: { sorter: false },
            4: { sorter: false }
         }});
    }

    $j("#exercises").sortable({
       axis: 'y',
       handle: '.handle',
       update: function(event, ui) {
          $j.post($j(this).data('update-url'), { 'exercise' : $j(this).sortable('toArray') });
       }
    });

  }
});
