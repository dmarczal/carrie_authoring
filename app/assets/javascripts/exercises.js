// Exercises Controller
$(document).ready(function() {
    if (request.controller == "exercises") {
       if (request.action == "show") {
          show_exercise();
       } else if (request.action == "new") {
          render_fractal();
          observe_fields();
       } else if (request.action == "edit") {
          observe_fields();
       }
    }
});

var render_fractal = function () {
  $("select").bind('change', function() {
    console.log("Preview fractal");
  });
};


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
    })
  });
  loadPreview();
  $("input").bind('keyup', function() {
    loadPreview();
  });

  function loadPreview(frac){
    var frac = Fractal.create({name: $('#exercise_fractal_exercise_name').val(),
                            axiom: $('#exercise_fractal_exercise_axiom').val(),
                            constant: $('#exercise_fractal_exercise_constant').val(),
                            angle:  $('#exercise_fractal_exercise_angle').val(),
                            rules: rules_to_array($('#exercise_fractal_exercise_rules').val()),
                            height: $('#exercise_fractal_exercise_height').val(), 
                            width: $('#exercise_fractal_exercise_width').val()});
    if (frac.isValid()) {
      var row = $('<tr id="preview">');

      for (i=0; i<3; i++) {
        var td_tag = frac.embedIn('td');
        frac.nextIteration()
        row.append(td_tag);
      }

      $('table tr:#preview').remove();
      $('table').append(row);
    }
  }
};

function toText(string) {
  string = string.replace(/^\[/, "");
  string = string.replace(/\]$/, "");
  while (string.indexOf('"') != -1) {
    string = string.replace('"', "");
  }
  return string;
}

var show_hidden_fields = function (link) {
  if ($(".hidden-fields").is(":visible")) {
    $(".hidden-fields").hide();
  } else {
    $(".hidden-fields").show();
  }
};

var create_preview =  function () {
   var frac = Fractal.create({name: $('#exercise_fractal_exercise_name').val(),
                              axiom: $('#exercise_fractal_exercise_axiom').val(),
                              constant: $('#exercise_fractal_exercise_constant').val(),
                              angle:  $('#exercise_fractal_exercise_angle').val(),
                              rules: rules_to_array($('#exercise_fractal_exercise_rules').val()),
                              height: $('#exercise_fractal_exercise_height').val(), 
                              width: $('#exercise_fractal_exercise_width').val()});
   loadPreview(frac);
   $("input").observe_field(1, function() {
      console.log(this);
      if (this.id == 'exercise_fractal_exercise_name') frac.setName(this.value);
      if (this.id == 'exercise_fractal_exercise_axiom') frac.setAxiom(this.value);
      if (this.id == 'exercise_fractal_exercise_rules') frac.setRules(rules_to_array(this.value));
      if (this.id == 'exercise_fractal_exercise_angle') frac.setAngle(this.value);
      if (this.id == 'exercise_fractal_exercise_width') frac.setWidth(this.value);
      if (this.id == 'exercise_fractal_exercise_height') frac.setHeight(this.value);

      frac.setIteration(0);
      loadPreview(frac);
   });

   function loadPreview(frac){
      if (frac.isValid()) {
        var row = $('<tr id="preview">');

        for (i=0; i<3; i++) {
           var td_tag = frac.embedIn('td');
           frac.nextIteration()
           row.append(td_tag);
        }

        $('table tr:#preview').remove();
        $('table').append(row);
      }
   }
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
