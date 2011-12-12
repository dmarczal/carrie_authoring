// Exercises Controller


$(document).ready(function() {
  if (request.controller == "exercises" && request.action == "show"){

    var Exercise = function(table, fractal, questions){
      this.table = table;
      this.fractal = fractal;
      this.questions = questions;
    }

    window.exercise = new Exercise($('#exercise_table'),
                                jQuery.parseJSON($($('#exercise_table')).attr('data-fractal')),
                                jQuery.parseJSON($($('#exercise_table')).attr('data-questions')));

    createTable();
    resizableFractal();
    register_event_mouse_over();
    //dragableColumns();
  }

  /*
   * Create a table with fractal and questions
   */
  function createTable() {

    for (var i = 0; i < exercise.fractal.iterations; i++) {
      var row = $('<tr>');
      var iteration = $('<td width="10">' + i + '</td>');
      var fracCell = $('<td class="fractal" width='+exercise.fractal.width +'; ">');

      fracCell.append(createFractalResizable(i, exercise.fractal));
      row.append(iteration, fracCell);

      createQuestions(row);
      $(exercise.table).append(row);
    }
    var row = $('<tr>');
    row.append("<td> n </td>");
    row.append("<td> Limite da Figura </td>");
    createQuestions(row);
    $(exercise.table).append(row);
  }

  function createQuestions(row){
    for(var q = 0; q < exercise.questions.length; q++){
       row.append($('<td>'));
     }
  }

  function dragableColumns(){
         $(exercise.table).dragtable({
    		change:function(e,ui){
    			console.info('widget option change callback triggered');
    			console.log(ui);
    		},
    		displayHelper: function(e,ui){
    			console.log(ui);
    			ui.draggable.append('<span>I was added<br>in the callback</span>')
    		}
    	});
  }


  function resizableFractal(){
    $(".resizable").resizable({ aspectRatio: 1, helper: "ui-resizable-helper", stop: function(event, ui) {
        $("canvas", this).each(function() {
            exercise.fractal.width= ui.size.width;
            exercise.fractal.height= ui.size.height;

            $.post($(exercise.table).attr('data-fractal-update-url'),
              {id: exercise.fractal._id, width: ui.size.width, height: ui.size.height},
              function (data) {
                reloadFractal();
              }
            );
         });
      }
    });
  }

  function register_event_mouse_over() {
    $(exercise.table).find("th").each(function (index, element){
      if (index !== 0 && index !== 1){
         $(this).popover();
      }
    });
  }
});

function fractalCallback(object, value, settings) {
  var key = value.trim().toLowerCase().replace(/\s/g, '-');

  $.getJSON('/fractals/'+ key, function(data){
    exercise.fractal = data;
    reloadFractal();
  });
}

function reloadFractal(){
  $('.resizable').each( function (index, value){
    $(this).find('canvas').remove();
    $(this).css('width', exercise.fractal.width + 8)
    .css('height', exercise.fractal.height + 8)

    $(this).append(createFracCanvas(index, exercise.fractal));
  });
}
