#' login qq
#' @name login_qq
#'
#' @description
#' - `login_qq.pwd`: login by password
#' - `login_qq.app`: quick login in by qq or Tim app
#'
#' @export
login_qq.pwd <- function(p, user = NULL, pwd = NULL) {
  if (is.null(user)) {
    qq <- get_config("qq")
    user <- qq$user
    pwd <- qq$pwd
  }

  p$switchToFrame(0)
  p %>%
    getElementById("switcher_plogin") %>%
    clickElement()
  p %>%
    getElementById("u") %>%
    ele_fillText(user)
  p %>%
    getElementById("p") %>%
    ele_fillText(pwd, key = "enter")
}

#' @rdname login_qq
#' @export
login_qq.app <- function(p) {
  p$switchToFrame(0)
  p$findElement("xpath", "//span[4]") %>% clickElement()
}
