#' Title
#'
#' @param json
#'
#' @return
#' @export
#'
#' @importFrom V8 v8
#' @importFrom utils URLencode
#'
#' @examples
#       keyColor: "crimson",
#       numberColor: "chartreuse",
#       stringColor: "lightcoral",
#       trueColor: "#00cc00",
#       falseColor: "#ff8080",
#       nullColor: "cornflowerblue"
json2html <- function(
  json,
  style = paste0(
    "background-color: #051C55; color: #E76900; ",
    "font-size: 15px; font-weight: bold; margin: 0; ",
    "white-space: pre-wrap; outline: #051C55 solid 10px;"
  ),
  keyColor = "crimson",
  numberColor = "chartreuse",
  stringColor = "lightcoral",
  trueColor = "#00cc00",
  falseColor = "#ff8080",
  nullColor = "cornflowerblue"
){
  if(file.exists(json)){
    json <- paste0(readLines(json), collapse = "\n")
  }
  jfh <- system.file(
    "htmlwidgets", "lib", "json-format-highlight.js", package = "cppcheckR"
  )
  jsfile <- system.file("V8", "json2html.js", package = "cppcheckR")
  colors <- list(
    keyColor    = keyColor,
    numberColor = numberColor,
    stringColor = stringColor,
    trueColor   = trueColor,
    falseColor  = falseColor,
    nullColor   = nullColor
  )
  ctx <- v8()
  ctx$source(jfh)
  ctx$source(jsfile)
  innerHTML <- ctx$call("json2html", URLencode(json), colors)
  sprintf('<pre style="%s">%s</pre>', style, innerHTML)
}
