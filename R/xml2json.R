#' @title XML to JSON
#' @description Convert XML to a JSON string.
#'
#' @param xml either a XML file or some XML given as a character string
#' @param spaces an integer, the indentation
#' @param linebreaks Boolean, whether to break the lines in the JSON string
#'   when there are some linebreaks; this generates an invalid JSON string
#' @param replacer character vector, the body of the second argument of
#'   \code{JSON.stringify} (the replacer function), or \code{NULL}
#' @param attributeNamePrefix prefix for the attributes
#' @param textNodeName name of text nodes, which appear for nodes which have
#'   both a text content and some attributes
#' @param ignoreAttributes Boolean, whether to ignore the attributes
#' @param ignoreNameSpace Boolean, whether to ignore the namespaces
#' @param parseNodeValue Boolean, whether to parse the node values to numbers
#'   if possible
#' @param parseAttributeValue Boolean, whether to parse the attribute values to
#'   numbers if possible
#' @param trimValues Boolean, whether to trim the values
#'
#' @return A JSON string.
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
  linebreaks = FALSE,
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
