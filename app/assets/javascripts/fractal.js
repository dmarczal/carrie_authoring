$(document).ready(function() {
  if (request.controller === "fractals") {
     if (request.action === "new" || request.action === "create"  || request.action === "edit" ){
        create_action();
     } else
         if (request.action === "index"){
            show_fractals();
         }
         else {
            if (request.action == "show") {
               show_this_fractal();
            }
         }
  }
});

var show_fractals = function() {
   $("td.fractal").each(function (){
      var fractalJSON = $(this).data("fractal");
      fractalJSON.width=64;
      fractalJSON.height=64;
      var fractal = Fractal.create(fractalJSON);

      for (var i = 0; i < 3; i++) {
         $(this).append(fractal.nextIteration());
      };
   });
}

var show_this_fractal = function() {
   var fractalJSON = $("tbody.fdata").data("fractal");
   fractalJSON.width=200;
   fractalJSON.height=200;
   var fractal = Fractal.create(fractalJSON);
   for (var i = 0; i < 6; i++) {
      var row = $("<tr>");
      var itData = $("<td class='iteration'>");
      var frData = $("<td class='fractal'>");
      $(itData).append(fractal.getIteration());
      $(frData).append(fractal.nextIteration());
      $("tbody.fdata").append(row);

      $(row).append(itData);
      $(row).append(frData);
   };
};

var show_next_it = function() {
   var fractalJSON = $("tbody.fdata").data("fractal");
   fractalJSON.width=200;
   fractalJSON.height=200;
   var fractal = Fractal.create(fractalJSON);
   var rowcount = $("tr").size() - 1;
   var row = $("<tr>");
   var itData = $("<td class='iteration'>");
   var frData = $("<td class='fractal'>");
   fractal.setIteration(rowcount);
   $(itData).append(fractal.getIteration());
   $(frData).append(fractal.nextIteration());
   $("tbody.fdata").append(row);
   $(row).append(itData);
   $(row).append(frData);
}


function rules_to_array(rules){
   return rules.toString().replace(/\s/, '').split(',');
};

// Executes a callback detecting changes with a frequency of 1 second
var create_action =  function () {
   var frac = Fractal.create({name: $('#fractal_name').val(),
                              axiom: $('#fractal_axiom').val(),
                              constant: $('#fractal_constant').val(),
                              angle:  $('#fractal_angle').val(),
                              rules: rules_to_array($('#fractal_rules').val()),
                              height: 128, width: 128});
   loadPreview(frac);
   $("input").observe_field(1, function() {
      if (this.id == 'fractal_name') frac.setName(this.value);
      if (this.id == 'fractal_axiom') frac.setAxiom(this.value);
      if (this.id == 'fractal_rules') frac.setRules(rules_to_array(this.value));
      if (this.id == 'fractal_angle') frac.setAngle(this.value);

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
            embedIn: embedIn
      };
   }
}
