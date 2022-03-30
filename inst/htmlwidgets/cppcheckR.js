function jUnescape(obj) {
  var j = JSON.stringify(obj);
  ["b", "f", "n", "r", "t", "u"].forEach(function (c) {
    j = j.split("\\\\" + c).join("\\" + c);
  });
  j = j.split('\\\\\\"').join('\\"');
  j = j.split("\\\\\\\\").join("\\\\");
  return JSON.parse(j);
}

function replacer(key, value) {
  if (key === "@_line" || key === "@_column") {
    return parseInt(value);
  }
  return value;
}

HTMLWidgets.widget({
  name: "cppcheckR",

  type: "output",

  factory: function (el, width, height) {
    const parser = new fxp.XMLParser({ ignoreAttributes: false });
    const customColorOptions = {
      keyColor: "crimson",
      numberColor: "chartreuse",
      stringColor: "lightcoral",
      trueColor: "#00cc00",
      falseColor: "#ff8080",
      nullColor: "cornflowerblue"
    };

    return {
      renderValue: function (x) {
        var json = parser.parse(decodeURI(x.xmlContent));
        console.log(json);
        var errors = json.results.errors.error;
        for (var i = 0; i < errors.length; i++) {
          json.results.errors.error[i]["@_verbose"] = errors[i][
            "@_verbose"
          ].replace(/\\012/g, "\n");
        }
        var pre = document.createElement("PRE");
        pre.innerHTML = jsonFormatHighlight(
          jUnescape(JSON.stringify(json, replacer, 2)), customColorOptions
        );
        pre.style.whiteSpace = "pre-wrap";
        el.style.color = "#E76900";
        el.style.backgroundColor = "#051C55";
        el.style.fontSize = "16px";
        el.style.fontWeight = "bold";
        el.style.overflowY = "auto";
        el.style.padding = "10px";

        // TODO: code to render the widget, e.g.
        el.appendChild(pre);
      },

      resize: function (width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});
