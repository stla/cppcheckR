$(document).ready(function(){
  var notstart = false;
  $("#cppcheck").on("shiny:recalculating", function(){
    if(notstart){
      $(".shinybusy").addClass("shinybusy-busy");
      $(".shinybusy").removeClass("shinybusy-ready");
      $("#file").prop("disabled", true);
      $("#folder").prop("disabled", true);
      $("#btndef").prop("disabled", true);
      $("#btnundef").prop("disabled", true);
      $("#run").prop("disabled", true).text("Checking...");
    }
  }).on("shiny:recalculated", function(){
    if(notstart){
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
})
