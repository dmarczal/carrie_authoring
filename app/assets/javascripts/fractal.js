$(document).ready(function() {
  if (request.controller === "fractals" && request.namespace === "") {
     if (request.action === "new" || request.action === "create"  || request.action === "edit" ){
        create_action();
     } else
         if (request.action === "index"){
            show_fractals();
         }
         else {
            if (request.action == "show") {
               show_this_fractal();
               $('#next_it').click(function(){
                  show_next_it();
               });
            }
         }
  }
});

var show_fractals = function() {
   $("td.fractal").each(function (){
     load_fractals_index(this);
   });
}

var load_fractals_index =  function (obj) {
   var fractalJSON = $(obj).data("fractal");
   fractalJSON.width=64;
   fractalJSON.height=64;
   var fractal = Fractal.create(fractalJSON);

   for (var i = 0; i < 3; i++) {
      $(obj).append(fractal.nextIteration());
   };
}


var show_this_fractal = function() {
   var fractalJSON = $("#fractal_preview").data("fractal");
   fractalJSON.width=200;
   fractalJSON.height=200;
   var frac = Fractal.create(fractalJSON);

   FractalPreview.create({fractal: frac, iterations: 6}).load();
};

var show_next_it = function() {
   var fractalJSON = $("#fractal_preview").data("fractal");
   fractalJSON.width=200;
   fractalJSON.height=200;
   var frac = Fractal.create(fractalJSON);

   var it = $(".thumbnails .span3").size();
   var ul = $(".thumbnails");
   frac.setIteration(it);
   FractalPreview.create({fractal: frac}).load_one(ul, it);
}


// Executes a callback detecting changes with a frequency of 1 second
var create_action =  function () {
   var frac = Fractal.create({name: $('#fractal_name').val(),
                              axiom: $('#fractal_axiom').val(),
                              constant: $('#fractal_constant').val(),
                              angle:  $('#fractal_angle').val(),
                              rules: rules_to_array($('#fractal_rules').val()),
                              height: 128, width: 128});

   FractalPreview.create({fractal: frac, iterations: 3}).load();

   $("input").observe_field(1, function() {

      if (this.id == 'fractal_name') frac.setName(this.value);
      if (this.id == 'fractal_axiom') frac.setAxiom(this.value);
      if (this.id == 'fractal_rules') frac.setRules(rules_to_array(this.value));
      if (this.id == 'fractal_angle') frac.setAngle(this.value);

      frac.setIteration(0);
      FractalPreview.create({fractal: frac, iterations: 3}).load();
   });

};

var FractalPreview = FractalPreview || {

   create: function(data) {
      this.frac = data.fractal;
      this.iterations = data.iterations;
      that = this;

      var load_one = function(ul, i) {
         var li = $("<li class='span3'>");
         var thumb = $("<div class='thumbnail'>");
         var caption = $("<div class='caption'>");
         caption.html("<h5>Iteração "+ i +"</h5>");
         thumb.append(that.frac.nextIteration());
         thumb.append(caption);
         li.append(thumb);
         ul.append(li);
      };

      var load = function(){
         if (that.frac.isValid()) {
            var ul = $('<ul class="thumbnails">');
            for (i=0; i < that.iterations; i++) {
                load_one(ul, i);
            }
            $('.thumbnails').remove();
            $('#fractal_preview').append(ul);
         }
      };

      return {
        load: load,
        load_one: load_one
      };
   }
}

var Fractal = Fractal || {
   create: function(data) {
      this.name = data.name;
      this.angle = new Number(data.angle);
      this.axiom = data.axiom;
      this.constant = data.constant === undefined ? "" : data.constant;
      this.rules = Array.isArray(data.rules) ? data.rules :  rules_to_array(data.rules);
      this.width = data.width;
      this.height = data.height;
      this.iteration = 0;
      this.infinite = data.infinite;
      var that = this;

      var fractal = function() {
         var canvas = $('<canvas id="canvas_' + that.name + '_' + that.iteration +
               '" width="' + that.width  +'" height="' + that.height + '" />');
         canvas.lsystem(that.iteration, that.angle, that.constant, that.axiom, that.rules);
         current = canvas;
         return canvas;
      };

      var nextIteration = function () {
         var frac = fractal();
         that.iteration++;
         return frac;
      };

      var embedIn = function(_element) {
         var element = $("<"+_element+">");
         var frac = fractal();
         element.append(frac);
         return element;
      };

      var isValid = function () {
         return (that.angle !== undefined && that.axiom !== undefined && that.rules !== undefined);
      };

      var setName = function(name) { that.name = name; return this; };
      var getName = function() { return that.name; };

      var setAxiom = function(axiom) { that.axiom = axiom; return this; };
      var getAxiom = function() { return that.axiom; };

      var setConstant = function(constant) { that.constant = constant;  return this; };
      var getConstant = function() { return that.constant; };

      var setAngle = function(angle) { that.angle = new Number(angle);  return this; };
      var getAngle = function() { return that.angle; };

      var setRules = function(rules) { that.rules = rules;  return this; };
      var getRules = function() { return that.rules; };

      var setWidth = function(witdh) { that.witdh = witdh;  return this; };
      var getWidth = function() { return that.width; };

      var setHeight = function(height) { that.height = height;  return this; };
      var getHeight = function() { return that.height; };

      var getIteration = function() { return that.iteration; };
      var setIteration = function(iteration) { return that.iteration = iteration; return this; };

      var hasInfinite = function() { return that.infinite; };
      var setInfinite = function(_boolean) { return that.infinite = _boolean; return this; };


      return {
         getAxiom: getAxiom,
            setAxiom: setAxiom,

            setConstant: setConstant,
            getConstant: getConstant,

            setAngle: setAngle,
            getAngle: getAngle,

            getRules: getRules,
            setRules: setRules,

            getHeight: getHeight,
            setHeight: setHeight,

            getWidth: getWidth,
            setWidth: setWidth,

            setIteration: setIteration,
            getIteration: getIteration,

            nextIteration: nextIteration,
            isValid: isValid,
            embedIn: embedIn,

            hasInfinite: hasInfinite,
            setInfinite: setInfinite
      };
   }
}
