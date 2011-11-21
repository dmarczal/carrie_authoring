// Exercises

$(document).ready(function() {

  if (request.controller == "exercises" && request.action == "show"){
    var table = $('#div_table_exercise table:first-child');
    var iterations = parseInt($('#div_table_exercise').attr('data-iterations'));

    var questions = parseInt($('#div_table_exercise').attr('data-questions'));
    create_table(table, iterations, questions);


    $("#div_table_exercise table:first-child th").each(function (index, element){
      var th = $(this).attr('title')
      if (th != undefined){
        $(this).cluetip({splitTitle: '|'})
      }
    });
  }

  function create_table(table, iterations, questions) {
    for (var i = 0; i < iterations; i++) {
      var row = $('<tr>');
      var iteration = $('<td>' + i + '</td>');
      var fractal = $('<td>');
      var canvas = $('<canvas id="canvas_' + i + '" width="128" height="128" />')
      row.append(iteration, fractal);

      for(var q = 0; q < questions; q++){
        var side = $('<td>');
        row.append(side)
      }

      $(table).append(row);
      fractal.append(canvas);

      // Koch Curve
      // canvas.lsystem(i, 90, "", "-F", ["F=F+F-F-F+F"]);
      // Sierpinski triangle (triangles)
      canvas.lsystem(i, 120, "", "F-G-G", ["F=F-G+F+G-F", "G=GG"]);
      // Koch Snowflake
      // canvas.lsystem(i, 60, "X", "F++F++F", ["F=F-F++F-F", "X=FF"]);
    }

    $(table, " tr:nth-child(odd)").addClass("odd-row");
    $(table, " td:first-child, table th:first-child").addClass("first");
    $(table, " rtd:last-child, table th:last-child").addClass("last");
  }
});
