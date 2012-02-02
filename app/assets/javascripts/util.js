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
};
