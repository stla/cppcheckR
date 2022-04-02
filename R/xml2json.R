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
  ctx$source(fxp)
  ctx$source(jsfile)
  ctx$call("xml2json", URLencode(xml), spaces, opts)
}
