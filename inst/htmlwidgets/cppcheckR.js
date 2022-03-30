function jUnescape(obj) {
  var j = JSON.stringify(obj);
  ["b", "f", "n", "r", "t", "u"].forEach(function (c) {
    j = j.split("\\\\" + c).join("\\" + c);
  });
  j = j.split('\\\\\\"').join('\\"');
  j = j.split("\\\\\\\\").join("\\\\");
  console.log(j);
  return JSON.parse(j);
}

function replacer(key, value) {
  if (key === "@_line" || key === "@_column") {
    return parseInt(value);
  } else if (key === "@_file") {
    return value.replace(/\\/g, "/");
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
        if (errors) {
          for (var i = 0; i < errors.length; i++) {
            json.results.errors.error[i]["@_verbose"] = errors[i][
              "@_verbose"
            ].replace(/\\012/g, "\n");
          }
        }
        console.log(JSON.stringify(json, replacer, 2));
        var pre = document.createElement("PRE");
        pre.innerHTML = jsonFormatHighlight(
          jUnescape(JSON.stringify(json, replacer, 2)),
          customColorOptions
        );
        pre.style.whiteSpace = "pre-wrap";
        pre.style.outline = "#051C55 solid 10px";
        pre.style.backgroundColor = "#051C55";
        pre.style.color = "#E76900";
        pre.style.fontSize = "15px";
        pre.style.fontWeight = "bold";
        el.style.overflowY = "auto";
        el.style.padding = "10px";

        el.appendChild(pre);

        var locations = document.evaluate(
          "//span[text()='\"location\":']",
          document,
          null,
          XPathResult.ORDERED_NODE_ITERATOR_TYPE,
          null
        );
        var location = locations.iterateNext();
        while (location) {
          location.style.borderTop = "2px solid";
          location = locations.iterateNext();
        }

        var spans = document.evaluate(
          "//span[text()='\"@_cwe\":']",
          document,
          null,
          XPathResult.ORDERED_NODE_ITERATOR_TYPE,
          null
        );
        var result = spans.iterateNext();
        var results = [];
        while (result) {
          results.push(result);
          result = spans.iterateNext();
        }
        for (var i = 0; i < results.length; i++) {
          var span = results[i].nextElementSibling;
          var code = parseInt(JSON.parse(span.innerText));
          span.innerText = "";
          var a = document.createElement("A");
          a.style.color = "aquamarine";
          a.style.textDecoration = "underline";
          a.setAttribute(
            "href",
            "https://cwe.mitre.org/data/definitions/" + code + ".html"
          );
          a.appendChild(document.createTextNode(code));
          span.appendChild(a);
        }
      },

      resize: function (width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});
