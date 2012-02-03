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

