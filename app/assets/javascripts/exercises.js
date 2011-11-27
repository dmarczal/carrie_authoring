// Exercises Controller
$(document).ready(function() {
  if (request.controller == "exercises" && request.action == "show"){

    var table = $('#exercise_table');

    var fractal = jQuery.parseJSON($(table).attr('data-fractal'));
    var questions = jQuery.parseJSON($(table).attr('data-questions'));


    createTable(table, fractal, questions);

    resizableFractal(fractal);

    dragableColumns();
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

  function resizableFractal(fractal){
    $(".resizable").resizable({ aspectRatio: 1, helper: "ui-resizable-helper", stop: function(event, ui) {
      $("canvas", this).each(function() {
        fractal.width= ui.size.width;
        fractal.height= ui.size.height;

        $.post($(table).attr('data-fractal-update-url'),
          {id: fractal._id ,width: ui.size.width, height: ui.size.height},
          function (data) {
            $('.resizable').each( function (index, value){
              $(this).find('canvas').remove();
              $(this).css('width', fractal.width + 8)
              .css('height', fractal.height + 8)

              $(this).append(createFracCanvas(index, fractal));
            });
          }
          );
      });
    }
    });
  }

  /*
   * Create a table with fractal and questions
   */
  function createTable(table, fractal, questions) {

    for (var i = 0; i < fractal.iterations; i++) {
      var row = $('<tr>');
      var iteration = $('<td>' + i + '</td>');
      var fracCell = $('<td class="fractal">');

      createQuestions(row, questions);
      $(table).append(row);

      fracCell.append(createFractal(i, fractal));
      row.append(iteration, fracCell);
    }
  }

  function createQuestions(row, questions){
     for(var q = 0; q < questions; q++){
       var side = $('<td>');
       row.append(side)
     }
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

  function register_event_mouse_over(obj){
    $(obj).find("th").each(function (index, element){
      $(this).popover();
    });
  }
});
