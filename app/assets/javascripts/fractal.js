$(document).ready(function() {
  if (request.controller == "fractals" && request.action == "index"){

    $("td.fractal").each(function (){
      var fractalJSON = $(this).data("fractal");
      fractalJSON.width=64;
      fractalJSON.height=64;

      for (var i = 0; i < 3; i++) {
        var fractal = createFracCanvas(i, fractalJSON);
        $(this).append(fractal);
      };
    });
  }
});

function createFractalDiv(i, fractal){
  var canvas = createFracCanvas(i, fractal);
  return $('<div class="fractal">').append(canvas);
}

function createFractalResizable(i, fractal){
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
