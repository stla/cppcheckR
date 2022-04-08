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
      tags$span("Cppcheck", style = "font-size:30px;", class = "origin"),
      br(), br(),
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
        selectizeInput(
          "std", "Select the standard",
          choices = list(
            "C" = list("c89", "c99", "c11"),
            "C++" = list("c++03", "c++11", "c++14", "c++17", "c++20")
          ),
          options = list(
            plugins = list("optgroup_columns")
          )
        ),
        br(),
        prettyCheckbox(
          "checkconfig",
          tags$em(
            "Check config",
            `data-toggle` = "tooltip",
            `data-placement` = "right",
            title = paste0(
              "This option tells you which header files are missing."
            )
          ),
          status = "info", shape = "round", inline = TRUE
        ),
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
          fluidRow(
            column(
              2,
              tags$img(src = "cppcheck-gui.png", style = "width: 140%")
            ),
            column(
              10,
              actionButton(
                "run", "Check",
                class = "btn-danger btn-block"
              )
            )
          )
        ),
        actionBttn(
          inputId = "toggle",
          label = "Hide/Show editor",
          color = "royal",
          style = "material-flat",
          block = TRUE,
          size = "sm"
        )
      )
    ),
    mainPanel(
      style = "display:flex; flex-flow:column; height: 98vh",
      jqui_resizable(tags$div(
        id = "editors",
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
            "editor0", value = "", mode = "c_cpp", theme = "cobalt",
            height = "40vh"
          )
        )
      ), options = list(
        handles = "s",
        alsoResize = ".ace_editor"
      )),
      br(),
      cppcheckROutput("cppcheck", height = "100%")
    )
  )
))
