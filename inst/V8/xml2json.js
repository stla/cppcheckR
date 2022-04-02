function jUnescape(obj) {
  var j = JSON.stringify(obj);
  ["b", "f", "n", "r", "t", "u"].forEach(function (c) {
    j = j.split("\\\\" + c).join("\\" + c);
  });
  j = j.split('\\\\\\"').join('\\"');
  j = j.split("\\\\\\\\").join("\\\\");
  //console.log(j);
  return JSON.parse(j);
}

function xml2json(xml, spaces, options){
  const parser = new fxp.XMLParser(options);
  var json = parser.parse(decodeURI(xml).replace(/\\012/g, "\n"));
  //return(JSON.stringify(json, null, 2));
  return jUnescape(JSON.stringify(json, null, spaces));
}

function test(x){
  return x;
}
