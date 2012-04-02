function toText(string) {
  string = string.replace(/^\[/, "");
  string = string.replace(/\]$/, "");
  while (string.indexOf('"') != -1) {
    string = string.replace('"', "");
  }
  return string;
}

function rules_to_array(rules){
   if (rules) {
      return rules.toString().replace(/\s/, '').split(',');
   }
}

function remove_fields(link) {
   console.log($(link));
   $(link).previous("input[type=hidden]").value = 1;
   $(link).up("fields").hide();
}

/*
 * Set the answer in a object
 * Uses to set a answer in a table cell
 */
function setAnswer(response, correct, object){
   var div = $("<div>");
   var span = $("<span>");
   var legend = $("<span class='text-in-border'>")

   if (correct === true) {
      $(div).addClass('right-answer');
      $(legend).html("Correto");
   }
   else {
      $(div).addClass('wrong-answer');
      $(legend).html("Incorreto");
   }

   $(div).html("<div>"+ response +"</div>");
   $(object).html(div);
   $(object).prepend(legend);
}
