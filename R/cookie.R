## 1. httr ---------------------------------------------------------------------

#' once cookie exist, it's impossible to update by set_cookie
#' @name set_cookie
#'
#' @param cookiefile path of cookie file
NULL

#' set_config() works globaly, but will not return cookie to reponse object.
#' Reversely, set_cookies() works locally, and return cookie to response object.
#'
#' @rdname set_cookie
#' @export
set_cookie_file <- function(cookiefile = "cookies.txt") {
  if (file.exists(cookiefile)) {
    d <- read.csv(cookiefile)
    cookies <- set_names(d$value, d$name)
    config <- set_cookies(cookies)
    # set_config(config, override = TRUE)
    config
  } else {
    message("cookiefile not exist ... ")
    NULL
  }
}

#' @export
get_cookie <- function(str_cookie) {
  xs <- str_split(str_cookie, "; ")[[1]]
  name <- str_extract(xs, ".*(?==)")
  value <- str_extract(xs, "(?<==).*")
  set_names(value, name)
}

#' @export
set_cookie_chr <- function(str_cookie) {
  cookies <- get_cookie(str_cookie)
  set_config(set_cookies(cookies))
}

#' @param cookies data.frame object, at least with "name" and "value".
#' @rdname set_cookie
#'
#' @importFrom data.table fwrite
#' @export
write_cookie <- function(cookies, cookiefile = "cookies.txt") {
  if (nrow(cookies) > 0) {
    fwrite(cookies, cookiefile)
  }
}

#' request url with cookiefile
#'
#' @inheritParams set_cookie
#' @param ... other parameters will be passed to [GET()] or [POST()]
#'
#' @export
GET2 <- function(..., cookiefile = "cookies.txt") {
  p <- GET(..., set_cookie_file(cookiefile))
  write_cookie(p$cookies, cookiefile)
  p
}

#' @rdname GET2
#' @export
POST2 <- function(..., cookiefile = "cookies.txt") {
  p <- POST(..., set_cookie_file(cookiefile))
  write_cookie(p$cookies, cookiefile)
  p
}

query_cookiefile <- function(...) {
  p <- GET2("http://httpbin.org/cookies", ...)
  print(p)
  print(p$cookies)
}

#' @export
cookies2list <- function(cookies) {
  strsplit(cookies, ";")[[1]] %>%
    ldply(function(x) strsplit(x, "=")[[1]]) %>%
    {
      set_names(as.list(.[, 2]), .[, 1])
    }
}



## 2. RSelenium ----------------------------------------------------------------

tidy_cookie <- function(lst, file = NULL) {
  dt <- list2dt(lst) %>% dplyr::relocate(name, value, path, domain, secure)

  if (!is.null(file)) {
    # write.table(dt, file, row.names = FALSE, sep = "\t")
    fwrite(dt, file)
  }
  dt
}

#' @export
cookie_save <- function(file = "cookies.txt") {
  p <- get_browser()
  cookies <- p$getAllCookies()
  # convert list of list to data.frame
  dt = tidy_cookie(cookies)
  # if (verbose) print(dt)
  if (!is.null(file)) fwrite(dt, file)
  dt
}

#' @importFrom data.table fread fwrite
#' @importFrom seleniumPipes addCookie
#' @export 
cookie_load <- function(file = "cookies.txt") {
  p <- get_browser()
  cookies <- fread(file)

  for (i in 1:nrow(cookies)) {
    l = cookies[i, ]
    tryCatch({
      l %$% {
        p$addCookie(name, value, path, domain, 
        secure = secure, httpOnly = httpOnly)
      }
    }, error = function(e) {
      message(sprintf('%s', e$message))
    })
  }
  p$refresh()
  invisible()
}
