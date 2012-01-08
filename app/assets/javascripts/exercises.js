// Exercises Controller
$(document).ready(function() {
    if (request.controller == "exercises") {
       if (request.action == "show") {
          show_exercise();
       } else if (request.action == "new") {
          render_fractal();
       }
    }
});

var render_fractal = function () {
  $("select").bind('change', function() {
    console.log("Preview fractal");
  });
};

var show_exercise = function () {
    var exercTable = $('#exercise_table');

    var exercise = Exercise.create({table:     exercTable,
                                    id:        $(exercTable).data('id'),
                                    fractal:   $(exercTable).data('fractal'),
                                    questions: $(exercTable).data('questions'),
                                    oaId:     $(exercTable).data('oa-id')
                                   });
    exercise.loadTable();

    // Resize the fractal
    ( function () {
       $(".resizable").resizable({ aspectRatio: 1,
          helper: "ui-resizable-helper",
          stop: function(event, ui) {
              $("canvas", this).each(function() {
                 exercise.getFractal().width= ui.size.width;
                 exercise.getFractal().height= ui.size.height;

                 $.post($(exercise.getTable()).attr('fractal-update-url'),
                    {id: exercise.getId(), oa_id: exercise.getOaId(),
                     width: ui.size.width, height: ui.size.height},
                     function (data) {
                        reloadFractal();
                     }
                 );
          });
        }
      });
    })();

    var reloadFractal = function () {
        fracCanvas = Fractal.create(exercise.getFractal());
        $('.resizable').each( function (index, value){
            $(this).find('canvas').remove();
            $(this).css('width', exercise.getFractal().width + 8)
                  .css('height', exercise.getFractal().height + 8)
          $(this).append(fracCanvas.nextIteration());
        });
    };

    // Mouse Over Event
    (function () {
       $(exercise.getTable()).find("th").each(function (index, element){
          if (index !== 0 && index !== 1){
             $(this).popover();
          }
       });
    })();
};

var Exercise = Exercise || {
  create: function(data) {
    this.id = data.id;
    this.table = data.table;
    this.fractal = data.fractal;
    this.questions = data.questions;
    this.oaId = data.oaId;
    var that = this;

    var getId = function () { return that.id; };
    var getOaId = function () { return that.oaId; };

    var getFractal = function () { return that.fractal; };
    var getTable = function () { return that.table; };

    var loadTable = function () {
       fracCanvas = Fractal.create(that.fractal);
       for (var i = 0; i < that.fractal.iterations; i++) {
          var row = $('<tr>');
          var iteration = $('<td width="100">' + i + '</td>');
          var tdTag = $('<td class="fractal" width='+ that.fractal.width +' ">');

          var fracResizable= $('<div class="resizable">').append(fracCanvas.nextIteration())
                                .css('width', that.fractal.width + 8)
                                .css('height', that.fractal.height + 8);

          tdTag.append(fracResizable);
          row.append(iteration, tdTag);

          createQuestions(row);
          $(that.table).append(row);
       }
    };

    var createQuestions = function (row) {
       for(var i = 0; i < that.questions.length; i++){
          row.append($('<td>'));
       }
    };

    return {
       getId: getId,
       loadTable: loadTable,
       getFractal: getFractal,
       getId: getId,
       getOaId: getOaId,
       getTable: getTable,
    };
  }
};
