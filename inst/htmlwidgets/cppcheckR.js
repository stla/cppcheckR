HTMLWidgets.widget({

  name: 'cppcheckR',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        var pre = document.createElement("PRE");
        pre.innerText = JSON.stringify(x.cppcheck, null, 4);
        pre.style.color = "#E76900";
        pre.style.backgroundColor = "#14128E";
        pre.style.fontSize = "16px";
        pre.style.fontWeight = "bold";

        // TODO: code to render the widget, e.g.
        el.appendChild(pre);

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
