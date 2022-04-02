#' Title
#'
#' @param xml
#' @param spaces
#' @param attributeNamePrefix
#' @param textNodeName
#' @param ignoreAttributes
#' @param ignoreNameSpace
#' @param parseNodeValue
#' @param parseAttributeValue
#' @param trimValues
#'
#' @return
#' @export
#'
#' @importFrom V8 v8
#' @importFrom utils URLencode
#'
#' @examples
xml2json <- function(
  xml,
  spaces = 2L,
  attributeNamePrefix = "@_",
  textNodeName = "#text",
  ignoreAttributes = FALSE,
  ignoreNameSpace = FALSE,
  parseNodeValue = TRUE,
  parseAttributeValue = TRUE,
  trimValues = TRUE
){
  if(file.exists(xml)){
    xml <- paste0(readLines(xml), collapse = "\n")
  }
  opts <- list(
    attributeNamePrefix = attributeNamePrefix,
    textNodeName        = textNodeName,
    ignoreAttributes    = ignoreAttributes,
    ignoreNameSpace     = ignoreNameSpace,
    parseNodeValue      = parseNodeValue,
    parseAttributeValue = parseAttributeValue,
    trimValues          = trimValues
  )
  fxp <- system.file("htmlwidgets", "lib", "fxp.min.js", package = "cppcheckR")
  jsfile <- system.file("V8", "xml2json.js", package = "cppcheckR")
  ctx <- v8()
  ctx$source(fxp)
  ctx$source(jsfile)
  ctx$call("xml2json", URLencode(xml), spaces, opts)
}
