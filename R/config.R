# fileConfig <- "~/.R/curlR.yaml" # system.file("~/config.json", package = "curlR")
# fileConfig <- system.file("config/curlR.yaml", package = "curlR")
fileConfig <- system.file(package = "curlR") %>% paste0("/config/config.json")

#' curlR configurations
#' @name config
#'
#' @import configr
#' @export
get_config <- function(name) {
  # fileConfig <- normalizePath(fileConfig)
  config <- read.config(fileConfig)
  if (isFALSE(config)) {
    message(sprintf("[e] %s: malformat!", suppressWarnings(normalizePath(fileConfig))))
    return()
  }
  config <- config[[name]]
  ind <- config$default
  if (is.null(ind)) ind <- 1
  config$users[[ind]]
}

#' @rdname config
#' @importFrom utils file.edit
#' @export
edit_config <- function() {
  tryCatch(
    {
      code(fileConfig)
    },
    error = function(e) {
      message(sprintf("%s", e$message))
      file.edit(fileConfig)
    }
  )
}
