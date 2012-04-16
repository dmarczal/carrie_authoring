$(document).ready(function() {
   var calc = Carrie.Calc.create({});
   $('.calculator').each(function (index, val) {
      $(val).calculator(calc);
   });
});

$.fn.calculator = function (calc) {
   var object = $(this);
   var col = object.data('col');
   var row = object.data('row');
   var answer_id = object.data('answer-id');
   var url = $($('table th').get(col)).data('verify-answer-url');

   var sendAnswer =  function (answer, cell) {
      $.post(url, { response: answer, answer_id: answer_id }, function(response) {
         setAnswer(answer, response, cell);
      }, 'json');
   }

   object.click(function () {
      var val = object.find('div div').html() ;
      val = val ? val : "";
      calc.open({
         value: val,
         onSend: function (response){
            sendAnswer(response, object);
         }
      });
   });
};

Carrie.Calc = Carrie.Calc || {

   create: function(data){
      this.input = $("#calc_input");
      this.display = $('#display');
      this.errorClass = data.errorClass || "error";
      this.variables = data.variables || {};
      this.callBack = function (){};
      var that = this;

      $('.calc .btns div a').each(function (index, element) {
         $(element).click(function (){
            setInput($(this).attr('id'));
         });
      });

      that.input.keyup(function (event){
         if ( event.which == 13 ) {
            event.preventDefault();
         }
         updateDisplay($(this).val());
      });

      $("#dialog-calc").dialog({
         autoOpen: false,
         draggable: true,
         resizable: false,
         width: 370,
         modal: true,
         dialogClass: '',
         title: 'Teclado Virtual',
         close: function (){
           that.input.val('');
         }
      });

      var validateExpression = function (exp) {
         try{
            var vars = {};

            if (!$('#n').hasClass('disabled'))
               vars.n = 0;
            if (!$('#l').hasClass('disabled'))
               vars.l = 0;

            rst = Parser.evaluate(exp, vars);

            if (isNaN(rst) || (exp.indexOf('sqrt()') != -1))
               return false;

            return true;
         }catch (e) {
            return false;
         }
      };

      var updateDisplay = function (exp) {
         if (validateExpression(exp)){
            that.input.removeClass(that.errorClass);
            that.input.next().hide();
         }else
            that.input.addClass(that.errorClass);

         that.display.html('$'+exp+'$');
         MathJax.Hub.Queue(["Typeset",MathJax.Hub,"display"]);
      };

      var setInput = function (value) {
         that.input.focus();

         switch (value) {
            case 'sqrt':
               that.input.insertAtCursor("sqrt()");
               var cursor = that.input.getCursorPosition() - 1;
               that.input.setSelection(cursor, cursor);
               break;
            case 'clean':
               that.input.val('');
               break;
            case '^':
               that.input.insertAtCursor("^()");
               var cursor = that.input.getCursorPosition() - 1;
               that.input.setSelection(cursor, cursor);
               break;
            case 'backspace':
               var formula = that.input.val().substring(0, that.input.getCursorPosition()-1)
                  + that.input.val().substring(that.input.getCursorPosition(), that.input.val().length);

               var cursor = that.input.getCursorPosition()-1;
               that.input.val(formula);
               that.input.setSelection(cursor, cursor);
               break;
            case 'send':
               var val = that.input.val();
               if (validateExpression(val)){
                  that.callBack(val);
                  $("#dialog-calc").dialog('close');
               }else{
                  that.input.next().show();
               }
               break;
            default:
               that.input.insertAtCursor(value);
         }
         updateDisplay(that.input.val());
      };

      var open = function(data){
        $("#dialog-calc").dialog('open');
        setInput(data.value);
        that.callBack = data.onSend;
      }
      return {open: open};
   }
};
