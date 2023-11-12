#' RETRY2
#' @examples
#' RETRY2(1)
#' # RETRY2(stop(1))
#'
#' @export
RETRY2 <- function(expr, sec = 1, times = 10) {
  res <- NULL
  for (i in 1:times) {
    ans <- tryCatch(
      {
        res <- eval(expr)
        break
      },
      error = function(e) {
        cat(sprintf("  | %d_th times retry ...\n", i))
        Sys.sleep(sec)
      }
    )
  }
  res
}


self <- function(x) {
  x
}

#' @keywords internal
#' @export
fill_NULL <- function(x) {
  x[which.isnull(x)] <- NA
  x
}

rm_empty <- function(x) {
  if (is.list(x)) {
    x[!sapply(x, is_empty)]
  } else {
    x[!is.na(x)]
  }
}

#' @importFrom data.table as.data.table
list2dt <- function(lst) {
  l <- lapply(lst, as.data.table)
  l$fill <- TRUE
  d <- do.call(rbind, l)
  d
}

#' split into nchunks
#'
#' @param x numeric vector or list
#' @param nchunk integer
#'
#' @export
chunk <- function(x, nchunk) {
  len <- length(x)
  if (nchunk == 1) {
    list(x)
  } else {
    split(x, cut(seq_along(x), nchunk, labels = FALSE))
  }
}

#' @export
setwd2 <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
  setwd(path)
}
