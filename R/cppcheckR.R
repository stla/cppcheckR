isFile <- function(path){
  file.exists(path) && !dir.exists(path)
}

isRcppFile <- function(path){
  if(!isFile(path)){
    return(FALSE)
  }
  fileLines <- readLines(path)
  nlines <- length(fileLines)
  i <- 0L
  test <- TRUE
  while(test && i < nlines){
    i <- i + 1L
    test <- !grepl("Rcpp.h", fileLines[i], fixed = TRUE)
  }
  !test
}

#' @importFrom xml2 read_xml as_list xml_child xml_length xml_remove xml_contents
#' @noRd
cppcheck0 <- function(path, Rcpp, include, std){
  if(Sys.which("cppcheck") == ""){
    stop("This package requires 'cppcheck' and it doesn't find it.")
  }
  TMPDIR <- tempdir()
  args <-
    c(
      "--xml",
      "--force",
      "--enable=all",
      paste0("--std=", std),
      "--suppress=ConfigurationNotChecked",
      "--suppress=missingIncludeSystem",
      paste0("--cppcheck-build-dir=%s", TMPDIR)
    )
  if(Rcpp){
    Rcpp_include <- system.file("include", package = "Rcpp")
    args <- c(
      args,
      paste0("-I", Rcpp_include),
      sprintf("--suppress=*:*%s/*", Rcpp_include)
    )#, paste0("-i", Rcpp_include))
    if(dir.exists(path) && "RcppExports.cpp" %in% list.files(path)){
      exclude <- path.expand(file.path(path, "RcppExports.cpp"))
      args <- c(args, paste0("-i", exclude))
    }
  }
  if(!is.null(include)){
    args <- c(args, paste0("-I", include))
  }
  args <- c(args, path)
  print(args)
  xmlFile <- tempfile(fileext = ".xml")
  CPPCHECK <- suppressWarnings(
    system2("cppcheck", args, stdout = "", stderr = xmlFile)
  )
  if(!is.null(attr(CPPCHECK, "status"))){
    stop(CPPCHECK)
  }
  XML <- read_xml(xmlFile)
  errors <- xml_child(XML, "errors")
  if(xml_length(errors) == 0L){
    xml_remove(xml_contents(errors))
  }
  as_list(XML)
}

standards <- function(){
  c(
    "c89",
    "c99",
    "c11",
    "c++03",
    "c++11",
    "c++14",
    "c++17",
    "c++20"
  )
}

cppcheck_prompt <- function(){
  stds <- standards()
  cat("Set the standard:\n")
  choices <- paste0(seq_along(stds), ". ", stds)
  cat(choices, sep = "\n")
  choice <- readline("Your selection: ")
  i <- as.integer(choice)
  if(!is.element(i, seq_along(stds))){
    stop(
      sprintf(
        "You must enter a number between 1 and %d.", length(stds)
      )
    )
  }
  stds[i]
}

#' @importFrom pkgload pkg_path
#' @noRd
pkgPath <- function(path){
  tryCatch({
    pkg_path(path)
  }, error = function(e){
    NULL
  })
}

#' @importFrom pkgload pkg_desc
#' @noRd
cppcheck <- function(path, std){
  if(!file.exists(path)){
    stop("Invalid path.")
  }
  pPath <- pkgPath(path)
  if(!is.null(pPath)){
    desc <- pkg_desc(pPath)
    Rcpp <- desc$has_dep("Rcpp", "LinkingTo")
    include <- file.path(pPath, "inst", "include")
    if(!dir.exists(include)){
      include <- NULL
    }
    cppcheck0(path = path, Rcpp = Rcpp, include = include, std = std)
  }else if(isFile(path)){
    Rcpp <- isRcppFile(path)
    cppcheck0(path = path, Rcpp = Rcpp, include = NULL, std = std)
  }else{ # path is a folder
    files <- list.files("path", "[\\.cpp|\\.h]$", full.names = TRUE)
    Rcpp <- FALSE
    for(f in files){
      if(isRcppFile(f)){
        Rcpp <- TRUE
        break
      }
    }
    cppcheck0(path = path, Rcpp = Rcpp, include = NULL, std = std)
  }
}



#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
cppcheckR <- function(
  path, std = NULL, width = NULL, height = NULL, elementId = NULL
){

  if(!is.null(std)){
    std <- match.arg(std, standards())
  }else{
    std <- cppcheck_prompt()
  }
  cppcheckResults <- cppcheck(path, std)

  # forward options using x
  x = list(
    cppcheck = cppcheckResults
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'cppcheckR',
    x,
    width = width,
    height = height,
    package = 'cppcheckR',
    elementId = elementId
  )
}

#' @importFrom rstudioapi hasFun getSourceEditorContext
#' @noRd
#' @keywords internal
cppcheck_addin_file <- function(){
  if(!hasFun("getSourceEditorContext")){
    stop("Your RStudio version is too old.", call. = FALSE)
  }
  context <- getSourceEditorContext()
  path <- context[["path"]]
  if(path == ""){
    stop("You have to save your file.")
  }
  cppcheckR(path)
}

#' @importFrom rstudioapi hasFun getSourceEditorContext
#' @noRd
#' @keywords internal
cppcheck_addin_folder <- function(){
  if(!hasFun("getSourceEditorContext")){
    stop("Your RStudio version is too old.", call. = FALSE)
  }
  context <- getSourceEditorContext()
  path <- context[["path"]]
  if(path == ""){
    stop("You have to save your file.")
  }
  cppcheckR(dirname(path))
}

#' Shiny bindings for cppcheckR
#'
#' Output and render functions for using cppcheckR within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a cppcheckR
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name cppcheckR-shiny
#'
#' @export
cppcheckROutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'cppcheckR', width, height, package = 'cppcheckR')
}

#' @rdname cppcheckR-shiny
#' @export
renderCppcheckR <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, cppcheckROutput, env, quoted = TRUE)
}
