isFile <- function(path){
  file.exists(path) && !dir.exists(path)
}

# isRcppFile <- function(path){
#   if(!isFile(path)){
#     return(FALSE)
#   }
#   fileLines <- readLines(path)
#   nlines <- length(fileLines)
#   i <- 0L
#   test <- TRUE
#   while(test && i < nlines){
#     i <- i + 1L
#     test <- !grepl("Rcpp", fileLines[i], fixed = TRUE)
#   }
#   !test
# }
#
# getRcppDeps <- function(path){
#   lines <- readLines(path)
#   indices <- grep("\\W+Rcpp::depends\\((\\w+)\\)\\W+", lines)
#   unique(sub("\\W+Rcpp::depends\\((\\w+)\\)\\W+", "\\1", lines[indices]))
# }

#' @importFrom xml2 read_xml as_list xml_child xml_length xml_remove xml_contents
#' @noRd
cppcheck <- function(
  path, std, def, undef, checkConfig
){
  if(Sys.which("cppcheck") == ""){
    stop("This package requires 'cppcheck' and it doesn't find it.")
  }
  TMPDIR <- tempdir()
  args <-
    c(
      "--xml",
      "--force",
      "--enable=all",
      "--verbose",
      paste0("--std=", std),
      "--suppress=ConfigurationNotChecked",
      "--suppress=missingIncludeSystem",
      sprintf("--cppcheck-build-dir=%s", TMPDIR)
    )
  for(d in def){
    args <- c(args, paste0("-D", d))
  }
  for(u in undef){
    args <- c(args, paste0("-U", u))
  }
  if(checkConfig){
    args <- c(args, "--check-config")
  }
  # if(Rcpp){
  #   Rcpp_include <- system.file("include", package = "Rcpp")
  #   args <- c(
  #     args,
  #     # paste0("--include=", file.path(Rcpp_include, "Rcpp.h")),
  #     paste0("-I", Rcpp_include),
  #     sprintf("--suppress=*:%s/*", Rcpp_include)
  #   )#, paste0("-i", Rcpp_include))
  #   if(dir.exists(path) && "RcppExports.cpp" %in% list.files(path)){
  #     exclude <- path.expand(file.path(path, "RcppExports.cpp"))
  #     args <- c(args, paste0("-i", exclude))
  #   }
  #   for(dep in RcppDeps){
  #     dep_include <- system.file("include", package = dep)
  #     # hfile <- file.path(dep_include, paste0(dep, ".h"))
  #     # if(!file.exists(hfile)){
  #     #   next
  #     # }
  #     args <- c(
  #       args,
  #       # paste0("--include=", hfile),
  #       paste0("-I", dep_include),
  #       sprintf("--suppress=*:%s/*", dep_include)
  #     )
  #   }
  # }
  # if(!is.null(include)){
  #   args <- c(args, paste0("-I", include))
  # }
  pathtype <- "folder"
  if(isFile(path)){
    pathtype <- "file"
  }
  msg <- sprintf("Running Cppcheck on %s '%s' with options:\n", pathtype, path)
  message(msg, paste0(args, "\n"))
  args <- c(args, path)
  xmlFile <- tempfile(fileext = ".xml")
  CPPCHECK <- suppressWarnings(
    system2("cppcheck", args, stdout = FALSE, stderr = xmlFile)
  )
  if(!is.null(attr(CPPCHECK, "status"))){
    stop(CPPCHECK)
  }
  XML <- read_xml(xmlFile)
  errors <- xml_child(XML, "errors")
  if(xml_length(errors) == 0L){
    xml_remove(xml_contents(errors))
  }
  as.character(XML)
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

cppcheck_prompt_std <- function(){
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

cppcheck_prompt_def <- function(){
  def <- character(0L)
  symbol <- "x"
  while(symbol != ""){
    cat("Enter a symbol you want to define:\n")
    symbol <- readline("Leave blank to exit. ")
    if(symbol != ""){
      def <- c(def, symbol)
    }
  }
  def
}

cppcheck_prompt_undef <- function(){
  undef <- character(0L)
  symbol <- "x"
  while(symbol != ""){
    cat("Enter a symbol you want to undefine:\n")
    symbol <- readline("Leave blank to exit. ")
    if(symbol != ""){
      undef <- c(undef, symbol)
    }
  }
  undef
}

# # @importFrom pkgload pkg_path
# # @noRd
# pkgPath <- function(path){
#   tryCatch({
#     pkg_path(path)
#   }, error = function(e){
#     NULL
#   })
# }
#
# # @importFrom pkgload pkg_desc
# # @noRd
# getOptions <- function(path){
#   if(!file.exists(path)){
#     stop("Invalid path.")
#   }
#   pPath <- pkgPath(path)
#   RcppDeps <- character(0L)
#   include <- NULL
#   if(!is.null(pPath)){
#     desc <- pkg_desc(pPath)
#     Rcpp <- desc$has_dep("Rcpp", "LinkingTo")
#     if(Rcpp){
#       RcppDeps <-
#         setdiff(strsplit(desc$get_field("LinkingTo"), ", ")[[1L]], "Rcpp")
#       suggested <- tryCatch({
#         strsplit(desc$get_field("Suggests"), ", ")[[1L]]
#       }, error = function(e){
#         NULL
#       })
#       if(!is.null(suggested)){
#         if("BH" %in% suggested){
#           RcppDeps <- c(RcppDeps, "BH")
#         }
#         rcpp <- grep("^Rcpp", suggested, value = TRUE)
#         RcppDeps <- c(RcppDeps, rcpp)
#       }
#     }
#     include <- file.path(pPath, "inst", "include")
#     if(!dir.exists(include)){
#       include <- NULL
#     }
#   }else if(isFile(path)){
#     hfiles <- list.files(dirname(path), "\\.h$", full.names = TRUE)
#     files <- c(path, hfiles)
#     Rcpp <- FALSE
#     for(f in files){
#       if(isRcppFile(f)){
#         Rcpp <- TRUE
#         break
#       }
#     }
#     if(Rcpp){
#       for(f in files){
#         RcppDeps <- c(RcppDeps, getRcppDeps(f))
#       }
#       RcppDeps <- unique(RcppDeps)
#     }
#   }else{ # path is a folder
#     files <- list.files(path, "[\\.cpp|\\.h]$", full.names = TRUE)
#     Rcpp <- FALSE
#     for(f in files){
#       if(isRcppFile(f)){
#         Rcpp <- TRUE
#         break
#       }
#     }
#     if(Rcpp){
#       for(f in files){
#         RcppDeps <- c(RcppDeps, getRcppDeps(f))
#       }
#       RcppDeps <- unique(RcppDeps)
#     }
#   }
#   list(Rcpp = Rcpp, RcppDeps = RcppDeps, include = include)
# }


#' @title Check a C/C++ file or a folder
#'
#' @description HTML widget which runs \strong{Cppcheck}.
#'
#' @param path path to a C/C++ file or to a folder containing C/C++ files
#' @param std the standard, one of \code{"c89"}, \code{"c99"}, \code{"c11"},
#'   \code{"c++03"}, \code{"c++11"}, \code{"c++14"}, \code{"c++17"},
#'   \code{"c++20"}; if \code{NULL}, you will be prompted to select it
#' @param def character vector of symbols you want to define, e.g.
#'   \code{"__cplusplus"} or \code{"DEBUG=1"}; if \code{NULL},
#'   you will be prompted to enter them; set \code{def=NA} if you don't want
#'   to define any symbol
#' @param undef character vector of symbols you want to undefine;
#'   if \code{NULL}, you will be prompted to enter them; set \code{undef=NA}
#'   if you don't want to undefine any symbol
#' @param checkConfig Boolean, whether to run \strong{Cppcheck} with the
#'   option \code{--check-config}; this tells you which header files are missing
#' @param height height in pixels (defaults to automatic sizing)
#' @param elementId an id for the widget, this is usually useless
#'
#' @return A \code{htmlwidget} object.
#'
#' @importFrom htmlwidgets createWidget
#' @importFrom utils URLencode
#' @importFrom rstudioapi isAvailable
#'
#' @export
#' @examples
#' example <- function(file){
#'   filepath <- system.file("cppexamples", file, package = "cppcheckR")
#'   lines <- readLines(filepath)
#'   print(cppcheckR(filepath, std = "c++03", def = NA, undef = NA))
#'   message(file, ":")
#'   cat(paste0(format(seq_along(lines)), ". ", lines), sep = "\n")
#' }
#' example("memleak.cpp")
#' example("outofbounds.cpp")
#' example("unusedvar.cpp")
#' example("useless.cpp")
cppcheckR <- function(
  path, std = NULL, def = NULL, undef = NULL, checkConfig = FALSE,
  height = NULL, elementId = NULL
){

  if(Sys.which("cppcheck") == ""){
    return(
      createWidget(
        name = "cppcheckR",
        list(notfound = TRUE),
        width = "90vw",
        height = "auto",
        package = "cppcheckR",
        elementId = elementId
      )
    )
  }

  if(!is.null(std)){
    std <- match.arg(std, standards())
  }else{
    std <- cppcheck_prompt_std()
  }
  if(is.null(def)){
    def <- cppcheck_prompt_def()
  }else if(length(def) == 0L || is.na(def)){
    def <- NULL
  }
  if(is.null(undef)){
    undef <- cppcheck_prompt_undef()
  }else if(length(undef) == 0L || is.na(undef)){
    undef <- NULL
  }
  # opts <- getOptions(path)
  cppcheckResults <- cppcheck(
    path = path, std = std, def = def, undef = undef,
    checkConfig = checkConfig
  )

  if(isFile(path)){
    title <- basename(path)
  }else{
    title <- basename(normalizePath(path))
  }

  # forward options using x
  x = list(
    title = title,
    xmlContent = URLencode(cppcheckResults),
    rstudio = isAvailable()
  )

  # create widget
  createWidget(
    name = "cppcheckR",
    x,
    width = NULL,
    height = height,
    package = "cppcheckR",
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

#' @title Shiny bindings for \code{cppcheckR}
#'
#' @description Output and render functions for using \code{cppcheckR} within
#'   Shiny applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height a valid CSS unit (like \code{"100\%"},
#'   \code{"400px"}, \code{"auto"}) or a number, which will be coerced to a
#'   string and have \code{"px"} appended
#' @param expr an expression that generates a '\code{\link{cppcheckR}}' widget
#' @param env the environment in which to evaluate \code{expr}
#' @param quoted logical, whether \code{expr} is a quoted expression (with
#'   \code{quote()})
#'
#' @return \code{cppcheckROutput} returns an output element that can be
#'   included in a Shiny UI definition, and \code{renderCppcheckRR} returns a
#'   \code{shiny.render.function} object that can be included in a Shiny server
#'   definition.
#'
#' @importFrom htmlwidgets shinyWidgetOutput shinyRenderWidget
#'
#' @name cppcheckR-shiny
#'
#' @export
cppcheckROutput <- function(outputId, width = "100%", height = "400px"){
  shinyWidgetOutput(outputId, "cppcheckR", width, height, package = "cppcheckR")
}

#' @rdname cppcheckR-shiny
#' @export
renderCppcheckR <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, cppcheckROutput, env, quoted = TRUE)
}


#' @title Shiny application to check C/C++
#' @description Run a shiny application to check C/C++ files.
#'
#' @return Nothing, this just launches a Shiny app.
#'
#' @note The packages listed in the \strong{Suggests} field of the
#'   package description are required.
#'
#' @importFrom shiny shinyAppDir
#' @export
shinyCppcheck <- function(){
  shinyAppDir(system.file("shinyapp", package = "cppcheckR"))
}
