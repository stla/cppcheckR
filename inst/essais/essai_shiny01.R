library(cppcheckR)
library(shiny)
library(shinyFiles)
library(shinyAce)
library(shinybusy)
library(shinyWidgets)

js <- '
$(document).ready(function(){
  var notstart = false;
  $("#cppcheck").on("shiny:recalculating", function(){
    //$("#cppcheck").addClass("shinybusy-block");
    if(notstart){
      $(".shinybusy").addClass("shinybusy-busy");
      $(".shinybusy").removeClass("shinybusy-ready");
      $("#file").prop("disabled", true);
      $("#run").prop("disabled", true).text("Running...");
    }
  }).on("shiny:recalculated", function(){
    if(notstart){
      $(".shinybusy").removeClass("shinybusy-busy");
      $(".shinybusy").addClass("shinybusy-ready");
      $("#file").prop("disabled", false);
      $("#run").prop("disabled", false).text("Check");
    }
    notstart = true;
  });
})
'

ui <- fluidPage(
  tags$head(
    tags$script(HTML(js))
  ),
  use_busy_spinner(
    spin = "fading-circle",
    color = "#112446",
    position = "top-left",
    margins = c(10, 10),
    spin_id = NULL,
    height = "100px",
    width = "100px"
  ),
  # add_loading_state(
  #   "#cppcheck",
  #   spinner = "hourglass",
  #   svgSize = "100px"
  # ),
  sidebarLayout(
    sidebarPanel(
      shinyFilesButton(
        "file",
        label = "Browse",
        title = "Choose a C or C++ file",
        multiple = FALSE,
        buttonType = "primary"
      ),
      br(), br(), br(),
      conditionalPanel(
        "output.fileOK",
        style = "display: none;",
        selectInput(
          "std", "Select the standard",
          choices =
            c("c89", "c99", "c11", "c++03", "c++11", "c++14", "c++17", "c++20")
        ),
        br(),
        checkboxInput("checkconfig", "Check config"),
        br(),
        h4("Define/undefine a symbol:"),
        actionGroupButtons(
          c("btndef", "btnundef"),
          c("Define", "Undefine"),
          status = c("info", "success"),
          size = "normal",
          direction = "horizontal",
          fullwidth = TRUE
        ),
        br(),
        wellPanel(
          actionButton("run", "Check", class = "btn-danger btn-block")
        )
      )
    ),
    mainPanel(
      conditionalPanel(
        "output.fileOK",
        style = "display: none;",
        aceEditor(
          "editor", value = "", mode = "c_cpp", theme = "cobalt",
          height = "45vh"
        )
      ),
      br(),
      cppcheckROutput("cppcheck", height = "45vh")
    )
  )
)

roots <- getVolumes()()

server <- function(input, output, session){

  shinyFileChoose(
    input, "file",
    roots = roots,
    filetypes = c("c", "cpp", "c++")
  )

  filePath <- reactiveVal()

  output[["fileOK"]] <- reactive({
    !is.null(filePath())
  })
  outputOptions(output, "fileOK", suspendWhenHidden = FALSE)

  observeEvent(input[["file"]], {
    tbl <- parseFilePaths(roots, input[["file"]])
    if(nrow(tbl) != 0L){
      filePath(tbl[["datapath"]])
      fileContent <- paste0(readLines(tbl[["datapath"]]), collapse = "\n")
      updateAceEditor(session, "editor", value = fileContent)
    }
  })

  def <- reactiveVal(character(0L))
  undef <- reactiveVal(character(0L))

  observeEvent(input[["btndef"]], {
    inputSweetAlert(
      session = session,
      "symboldef",
      input = "text",
      #title = "What's your name ?",
      allowOutsideClick = FALSE,
      showCloseButton = TRUE
    )
  })

  observeEvent(input[["symboldef"]], {
    def(c(def(), input[["symboldef"]]))
  })

  observeEvent(input[["btnundef"]], {
    inputSweetAlert(
      session = session,
      "symbolundef",
      input = "text",
      #title = "What's your name ?",
      allowOutsideClick = FALSE,
      showCloseButton = TRUE
    )
  })

  observeEvent(input[["symbolundef"]], {
    undef(c(undef(), input[["symbolundef"]]))
  })

  observe({
    print(def())
    print(undef())
  })

  output[["cppcheck"]] <- renderCppcheckR({
    req(input[["run"]])
    # show_spinner()
    cppcheckR(
      filePath(), std = input[["std"]], def = def(), undef = undef(),
      checkConfig = input[["checkconfig"]]
    )
  })
}

shinyApp(ui, server)
