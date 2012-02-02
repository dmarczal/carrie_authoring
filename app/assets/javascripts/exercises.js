// Exercises Controller

$(document).ready(function() {

    if (request.controller == "exercises") {
       if (request.action == "show") {

          $("#dialog-calc").hide();
          $("#dialog:ui-dialog" ).dialog( "destroy" );
          $("#dialog-calc" ).dialog({
            autoOpen: false,
            height: 410,
            width: 480,
            modal: true,
            resizable: false, /*,
            buttons: {
              "OK" : function() {
                $(this).dialog("close");
              }
            }*/
            close: function() {
              $("input.input").val("");
            }
          });
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

    $(".toggle_fractal").click(function(){
       console.log('oi');
       $(".hidden-fields").toggle();
    });
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

/*var create_preview =  function () {
   var frac = Fractal.create({name: $('#exercise_fractal_exercise_name').val(),
                              axiom: $('#exercise_fractal_exercise_axiom').val(),
                              constant: $('#exercise_fractal_exercise_constant').val(),
                              angle:  $('#exercise_fractal_exercise_angle').val(),
                              rules: rules_to_array($('#exercise_fractal_exercise_rules').val()),
                              height: $('#exercise_fractal_exercise_height').val(),
                              width: $('#exercise_fractal_exercise_width').val()});
   //loadPreview(frac);
   create_action.loadPreview(frac);

   $("input").observe_field(1, function() {
      console.log(this);
      if (this.id == 'exercise_fractal_exercise_name') frac.setName(this.value);
      if (this.id == 'exercise_fractal_exercise_axiom') frac.setAxiom(this.value);
      if (this.id == 'exercise_fractal_exercise_rules') frac.setRules(rules_to_array(this.value));
      if (this.id == 'exercise_fractal_exercise_angle') frac.setAngle(this.value);
      if (this.id == 'exercise_fractal_exercise_width') frac.setWidth(this.value);
      if (this.id == 'exercise_fractal_exercise_height') frac.setHeight(this.value);

      frac.setIteration(0);
      create_action.loadPreview(frac);
   });
}; */

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
    this.oaId = data.oaId;
    var that = this;

    var getId = function () { return that.id; };
    var getOaId = function () { return that.oaId; };

    var getFractal = function () { return that.fractal; };
    var getTable = function () { return that.table; };

    var loadTable = function () {
       fracCanvas = Fractal.create(that.fractal);
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

    var createQuestions = function (row, index) {
       for(var i = 0; i < that.questions.length; i++){
          row.append($('<td data-row=' + index +' data-col=' + new Number(i+2) +' onClick="openDialog($(this))" >'));
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


var row;
var col;
var openDialog = function(element) {
  row = element.data('row');
  col = element.data('col');
  formula = "";
  $("#dialog-calc" ).dialog( "open");

}
