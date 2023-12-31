#' convert Raw format string into the real raw format variable
#'
#' @param str format string
#' @return raw vector
#'
#' @examples
#' \dontrun{
#' key_p <- "EB2A38568661887FA180BDDB5CABD5F21C7BFD59C090CB2D245A87AC253062882729
#' 293E5506350508E7F9AA3BB77F4333231490F915F6D63C55FE2F08A49B353F444AD3993CACC02D
#' B784ABBB8E42A9B1BBFFFB38BE18D78E87A0E41B9B8F73A928EE0CCEE1F6739884B9777E4FE9E88A
#' 1BBE495927AC4A799B3181D6442443"
#' stringToRaw(key_p)
#' }
#' @export
stringToRaw <- function(str) {
  string <- raw()
  str %<>% gsub("\n| ", "", .)
  for (i in 1:(nchar(str) / 2)) {
    string[i] <- substr(str, (2 * i - 1), (2 * i)) %>%
      as.hexmode() %>%
      unlist() %>%
      as.raw()
  }
  return(string)
}

#' Get query paramters from URL address
#'
#' @param url the url of the page to retrieve
#' @param verbose If TRUE, it whill print returned parameter in the console.
#' @param clip If TRUE, it will get url string from clipboard
#' @param quote If TRUE, params names print in console will use quote.
#' @param is_iconv whether convert encoding from utf-8 to gbk
#' @param is_return boolean
#'
#' @examples
#' url <- "http://elearning.ne.sysu.edu.cn/webapps/discussionboard/do/message?layer=forum&currentUserInfo=***&conf_id=_413_1&numAttempts=1626&type=user_forum&attempt_id=_5918115_1&callBackUrl=%2Fwebapps%2Fgradebook%2Fdo%2Finstructor%2FviewNeedsGrading%3Fcourse_id%3D_405_1%26courseMembershipId%3D_3928655_1%26outcomeDefinitionId%3D_114127_1&forum_id=_61110_1&currentAttemptIndex=1&nav=discussion_board_entry&action=collect_forward&origRequestId=0D68B9644B97B73FA532AC7B5119169C.root_1498061370964&user_id=_227280_1&course_id=_405_1&sequenceId=_405_1_0&viewInfo=%E9%9C%80%E8%A6%81%E8%AF%84%E5%88%86&"
#' param <- url2params(url, is_return = TRUE)
#' @import magrittr
#' @export
url2params <- function(url,
                       verbose = TRUE, clip = FALSE,
                       quote = FALSE,
                       is_iconv = FALSE,
                       is_return = FALSE) {
  if (clip) url <- suppressWarnings(readLines("clipboard"))
  # url <- URLdecode(url)
  # url %<>% URLdecode

  params <- as.list(getFormParams(url)) %>% lapply(URLdecode)
  if (is_iconv) params %<>% lapply(iconv, "utf-8", "gbk")

  # for the convenience of write param
  if (quote) {
    str <- sprintf('  "%s" \t\t= "%s"', names(params), params) %>%
      paste(collapse = ",\n") %>%
      paste0("param <- list(\n", ., "\n)")
  } else {
    str <- sprintf('  %-20s \t= "%s"', names(params), params) %>%
      paste(collapse = ",\n") %>%
      paste0("param <- list(\n", ., "\n)")
  }

  if (verbose) cat(str)
  if (.Platform$OS.type == "windows") {
    writeLines(str, "clipboard")
  }
  if (is_return) {
    return(params)
  }
}

#' constuct URL based on query parameters
#'
#' @inheritParams url2params
#' @param params list
#'
#' @export
params2url <- function(url, params) {
  paste(url, paste(names(params), params, collapse = "&", sep = "="), sep = "?")
}

#' @importFrom glue trim
getFormParams <- function(query, isURL = grepl("^(http|\\?)", query)) {
  if (length(query) == 0) {
    return(NULL)
  }
  if (isURL) {
    query <- gsub(".*\\?", "", query)
  }
  if (nchar(query) == 0) {
    return(character())
  }
  els <- strsplit(query, "[&=]")[[1]]
  i <- seq(1, by = 2, length = length(els) / 2)
  ans <- structure(els[i + 1L], names = els[i])
  if (any(i <- is.na(ans))) {
    ans[i] <- ""
  }
  names(ans) <- trim(names(ans))
  ans
}
