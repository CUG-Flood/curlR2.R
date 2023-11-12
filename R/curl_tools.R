#' xml_json
#' @param x request object
#'
#' @importFrom jsonlite fromJSON
#' @export
xml_json <- function(x) {
  content(x, encoding = "utf-8") %>%
    xml_text() %>%
    fromJSON()
}

#' @export
xml_check <- function(x) {
  if (class(x)[1] %in% c("xml_document", "xml_node")) x else read_html(x)
}

#' html_inputs
#' @param p requested object from httr
#' @param xpath A string containing a xpath (1.0) expression.
#'
#' @export
html_inputs <- function(p, xpath = "//input") {
  xml_check(p) %>%
    xml_find_all(xpath) %>%
    {
      setNames(as.list(xml_attr(., "value")), xml_attr(., "name"))
    }
}


#' @export
save_html <- function(x, file = "kong.html") write_xml(xml_check(x), file)


ele_save_html <- function(file = "kong.html") {
  p <- get_browser()
  save_html(p$getPageSource()[[1]], file)
}

html_body <- function(p, xpath = "//body") xml_find_all(xml_check(p), xpath)
