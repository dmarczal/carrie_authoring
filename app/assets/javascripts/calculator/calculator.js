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
   var url = $($('#exercise_table th').get(col)).data('verify-answer-url');

   var sendAnswer =  function (answer, cell, exp) {
      console.log(url);

      /* é necessário enviar todas as repostas da questão */
      /*var exercise_responses = [];
      var rows = $("table tr:gt(0)");
      rows.each(function (i, row) {
         exercise_responses[i] = [];
         $(row).find('td').each(function (j, obj) {
            var title = $(this).attr('title');
            exercise_responses[i][j] = (title !== undefined) ? title : '';
         });
      });
      exercise_responses[row][col] = answer;*/


      question_responses = [];
      $('#exercise_table').column(col).each(function (index) {
         var title = $(this).attr('title');
         question_responses[index] = (title !== undefined) ? title : "";
      });

      $.post(url, { response: answer, correct_answer_id: answer_id,
                    question_responses: question_responses
                  },
                  function(response) {
                     setAnswer(answer, response, cell, exp);
                  },
                  'json');
   }

   object.click(function () {
      var val = object.attr('title');
      val = val !== undefined ? val : "";
      calc.open({
         value: val,
         onSend: function (response, exp){
            sendAnswer(response, object, exp);
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
         zIndex: 1051,
         close: function (){
           that.input.val('');
         }
      });

      var validateExpression = function (exp) {
         try{
            var vars = {};

            if (!$('#n').hasClass('disabled'))
               vars.n = 0.8;
            if (!$('#l').hasClass('disabled'))
               vars.l = 311.43;

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
                  that.callBack(val, that.display.html());
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
        that.input = $("#calc_input");
        that.display = $('#display');

        $("#dialog-calc").dialog('open');
        setInput(data.value);
        that.callBack = data.onSend;
      }
      return {open: open};
   }
};
