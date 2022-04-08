shinyServer(function(input, output, session){

  shinyFileChoose(
    input, "file",
    roots = roots,
    filetypes = c("c", "cpp", "c++")
  )

  shinyDirChoose(
    input, "folder",
    roots = roots
  )

  filePath <- reactiveVal()
  folderPath <- reactiveVal()
  files <- reactiveVal()
  pathType <- reactiveVal()

  observeEvent(input[["filewithline"]], {
    flc <- input[["filewithline"]]
    navigateToFile(
      flc[["file"]], line = flc[["line"]], column = flc[["column"]]
    )
    if(pathType() == "folder"){
      showTab("tabset", basename(flc[["file"]]), select = TRUE)
    }
    session$sendCustomMessage(
      "goto", list(
        line = flc[["line"]],
        column = flc[["column"]],
        folder = pathType() == "folder"
      )
    )
  })

  observeEvent(input[["showtoast"]], {
    show_toast(
      title = "Do you know?",
      text = "You can resize the editor.",
      type = "info",
      timer = 5000,
      position = "bottom-start"
    )
  })

  output[["fileOK"]] <- reactive({
    !is.null(filePath())
  })
  outputOptions(output, "fileOK", suspendWhenHidden = FALSE)

  output[["folderOK"]] <- reactive({
    !is.null(folderPath()) && length(files()) != 0L
  })
  outputOptions(output, "folderOK", suspendWhenHidden = FALSE)

  observeEvent(input[["file"]], {
    tbl <- parseFilePaths(roots, input[["file"]])
    if(nrow(tbl) != 0L){
      folderPath(NULL)
      pathType("file")
      filePath(tbl[["datapath"]])
      fileContent <- paste0(readLines(tbl[["datapath"]]), collapse = "\n")
      updateAceEditor(session, "editor0", value = fileContent)
      insertUI(
        "#editor0 .ace_scroller",
        "beforeEnd",
        actionButton(
          "btn0", "Save", icon = icon("save"),
          class = "btn-success",
          style = "position: absolute; bottom: 2px; right: 2px;",
          onclick = sprintf(
            'Shiny.setInputValue("save", {i: 0, name: "%s"}, {priority: "event"});',
            basename(tbl[["datapath"]]))
        )
      )
    }
  }, priority = 1)

  observeEvent(input[["folder"]], {
    path <- parseDirPath(roots, input[["folder"]])
    if(length(path) != 0L){
      filePath(NULL)
      pathType("folder")
      folderPath(path)
      cfiles <- list.files(
        path, pattern = "[\\.cpp|\\.c|\\.c\\+\\+]$", full.names = TRUE
      )
      if(length(cfiles) == 0L){
        sendSweetAlert(
          title = "Invalid folder",
          text = "There's no C/C++ file in this folder.",
          type = "error"
        )
      }else{
        files(cfiles)
      }
    }
  }, priority = 1)

  observeEvent(list(input[["folder"]], input[["file"]]), {
    for(f in files()){
      removeTab("tabset", basename(f))
    }
    def(character(0L))
    undef(character(0L))
    filePath(NULL)
    folderPath(NULL)
    files(NULL)
    pathType(NULL)
  }, priority = 10)

  observeEvent(files(), {
    i <- 0L
    for(f in files()){
      fileContent <- paste0(readLines(f), collapse = "\n")
      i <- i + 1L
      appendTab(
        "tabset",
        tab = tabPanel(
          title = basename(f),
          aceEditor(
            paste0("editor", i), value = fileContent,
            mode = "c_cpp", theme = "cobalt", height = "40vh"
          )
        ),
        select = i == 1L
      )
      insertUI(
        sprintf("#editor%d .ace_scroller", i),
        "beforeEnd",
        actionButton(
          paste0("btn", i), "Save", icon = icon("save"),
          class = "btn-success",
          style = "position: absolute; bottom: 2px; right: 2px;",
          onclick = sprintf(
            'Shiny.setInputValue("save", {i: %d, name: "%s"}, {priority: "event"});',
          i, basename(f))
        )
      )
    }
  })

  observeEvent(input[["save"]], {
    filename <- input[["save"]][["name"]]
    editor <- paste0("editor", input[["save"]][["i"]])
    session[["sendCustomMessage"]](
      "save", list(name = filename, content = input[[editor]])
    )
  })

  def <- reactiveVal(character(0L))
  undef <- reactiveVal(character(0L))

  observeEvent(input[["btndef"]], {
    inputSweetAlert(
      session = session,
      "symboldef",
      input = "text",
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
      allowOutsideClick = FALSE,
      showCloseButton = TRUE
    )
  })

  observeEvent(input[["symbolundef"]], {
    undef(c(undef(), input[["symbolundef"]]))
  })

  output[["cppcheck"]] <- renderCppcheckR({
    req(input[["run"]])
    path <- isolate(ifelse(is.null(filePath()), folderPath(), filePath()))
    cppcheckR(
      path, std = isolate(input[["std"]]),
      def = isolate(def()), undef = isolate(undef()),
      checkConfig = isolate(input[["checkconfig"]])
    )
  })
})
