function jUnescape(obj) {
  var j = JSON.stringify(obj);
  ["b", "f", "n", "r", "t", "u"].forEach(function (c) {
    j = j.split("\\\\" + c).join("\\" + c);
  });
  j = j.split('\\\\\\"').join('\\"');
  console.log(j);
  j = j.split("\\\\\\\\").join("\\\\");
  //console.log(j);
  return JSON.parse(j);
}

function replacer(key, value) {
  if(typeof value === "string"){
    return value.replace(/\\n/g, "\n");
  }
  return value;
}

function xml2json(xml, spaces, options, linebreaks){
  const parser = new fxp.XMLParser(options);
  var replacement = linebreaks ? "\n" : "\\n";
  var obj = parser.parse(decodeURI(xml).replace(/\\012/g, replacement));
  var json = JSON.stringify(obj, null, spaces);
  if(linebreaks){
    json = json.replace(/\\n/g, "\n");
  }
  return json;
  return jUnescape(JSON.stringify(json,  null, spaces));
}

function test(x){
  return x;
}
