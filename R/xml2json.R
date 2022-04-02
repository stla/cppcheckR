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
#' @importFrom htmlwidgets JS
#' @importFrom utils URLencode
#'
#' @examples
#' xml <- system.file("extdata", "order-schema.xml", package = "xml2")
#' cat(xml2json(xml))
#' #
#' js <- c(
#'   'if(key === "@_type"){',
#'   '  return undefined;',
#'   '} else if(key === "@_name"){',
#'   '  return value.toUpperCase();',
#'   '}',
#'   'return value;'
#' )
#' cat(xml2json(xml, linebreaks = TRUE, replacer = js))
xml2json <- function(
  xml,
  spaces = 2L,
  linebreaks = TRUE,
  replacer = NULL,
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
  if(!is.null(replacer)){
    replacer <- JS(c("function replacer(key, value) {", replacer, "}"))
  }
  fxp <- system.file("htmlwidgets", "lib", "fxp.min.js", package = "cppcheckR")
  jsfile <- system.file("V8", "xml2json.js", package = "cppcheckR")
  ctx <- v8()
  ctx$source(fxp)
  ctx$source(jsfile)
  ctx$call("xml2json", URLencode(xml), spaces, opts, linebreaks, replacer)
}
