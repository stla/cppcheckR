shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "shinyCppcheck.css"),
    tags$script(src = "shinyCppcheck.js")
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
  sidebarLayout(
    sidebarPanel(
      tags$span("Cppcheck", style = "font-size:30px; font-style: italic;"),
      splitLayout(
        shinyFilesButton(
          "file",
          label = "Select a file",
          title = "Choose a C or C++ file",
          multiple = FALSE,
          buttonType = "primary",
          class = "btn-block",
          onclick = '$("#cppcheck").empty();'
        ),
        shinyDirButton(
          "folder",
          label = "Select a folder",
          title = "Choose a folder containing C or C++ files",
          buttonType = "primary",
          class = "btn-block",
          onclick = '$("#cppcheck").empty();'
        )
      ),
      br(), br(), br(),
      conditionalPanel(
        "output.fileOK || output.folderOK",
        style = "display: none;",
        selectInput(
          "std", "Select the standard",
          choices =
            c("c89", "c99", "c11", "c++03", "c++11", "c++14", "c++17", "c++20")
        ),
        br(),
        awesomeCheckbox("checkconfig", "Check config"),
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
          actionButton(
            "run", "Check",
            class = "btn-danger btn-block"
          )
        )
      )
    ),
    mainPanel(
      conditionalPanel(
        "output.folderOK",
        style = "display: none;",
        tabsetPanel(
          id = "tabset"
        )
      ),
      conditionalPanel(
        "output.fileOK",
        style = "display: none;",
        aceEditor(
          "editor", value = "", mode = "c_cpp", theme = "cobalt",
          height = "45vh"
        )
      ),
      br(),
      cppcheckROutput("cppcheck")
    )
  )
))
