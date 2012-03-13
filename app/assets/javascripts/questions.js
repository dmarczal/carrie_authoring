$(document).ready(function() {

  var answersTable = $('#answers-table');

  if (answersTable.length > 0) {
     var frac = Fractal.create(answersTable.data('fractal'));

     answersTable.find("td.fractal").each(function (i, obj){
        $(obj).html(frac.nextIteration());
        $(obj).width(frac.getWidth());
     });

     if (frac.hasInfinite() === true) {
        var infinite = answersTable.find("tr:last");
        var tds = $(infinite).find("td");
        $(tds[0]).html("N");
        $(tds[1]).html("Figura Limite");
     }
  }
});
