#' kill process
#'
#' @param pid
#' - character: process name
#' - numeric: process id
#'
#' @export
taskkill <- function(pid) {
  name <- pid
  if (length(pid) == 0 || is.na(pid[1])) {
    message(glue("[ok] no corresponding PID"))
    return()
  }
  if (OS == "windows") {
    if (tools::file_ext(name) != "exe") name %<>% paste0(".exe")

    if (is.character(pid)) {
      system(glue("taskkill /IM {name} -f"))
    }
    if (is.numeric(pid)) {
      system(glue('taskkill /FI "PID eq {pid}" -f'))
    }
  } else if (OS == "unix") {
    if (is.character(pid)) {
      system(glue("pkill -f {name} -9"))
    }
    if (is.numeric(pid)) {
      system(glue("kill -9 {pid}"))
    }
  }
  invisible()
}

#' @export
getPidByPort <- function(port = 4444) {
  # lsof -i -P -n | grep LISTEN | grep 4444
  OS <- .Platform$OS.type
  pid <- suppressWarnings({
    if (OS == "windows") {
      r <- shell(glue("netstat -a -n -o | grep {port} | grep LISTEN"), intern = TRUE)
      str_extract(r, "(?<=LISTENING\\s{1,20})\\d{1,}") %>% unique()
    } else {
      cmd <- glue('netstat -tulpn | grep "{port} " | grep LISTEN')
      print(cmd)
      r <- system(cmd, intern = TRUE, ignore.stderr = TRUE)
      str_extract(r, "(?<=LISTEN\\s{1,20})\\d{1,}") %>% unique()
    }
  })
  as.numeric(pid)
}
