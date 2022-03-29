HTMLWidgets.widget({

  name: 'cppcheckR',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        var pre = document.createElement("PRE");
        pre.innerText = JSON.stringify(x.cppcheck, null, 4);

        // TODO: code to render the widget, e.g.
        el.appendChild(pre);

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
