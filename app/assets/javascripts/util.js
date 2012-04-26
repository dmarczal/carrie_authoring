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
function setAnswer(response, correct, object, exp){
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

   //response = (response === undefined) ? "" : response;

   $(div).html("<div>" + exp + "</div>");
   //console.log(div);
   //MathJax.Hub.Queue(["Typeset",MathJax.Hub, div]);

   $(object).attr('title', response);
   $(object).html(div);
   $(object).prepend(legend);
}


// My Library
$.fn.getCursorPosition = function() {
   var pos = 0;
   var el = $(this).get(0);
   // IE Support
   if (document.selection) {
      el.focus();
      var Sel = document.selection.createRange();
      var SelLength = document.selection.createRange().text.length;
      Sel.moveStart('character', -el.value.length);
      pos = Sel.text.length - SelLength;
   }
   // Firefox support
   else if (el.selectionStart || el.selectionStart == '0')
      pos = el.selectionStart;

   return pos;
}

jQuery.fn.setSelection = function(selectionStart, selectionEnd) {
    if(this.lengh == 0) return this;
    input = this[0];
 
    if (input.createTextRange) {
        var range = input.createTextRange();
        range.collapse(true);
        range.moveEnd('character', selectionEnd);
        range.moveStart('character', selectionStart);
        range.select();
    } else if (input.setSelectionRange) {
        input.focus();
        input.setSelectionRange(selectionStart, selectionEnd);
    }
 
    return this;
}

$.fn.insertAtCursor = function(val) {
   var startPos = this.getCursorPosition();
   var endPos = this.getCursorPosition();
   var value = $(this).val().substring(0, startPos)
         + val
         + $(this).val().substring(endPos, $(this).val().length);

   $(this).val(value);
   var cursor = startPos + val.length;
   $(this).setSelection(cursor, cursor);
}

/** Table */
$.fn.row = function(i) {
    return $('tr:nth-child('+(i+1)+') td', this);
}

$.fn.column = function(i) {
    return $('tr td:nth-child('+(i+1)+')', this);
}
