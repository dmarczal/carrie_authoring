$(document).ready(function() {

    $.fn.calculator = function () {
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
        var question =  "Qual sua resposta para coluna: " + object.data('col') + " row: " + object.data('row');
        var answer = window.prompt(question);
        if (answer != null)
          sendAnswer(answer, this);
      });
   };

   $('.calculator').each(function (index, val) {
      $(val).calculator();
   });

});
