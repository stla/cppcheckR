.onAttach <- function(...) {
  if(!interactive()) return()
  if(Sys.which("cppcheck") == ""){
    packageStartupMessage(
      "The 'cppcheck' command has not been found. ",
      "You cannot use this package, ",
      "except the functions 'xml2json' and 'json2html'."
    )
  }
}
