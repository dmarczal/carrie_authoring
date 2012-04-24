// Exercises Controller

$(document).ready(function() {

    if (request.controller == "exercises") {
       if (request.action == "show") {
          show_exercise();
       } else if (request.action == "new" || request.action === "create") {
          observe_fields();
       } else if (request.action == "edit" || request.action == "update" ) {
          observe_fields();
       } else if (request.action == "show_questions") {
          $('#sortable').sortable({
            axis: 'y',
            update: function(event, ui) {
                $.post($(this).data('update-url'),
                   { learning_object_id: $(this).data('oa-id'), id: $(this).data('exercise-id'),
                    'question' : $(this).sortable('toArray') });
             }
          });
          $('#sortable').disableSelection();
      }
  }
});

var observe_fields = function () {
  var rules = toText($('.rules').attr('value'));
  $("#exercise_fractal_exercise_rules").val(rules);
  $("select").bind('change', function() {
    $.getJSON('/fractals/'+$("select").val(), function(data) {
      $("#exercise_fractal_exercise_name").val(data.name);
      $("#exercise_fractal_exercise_angle").val(data.angle);
      $("#exercise_fractal_exercise_constant").val(data.constant);
      $("#exercise_fractal_exercise_axiom").val(data.axiom);
      $("#exercise_fractal_exercise_rules").val(data.rules);

      loadPreview();
      $(".hidden-fields").show();
    });
  });

  loadPreview();

  $("input").bind('keyup', function() {
    loadPreview();
  });

  function loadPreview(){
    var frac = Fractal.create({name: $('#exercise_fractal_exercise_name').val(),
                            axiom: $('#exercise_fractal_exercise_axiom').val(),
                            constant: $('#exercise_fractal_exercise_constant').val(),
                            angle:  $('#exercise_fractal_exercise_angle').val(),
                            rules: rules_to_array($('#exercise_fractal_exercise_rules').val()),
                            height: $('#exercise_fractal_exercise_height').val(),
                            width: $('#exercise_fractal_exercise_width').val()});
     FractalPreview.create({fractal: frac, iterations: 3}).load();
  }
};

var show_exercise = function () {
    var exercTable = $('#exercise_table');

    var exercise = Exercise.create({table:     exercTable,
                                    id:        $(exercTable).data('id'),
                                    fractal:   $(exercTable).data('fractal'),
                                    questions: $(exercTable).data('questions'),
                                    last_answers: $(exercTable).data('last-answers'),
                                    oaId:     $(exercTable).data('oa-id')
                                   });
    exercise.loadTable();

    // Resize the fractal
    if (request.namespace !== "published") {
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
    }

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
    this.last_answers = data.last_answers;
    this.oaId = data.oaId;
    var that = this;

    var getId = function () { return that.id; };
    var getOaId = function () { return that.oaId; };

    var getFractal = function () { return that.fractal; };
    var getTable = function () { return that.table; };

    var loadTable = function () {
       var fracCanvas = Fractal.create(that.fractal);
       var i;
       for (i = 0; i < that.fractal.iterations; i++) {
          var row = $('<tr>');
          var iteration = $('<td width="100">' + i + '</td>');
          var tdTag = $('<td class="fractal" width='+ that.fractal.width +' ">');

          var fracResizable= $('<div class="resizable">').append(fracCanvas.nextIteration())
                                .css('width', that.fractal.width + 8)
                                .css('height', that.fractal.height + 8);

          tdTag.append(fracResizable);
          row.append(iteration, tdTag);

          createQuestions(row, i);
          $(that.table).append(row);
       }
       if (that.fractal.infinite) {
          var row = $('<tr>');
          var iterationN = $('<td width="100"> N </td>');
          var tdTag = $('<td class="fractal" width='+ that.fractal.width +' "> Figura limite </td>')
             .css('height', that.fractal.height + 8);
          row.append(iterationN, tdTag);
          createQuestions(row, i);
          $(that.table).append(row);
       }
    };

    /*
     * Create the questions
     * some questions can have set answers define by attribute ask
     */
    var createQuestions = function (row, index) {
       for(var i = 0; i < that.questions.length; i++){
          var answer = that.questions.questions[i].answers[index];

          var td = $('<td data-row=' + index +' data-col=' + new Number(i+2) +' data-answer-id="'+ answer.id +'">');

          if (answer.ask === false) {
             $(td).html(answer.response);
          } else {
             $(td).addClass("calculator");

             if (that.last_answers !== null && that.last_answers !== undefined ) {
                var last_answer = that.last_answers[i][index];
                if (last_answer.hasOwnProperty("response")) {
                   setAnswer(last_answer.response, last_answer.correct, td, "$"+last_answer.response+"$");
                 }
             }
          }
          row.append(td);
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

/*
var row;
var col;
var openDialog = function(element) {
  row = element.data('row');
  col = element.data('col');
  formula = "";
  $("#dialog-calc" ).dialog( "open");
}
*/
