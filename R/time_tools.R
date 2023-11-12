#' timeinfo
#'
#' @param time POSIXct or time character, e.g. "1998-01-01 01:00:00"
#' @return A data.table with the columns of:
#' - `year`    : int
#' - `month`   : int
#' - `day`     : int
#' - `hour`    : int
#' - `time`    : time character, e.g. "2021-10-16 14:25:35"
#' - `timenum` : difference of `time` to `1970-01-01` (in second), e.g. `1634365535.959902`
#'
#' @examples
#' timeinfo()
#' time_round()
#' @export
timeinfo <- function(time = Sys.time()) {
  data.table(
    year = year(time), month = month(time), day = day(time), hour = hour(time),
    timestr = time2str(time), timenum = time2num(time)
  )
}

# in the unit of second
#' @rdname timeinfo
#' @export
time2num <- function(time) as.integer(num2time(time))

#' @param num difference of `time` to `1970-01-01` (in second), e.g. `1634365535.959902`
#' @export
#' @rdname timeinfo
num2time <- function(num) {
  as.POSIXct(num, origin = "1970-01-01")
}

#' @rdname timeinfo
#' @export
time2str <- function(time) format(time, format = "%Y-%m-%d %H:%M:%S")

#' @rdname timeinfo
#' @export
time_round <- function(time = Sys.time()) format(time, "%Y-%m-%d %H:00:00") %>% as.POSIXct()

# "%Y%m%d-%H%M%S"
#' @rdname timeinfo
#' @export
guess_time <- function(file, format = "%Y-%m-%d_%H00") {
  str <- str_extract(basename(file), "\\d{4}-\\d{2}-\\d{2}_\\d{4}") # "1998-01-01_0100"
  as.POSIXct(str, format = format) %>% format("%Y-%m-%d %H:%M:%S")
  # "%Y-%m-%d_%H00"
}

#' format POSIXt
#' @export
format_POSIXt <- function(date) {
  format(date, "%Y-%m-%d %H:%M:00")
}

#' @import lubridate
#' @export
add_month <- function(x, n) {
  year <- year(x)
  month <- month(x)
  day <- day(x)

  month <- month + n
  if (month > 12) {
    year <- year + floor((month - 1) / 12)
    month <- ((month - 1) %% 12) + 1
  }
  make_date(year, month, day)
}

#' @export
seq_month <- function(date_begin, date_end, by = 12) {
  dates <- seq(date_begin, date_end, by = "month")
  dates[seq(1, length(dates), by)]
}

#' timestamp
#'
#' @return time stamp, just like 1498029994455 (length of 13)
#' @export
timestamp <- function() as.character(floor(as.numeric(Sys.time()) * 1000))

#' @rdname timestamp
#' @export
datestamp <- timestamp

#' @export
millisec2date <- function(x, scale = 1000) {
  if (is.character(x)) x <- as.numeric(x)
  as.POSIXct(x / scale, origin = "1970-01-01") %>% as.Date(tz = "")
}
