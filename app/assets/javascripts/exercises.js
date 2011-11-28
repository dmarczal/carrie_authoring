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
    dragableColumns();
  }

  /*
   * Create a table with fractal and questions
   */
  function createTable() {

    for (var i = 0; i < exercise.fractal.iterations; i++) {
      var row = $('<tr>');
      var iteration = $('<td>' + i + '</td>');
      var fracCell = $('<td class="fractal">');

      createQuestions(row, exercise.questions);
      $(exercise.table).append(row);

      fracCell.append(createFractal(i, exercise.fractal));
      row.append(iteration, fracCell);
    }
  }

  function createQuestions(row, questions){
     for(var q = 0; q < questions; q++){
       var side = $('<td>');
       row.append(side)
     }
  }

  function dragableColumns(){
    //     $('table').dragtable({
    //		change:function(e,ui){
    //			console.info('widget option change callback triggered');
    //			console.log(ui);
    //		},
    //		displayHelper: function(e,ui){
    //			console.log(ui);
    //			ui.draggable.append('<span>I was added<br>in the callback</span>')
    //		}
    //	});
        //register_event_mouse_over(obj);
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
      $(this).popover();
    });
  }
});

function fractalCallback(object, value, settings) {
  var key = value.trim().toLowerCase().replace(/\s+/g, '-');

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

function createFractal(i, fractal){
  var canvas = createFracCanvas(i, fractal);
  return $('<div class="resizable">').append(canvas)
    .css('width', fractal.width + 8)
    .css('height', fractal.height + 8)
}

function createFracCanvas(i, fractal){
  var canvas = $('<canvas id="canvas_'+ i +'" width="'+ fractal.width +'" height="'+ fractal.height +'" />')
    canvas.lsystem(i, fractal.angle, "", fractal.axiom, fractal.rules);
  return canvas;
}
