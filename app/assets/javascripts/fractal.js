var $j = jQuery.noConflict();

$j(document).ready(function() {
    // Executes a callback detecting changes with a frequency of 1 second

    var f = new Fractal(null, null, null, null, 128, 128);
    $j("input").observe_field(1, function( ) {
      if (this.id == 'fractal_axiom') f.setAxiom(this.value);
      if (this.id == 'fractal_rules') f.setRules(replaceAll(this.value, ' ', '').split(','));
      if (this.id == 'fractal_angle') f.setAngle(this.value);
      f.genPreview();
      console.log(this.id + " " + this.value);
    });

  if (request.controller == "fractals" && request.action == "index"){

    $j("td.fractal").each(function (){
      var fractalJSON = $j(this).data("fractal");
      fractalJSON.width=64;
      fractalJSON.height=64;

      for (var i = 0; i < 3; i++) {
        var fractal = createFracCanvas(i, fractalJSON);
        $j(this).append(fractal);
      };
    });
  }
});

function replaceAll(string, token, newtoken) {
  var regexp = new RegExp("/"+token+"/g");
  var string = string.replace( regexp, newtoken )
  return string;
}

function createFractalDiv(i, fractal){
  var canvas = createFracCanvas(i, fractal);
  return $j('<div class="fractal">').append(canvas);
}

function createFractalResizable(i, fractal){
  var canvas = createFracCanvas(i, fractal);
  return $j('<div class="resizable">').append(canvas)
    .css('width', fractal.width + 8)
    .css('height', fractal.height + 8)
}

function createFracCanvas(i, fractal){
  var canvas = $j('<canvas id="canvas_'+ i +'" width="'+ fractal.width +'" height="'+ fractal.height +'" />')
    canvas.lsystem(i, fractal.angle, "", fractal.axiom, fractal.rules);
  return canvas;
}

var Fractal = Class.create(LSystems, {
  initialize:  function(name, angle, axiom, rules, width, height) {
    this.setName(name);
    this.setAngle(angle);
    this.setAxiom(axiom);
    this.rules = new Array();
    this.setRules(rules);
    this.setWidth(width);
    this.setHeight(height);
    this.it = 0;
  },

  iterate: function() {
    var row = $j('<tr>');
    var iteration = $j('<td>' + this.getIteration() + '</td>');
    var fractal = $j('<td>');
    var canvas = $j('<canvas id="canvas_' + this.getName() + '_' + this.getIteration() + 
          '" width="' + this.getWidth()  +'" height="' + this.getHeight() + '" />');
    row.append(iteration, fractal);
    $j('table').append(row);
    fractal.append(canvas);
    canvas.lsystem(this.getIteration(), this.getAngle(), "", this.getAxiom(), this.getRules());
    
    this.it++;

  },

  buildPreview: function() {
    var row = $j('<tr id="preview">');

    console.log(this);
    for (i=0; i<3; i++) {
      var fractal = $j("<td>");
      var canvas = $j('<canvas id="canvas_' + this.getName() + '_' + this.getIteration() + 
          '" width="' + this.getWidth()  +'" height="' + this.getHeight() + '" />');
      row.append(fractal);
      fractal.append(canvas);
      canvas.lsystem(i, this.getAngle(), "", this.getAxiom(), this.getRules());
    }
    $j('table tr:#preview').remove();
    $j('table').append(row);
  },
  genPreview: function() {
    if (this.getAngle() != null &&
        this.getAxiom() != null && 
        this.getRules() != null) {
          try {
            this.buildPreview()
          } catch (e) {
              console.log(e);
          }
        }
  },

  setName:  function(name) {
    this.name = name;
  },
  
  setAngle: function(angle) {
    this.angle = new Number(angle);
  },

  setAxiom: function(axiom) {
    this.axiom = axiom;
  },
  
  setRules: function(rules) {
    this.rules = rules;
  },

  setWidth: function(width) {
    this.width = width;
  },

  setHeight: function(height) {
    this.height = height;
  },

  getName: function() {
    return this.name;
  },

  getAngle: function() {
    return this.angle;
  },

  getAxiom: function() {
    return this.axiom;
  },

  getRules: function() {
    return this.rules;
  },

  getWidth: function() {
    return this.width
  },

  getHeight: function() {
    return this.height;
  },
    
  getIteration: function() {
    return this.it;
  }

});

function teste(a) {
  console.log(a);
}
