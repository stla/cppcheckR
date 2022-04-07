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

  observeEvent(input[["filewithline"]], {
    flc <- input[["filewithline"]]
    navigateToFile(
      flc[["file"]], line = flc[["line"]], column = flc[["column"]]
    )
  })

  output[["fileOK"]] <- reactive({
    !is.null(filePath())
  })
  outputOptions(output, "fileOK", suspendWhenHidden = FALSE)

  output[["folderOK"]] <- reactive({
    !is.null(folderPath())
  })
  outputOptions(output, "folderOK", suspendWhenHidden = FALSE)

  observeEvent(input[["file"]], {
    tbl <- parseFilePaths(roots, input[["file"]])
    if(nrow(tbl) != 0L){
      folderPath(NULL)
      filePath(tbl[["datapath"]])
      fileContent <- paste0(readLines(tbl[["datapath"]]), collapse = "\n")
      updateAceEditor(session, "editor", value = fileContent)
    }
  })

  observeEvent(input[["folder"]], {
    path <- parseDirPath(roots, input[["folder"]])
    if(length(path) != 0L){
      filePath(NULL)
      folderPath(path)
    }
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
    on.exit({
      def(character(0L))
      undef(character(0L))
    })
    cppcheckR(
      path, std = isolate(input[["std"]]), def = def(), undef = undef(),
      checkConfig = isolate(input[["checkconfig"]])
    )
  })
})
