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
  } else if (key === "@_file") {
    return value.replace(/\\/g, "/");
  } else if (key === "?xml") {
    return undefined;
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
        if (x.notfound) {
          var a = document.createElement("A");
          a.style.color = "aquamarine";
          a.style.textDecoration = "underline";
          a.setAttribute("href", "https://cppcheck.sourceforge.io/");
          a.appendChild(
            document.createTextNode("https://cppcheck.sourceforge.io/")
          );
          var span = document.createElement("SPAN");
          span.appendChild(
            document.createTextNode(
              "'Cppcheck' not found. Either it is not installed or it is " +
                "not in the PATH. If it is not installed, visit "
            )
          );
          span.appendChild(a);
          span.appendChild(document.createTextNode("."));
          span.style.whiteSpace = "pre-wrap";
          el.style.outline = "#051C55 solid 10px";
          el.style.backgroundColor = "#051C55";
          el.style.marginLeft = "auto";
          el.style.marginRight = "auto";
          span.style.color = "#E76900";
          span.style.fontSize = "15px";
          span.style.fontWeight = "bold";
          el.style.padding = "10px";
          el.appendChild(span);
        } else {
          var style = document.createElement("style");
          style.textContent =
            ".cppcheckR::-webkit-scrollbar-track {" +
            "  -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);" +
            "  border-radius: 10px;" +
            "  background-color: #F5F5F5;" +
            "}" +
            ".cppcheckR::-webkit-scrollbar {" +
            "  width: 8px;" +
            "  height: 8px;" +
            "  background-color: transparent;" +
            "}" +
            ".cppcheckR::-webkit-scrollbar-thumb {" +
            "  border-radius: 10px;" +
            "  -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);" +
            "  background-color: #D62929;" +
            "}";
          document.head.appendChild(style);

          var json = parser.parse(decodeURI(x.xmlContent));
          var errors = json.results.errors.error;
          if (errors) {
            for (var i = 0; i < errors.length; i++) {
              json.results.errors.error[i]["@_verbose"] = errors[i][
                "@_verbose"
              ].replace(/\\012/g, "\n");
            }
          }
          var pre = document.createElement("PRE");
          var jsonString = jUnescape(JSON.stringify(json, replacer, 2));
          pre.innerHTML = jsonFormatHighlight(jsonString, customColorOptions);
          pre.style.whiteSpace = "pre-wrap";
          pre.style.outline = "#051C55 solid 10px";
          pre.style.backgroundColor = "#051C55";
          pre.style.color = "#E76900";
          pre.style.fontSize = "15px";
          pre.style.fontWeight = "bold";
          pre.style.margin = "0";
          el.style.display = "flex";
          el.style.flexFlow = "column";
          el.style.width = "auto";
          el.style.overflowY = "auto";
          el.style.padding = "10px";

          var title = document.createElement("P");
          title.appendChild(document.createTextNode(x.title));
          title.style.fontSize = "16px";
          title.style.fontStyle = "italic";
          title.style.textDecoration = "underline";
          title.style.color = "lime";
          title.style.marginTop = "4px";

          pre.prepend(title);

          var btn = document.createElement("button");
          btn.innerHTML = "Copy";
          btn.onclick = function () {
            navigator.clipboard.writeText(jsonString);
          };
          btn.style.float = "right";
          btn.style.padding = "5px 12px";
          btn.style.marginTop = "5px";
          btn.style.borderRadius = "100%";
          btn.style.backgroundColor = "darkmagenta";
          btn.style.borderWidth = "1.5px";
          btn.style.borderColor = "yellow";
          btn.style.backgroundImage =
            "linear-gradient(-20deg, darkmagenta 20%, #e61d8c 90%)";
          btn.onmouseover = function () {
            this.style.backgroundImage =
              "linear-gradient(200deg, darkmagenta 20%, #e61d8c 90%)";
          };
          btn.onmouseout = function () {
            this.style.backgroundImage =
              "linear-gradient(-20deg, darkmagenta 20%, #e61d8c 90%)";
          };
          btn.onfocus = function () {
            this.style.outline = "none";
          };

          var btnsave = document.createElement("button");
          btnsave.innerHTML = "JSON";
          btnsave.onclick = function () {
            var a = document.createElement("a");
            document.body.append(a);
            a.download = "cppcheck.json";
            var b64 = btoa(unescape(encodeURIComponent(jsonString)));
            a.href = "data:text/plain;base64," + b64;
            a.click();
            a.remove();
          };
          btnsave.style.padding = "5px 12px";
          btnsave.style.marginTop = "3px";
          btnsave.style.marginLeft = "2px";
          btnsave.style.borderRadius = "100%";
          btnsave.style.backgroundColor = "darkmagenta";
          btnsave.style.borderWidth = "1.5px";
          btnsave.style.borderColor = "yellow";
          btnsave.style.backgroundImage =
            "linear-gradient(-20deg, darkmagenta 20%, #e61d8c 90%)";
          btnsave.onmouseover = function () {
            this.style.backgroundImage =
              "linear-gradient(200deg, darkmagenta 20%, #e61d8c 90%)";
          };
          btnsave.onmouseout = function () {
            this.style.backgroundImage =
              "linear-gradient(-20deg, darkmagenta 20%, #e61d8c 90%)";
          };
          btnsave.onfocus = function () {
            this.style.outline = "none";
          };

          var btnhtml = document.createElement("button");
          btnhtml.innerHTML = "HTML";
          btnhtml.style.padding = "5px 12px";
          btnhtml.style.marginTop = "3px";
          btnhtml.style.marginRight = "2px";
          btnhtml.style.borderRadius = "100%";
          btnhtml.style.backgroundColor = "darkmagenta";
          btnhtml.style.borderWidth = "1.5px";
          btnhtml.style.borderColor = "yellow";
          btnhtml.style.backgroundImage =
            "linear-gradient(200deg, darkmagenta 20%, #e61d8c 90%)";
          btnhtml.onmouseover = function () {
            this.style.backgroundImage =
              "linear-gradient(-20deg, darkmagenta 20%, #e61d8c 90%)";
          };
          btnhtml.onmouseout = function () {
            this.style.backgroundImage =
              "linear-gradient(200deg, darkmagenta 20%, #e61d8c 90%)";
          };
          btnhtml.onfocus = function () {
            this.style.outline = "none";
          };

          var fieldset = document.createElement("FIELDSET");
          fieldset.style.float = "right";
          var legend = document.createElement("LEGEND");
          legend.style.fontStyle = "italic";
          legend.innerHTML = "Save";
          var btncontainer = document.createElement("DIV");
          btncontainer.style.display = "flex";
          btncontainer.appendChild(btnhtml);
          btncontainer.appendChild(btnsave);
          fieldset.appendChild(legend);
          fieldset.appendChild(btncontainer);

          el.appendChild(pre);

          var spans_id = document.evaluate(
            "//span[text()='\"@_id\":']",
            document,
            null,
            XPathResult.ORDERED_NODE_ITERATOR_TYPE,
            null
          );
          var span_id = spans_id.iterateNext();
          while (span_id) {
            span_id.style = "color: gold;";
            span_id = spans_id.iterateNext();
          }

          var locations = document.evaluate(
            "//span[text()='\"location\":']",
            document,
            null,
            XPathResult.ORDERED_NODE_ITERATOR_TYPE,
            null
          );
          var location = locations.iterateNext();
          while (location) {
            location.style.borderTop = "2px solid magenta";
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

          var pre_outerHTML = pre.outerHTML;
          btnhtml.onclick = function () {
            var a = document.createElement("a");
            document.body.append(a);
            a.download = "cppcheck.html";
            var html = [
              "<!DOCTYPE html>",
              '<html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">',
              "  <head>",
              '    <meta charset="utf-8" />',
              '    <meta name="generator" content="json-format-highlight.js" />',
              "    <meta",
              '      name="viewport"',
              '      content="width=device-width, initial-scale=1.0, user-scalable=yes"',
              "    />",
              "    <title>Cppcheck</title>",
              "  </head>",
              "  <body>",
              pre_outerHTML,
              "  </body>",
              "</html>"
            ].join("\n");
            var b64 = btoa(unescape(encodeURIComponent(html)));
            a.href = "data:text/plain;base64," + b64;
            a.click();
            a.remove();
          };

          pre.prepend(btn);

          pre.appendChild(fieldset);

          if (x.rstudio && HTMLWidgets.shinyMode) {
            var emptydiv = document.createElement("DIV");
            emptydiv.style.height = "5px";
            emptydiv.style.clear = "right";
            pre.appendChild(emptydiv);
            var filespans = document.evaluate(
              "//span[text()='\"@_file\":']",
              document,
              null,
              XPathResult.ORDERED_NODE_ITERATOR_TYPE,
              null
            );
            var spn = filespans.iterateNext();
            var spns = [];
            while (spn) {
              spns.push(spn);
              spn = filespans.iterateNext();
            }
            function createAnchor(i) {
              var nextspan = spns[i].nextElementSibling;
              var filepath = JSON.parse(nextspan.innerText);
              nextspan.innerText = "";
              var a = document.createElement("A");
              a.style.color = "darkkhaki";
              a.style.textDecoration = "underline";
              a.setAttribute("href", "javascript:;");
              a.appendChild(document.createTextNode(filepath));
              nextspan.appendChild(a);
              var linespan = nextspan.nextElementSibling.nextElementSibling;
              var line = parseInt(linespan.innerText);
              var colspan = linespan.nextElementSibling.nextElementSibling;
              var column = parseInt(colspan.innerText);
              var shinyValue = { file: filepath, line: line, column: column };
              a.onclick = function () {
                Shiny.setInputValue("filewithline", shinyValue, {
                  priority: "event"
                });
              };
            }
            for (var i = 0; i < spns.length; i++) {
              createAnchor(i);
            }
          }
        }
      },

      resize: function (width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});
