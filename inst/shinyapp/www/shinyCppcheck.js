$(document).ready(function () {
  var notstart = false;
  $("#cppcheck")
    .on("shiny:recalculating", function () {
      if (notstart) {
        $(".shinybusy").addClass("shinybusy-busy");
        $(".shinybusy").removeClass("shinybusy-ready");
        $("#file").prop("disabled", true);
        $("#folder").prop("disabled", true);
        $("#btndef").prop("disabled", true);
        $("#btnundef").prop("disabled", true);
        $("#run").prop("disabled", true).text("Checking...");
      }
    })
    .on("shiny:recalculated", function () {
      if (notstart) {
        $(".shinybusy").removeClass("shinybusy-busy");
        $(".shinybusy").addClass("shinybusy-ready");
        $("#file").prop("disabled", false);
        $("#folder").prop("disabled", false);
        $("#btndef").prop("disabled", false);
        $("#btnundef").prop("disabled", false);
        $("#run").prop("disabled", false).text("Check");
      }
      notstart = true;
    });

  Shiny.addCustomMessageHandler("save", function (x) {
    var a = document.createElement("a");
    document.body.append(a);
    a.download = x.name;
    var b64 = btoa(unescape(encodeURIComponent(x.content)));
    a.href = "data:text/plain;base64," + b64;
    a.click();
    a.remove();
  });

  $("#toggle").on("click", function () {
    $("#editors").toggle("slow");
  }).one("mouseenter", function(){
    Shiny.setInputValue("showtoast", true);
  });

  Shiny.addCustomMessageHandler("goto", function (x) {
    var i = 0;
    setTimeout(function () {
      if (x.folder) {
        i = $("#tabset li.active").index() + 1;
      }
      var editor = ace.edit("editor" + i);
      editor.env.editor.gotoLine(x.line, x.column);
      editor.focus();
    }, 10);
  });

  $("[data-toggle=tooltip]").tooltip().on("hidden.bs.tooltip", function() {
    var $this = $(this);
    setTimeout(function() {
      $this.tooltip("destroy");
    }, 10000);
  });
});
