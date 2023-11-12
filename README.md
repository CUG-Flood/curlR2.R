
# curlR

<!-- badges: start -->
[![R-CMD-check](https://github.com/rpkgs/curlR/workflows/R-CMD-check/badge.svg)](https://github.com/rpkgs/curlR/actions)
[![codecov](https://codecov.io/gh/rpkgs/curlR/branch/master/graph/badge.svg)](https://codecov.io/gh/rpkgs/curlR)
[![License](http://img.shields.io/badge/license-GPL%20%28%3E=%203%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-3.0.html)
[![CRAN](http://www.r-pkg.org/badges/version/curlR)](https://cran.r-project.org/package=curlR)
<!-- badges: end -->

## Installation

### 1. Windows

环境配置详见：<https://gitlab.com/r-pkgs/curlr.bin>

```r
remotes::install_github("rpkgs/curlR", INSTALL_opts="--no-staged-install")
```

## Example

```r
library(curlR)

port = 4444
kill_selenium(port)
p <- init_selenium(port)

p %>% go("https://cn.bing.com/")
getElementByName(p, "q") %>% ele_fillText("curlR", key = "enter")
# getElementByName(p, "go") %>% ele_click()

# GET ALL results
xs = ele_find_all(p, "//ol/li", "xpath")

# GET the first result
x = ele_find_first(p, "//ol/li", "xpath")
a = ele_child(x, "//a") # get link
a %>% clickElement()
# if page changed, previous node will be destroyed
```

## selenium

### Linux

```bash
sudo apt install firefox-geckodriver chromium-chromedriver 
sudo apt install chromium-browser
```

## Reference

1. <https://extendsclass.com/xpath-to-css.html>
