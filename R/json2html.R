pandocBlock <- function(json){
  c(
    "~~~~ {.json .numberLines}",
    json,
    "~~~~"
  )
}

pandocHTML <- function(div){
  html <- c(
    "<!DOCTYPE html>",
    "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"\" xml:lang=\"\">",
    "  <head>",
    "    <meta charset=\"utf-8\" />",
    "    <meta name=\"generator\" content=\"pandoc\" />",
    "    <meta",
    "      name=\"viewport\"",
    "      content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"",
    "    />",
    "    <title></title>",
    "    <style type=\"text/css\">",
    "      pre.sourceCode {",
    "        white-space: pre-wrap;",
    "        font-size: 15px;",
    "        font-weight: bold;",
    "        outline: #051C55 solid 10px;",
    "      }",
    "      code {",
    "        white-space: pre-wrap;",
    "      }",
    "      span.smallcaps {",
    "        font-variant: small-caps;",
    "      }",
    "      span.underline {",
    "        text-decoration: underline;",
    "      }",
    "      div.column {",
    "        display: inline-block;",
    "        vertical-align: top;",
    "        width: 50%;",
    "      }",
    "    </style>",
    "    <style type=\"text/css\">",
    "      a.sourceLine {",
    "        display: inline-block;",
    "        line-height: 1.25;",
    "      }",
    "      a.sourceLine {",
    "        pointer-events: none;",
    "        color: inherit;",
    "        text-decoration: inherit;",
    "      }",
    "      a.sourceLine:empty {",
    "        height: 1.2em;",
    "      }",
    "      .sourceCode {",
    "        overflow: visible;",
    "      }",
    "      code.sourceCode {",
    "        white-space: pre;",
    "        position: relative;",
    "      }",
    "      div.sourceCode {",
    "        width: fit-content;",
    "        margin: 1em 0;",
    "      }",
    "      pre.sourceCode {",
    "        margin: 0;",
    "      }",
    "      @media screen {",
    "        div.sourceCode {",
    "          overflow: auto;",
    "        }",
    "      }",
    "      @media print {",
    "        code.sourceCode {",
    "          white-space: pre-wrap;",
    "        }",
    "        a.sourceLine {",
    "          text-indent: -1em;",
    "          padding-left: 1em;",
    "        }",
    "      }",
    "      pre.numberSource a.sourceLine {",
    "        position: relative;",
    "        left: -4em;",
    "      }",
    "      pre.numberSource a.sourceLine::before {",
    "        content: attr(data-line-number);",
    "        position: relative;",
    "        left: -1em;",
    "        text-align: right;",
    "        vertical-align: baseline;",
    "        border: none;",
    "        pointer-events: all;",
    "        display: inline-block;",
    "        -webkit-touch-callout: none;",
    "        -webkit-user-select: none;",
    "        -khtml-user-select: none;",
    "        -moz-user-select: none;",
    "        -ms-user-select: none;",
    "        user-select: none;",
    "        padding: 0 4px;",
    "        width: 4em;",
    "        background-color: #051c55;",
    "        color: #e76900;",
    "      }",
    "      pre.numberSource {",
    "        margin-left: 3em;",
    "        border-left: 1px solid #e76900;",
    "        padding-left: 4px;",
    "      }",
    "      div.sourceCode {",
    "        color: #e76900;",
    "        background-color: #051c55;",
    "      }",
    "      @media screen {",
    "        a.sourceLine::before {",
    "          text-decoration: underline;",
    "        }",
    "      }",
    "      code span.al {",
    "        color: #ffff00;",
    "      } /* Alert */",
    "      code span.an {",
    "        color: #0066ff;",
    "        font-weight: bold;",
    "        font-style: italic;",
    "      } /* Annotation */",
    "      code span.at {",
    "      } /* Attribute */",
    "      code span.bn {",
    "        color: #44aa43;",
    "      } /* BaseN */",
    "      code span.bu {",
    "      } /* BuiltIn */",
    "      code span.cf {",
    "        color: #43a8ed;",
    "        font-weight: bold;",
    "      } /* ControlFlow */",
    "      code span.ch {",
    "        color: #f08080;",
    "      } /* Char */",
    "      code span.cn {",
    "      } /* Constant */",
    "      code span.co {",
    "        color: #0066ff;",
    "        font-weight: bold;",
    "        font-style: italic;",
    "      } /* Comment */",
    "      code span.do {",
    "        color: #0066ff;",
    "        font-style: italic;",
    "      } /* Documentation */",
    "      code span.dt {",
    "        color: #ed143d;",
    "      } /* DataType */",
    "      code span.dv {",
    "        color: #7fff00;",
    "      } /* DecVal */",
    "      code span.er {",
    "        color: #ffff00;",
    "        font-weight: bold;",
    "      } /* Error */",
    "      code span.ex {",
    "      } /* Extension */",
    "      code span.fl {",
    "        color: #44aa43;",
    "      } /* Float */",
    "      code span.fu {",
    "      } /* Function */",
    "      code span.im {",
    "      } /* Import */",
    "      code span.in {",
    "        color: #0066ff;",
    "        font-weight: bold;",
    "        font-style: italic;",
    "      } /* Information */",
    "      code span.kw {",
    "        color: #43a8ed;",
    "        font-weight: bold;",
    "      } /* Keyword */",
    "      code span.op {",
    "      } /* Operator */",
    "      code span.pp {",
    "        font-weight: bold;",
    "      } /* Preprocessor */",
    "      code span.sc {",
    "        color: #049b0a;",
    "      } /* SpecialChar */",
    "      code span.ss {",
    "        color: #049b0a;",
    "      } /* SpecialString */",
    "      code span.st {",
    "        color: #f08080;",
    "      } /* String */",
    "      code span.va {",
    "      } /* Variable */",
    "      code span.vs {",
    "        color: #049b0a;",
    "      } /* VerbatimString */",
    "      code span.wa {",
    "        color: #ffff00;",
    "        font-weight: bold;",
    "      } /* Warning */",
    "    </style>",
    "    <!--[if lt IE 9]>",
    "      <script src=\"//cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv-printshiv.min.js\"></script>",
    "    <![endif]-->",
    "  </head>",
    "  <body>",
    div,
    "  </body>",
    "</html>"
  )
  paste0(html, collapse = "\n")
}

#' @title JSON to HTML
#' @description Render a formatted JSON string in HTML.
#'
#' @param json a JSON string or a path to a JSON file
#' @param outfile either a path to a html file, or \code{NULL} if you don't
#'   want to write the output to a file
#' @param pandoc Boolean, whether to use pandoc
#' @param style some CSS for the container, only if \code{pandoc=FALSE}
#' @param keyColor color of the keys, only if \code{pandoc=FALSE}
#' @param numberColor color of the numbers, only if \code{pandoc=FALSE}
#' @param stringColor color of the strings, only if \code{pandoc=FALSE}
#' @param trueColor color of the \code{true} keyword, only
#'   if \code{pandoc=FALSE}
#' @param falseColor color of the \code{false} keyword, only
#'   if \code{pandoc=FALSE}
#' @param nullColor color of the \code{null} keyword, only
#'   if \code{pandoc=FALSE}
#'
#' @return Nothing if \code{outfile} is not \code{NULL}, otherwise the HtML
#'   as a character string.
#' @export
#'
#' @importFrom V8 v8
#' @importFrom utils URLencode
#' @importFrom rmarkdown find_pandoc
#'
#' @examples
#' library(cppcheckR)
#' xml <- system.file("extdata", "order-schema.xml", package = "xml2")
#' json <- xml2json(xml)
#' html <- json2html(json)
#' library(htmltools)
#' if(interactive()){
#'   browsable(HTML(html))
#' }
#' # with pandoc
#' html <- json2html(json, pandoc = TRUE)
#' if(interactive()){
#'   browsable(HTML(html))
#' }
json2html <- function(
  json,
  outfile = NULL,
  pandoc = FALSE,
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
    json <- readLines(json)
  }
  if(pandoc){
    if(Sys.which("pandoc") == ""){
      message("'pandoc' is not in the PATH; trying to find it.")
      p <- find_pandoc()
      if(!is.null(p$dir)){
        message(sprintf("'pandoc' %s found in '%s'.", p$version, p$dir))
        pandoc <- file.path(p$dir, "pandoc")
      }else{
        message("'pandoc' not found; switching to the other method.")
      }
    }else{
      pandoc <- "pandoc"
    }
    if(is.character(pandoc)){
      block <- pandocBlock(json)
      mdfile <- tempfile(fileext = ".md")
      writeLines(block, mdfile)
      div <- system2(pandoc, c(mdfile, "-t html"), stdout = TRUE)
      html <- pandocHTML(div)
      if(!is.null(outfile)){
        writeLines(html, outfile)
        return(invisible(NULL))
      }else{
        return(html)
      }
    }
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
  json <- paste0(json, collapse = "\n")
  innerHTML <- ctx$call("json2html", URLencode(json), colors)
  pre <- sprintf('    <pre style="%s">%s</pre>', style, innerHTML)
  html <- c(
    "<!DOCTYPE html>",
    "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"\" xml:lang=\"\">",
    "  <head>",
    "    <meta charset=\"utf-8\" />",
    "    <meta name=\"generator\" content=\"json-format-highlight.js\" />",
    "    <meta",
    "      name=\"viewport\"",
    "      content=\"width=device-width, initial-scale=1.0, user-scalable=yes\"",
    "    />",
    "    <title>Cppcheck</title>",
    "  </head>",
    "  <body>",
    pre,
    "  </body>",
    "</html>"
  )
  html <- paste0(html, collapse = "\n")
  if(!is.null(outfile)){
    writeLines(html, outfile)
    invisible(NULL)
  }else{
    html
  }
}
