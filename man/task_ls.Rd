% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/task_manager.R
\name{task_ls}
\alias{task_ls}
\title{Get all the tasks which are currently scheduled at the Windows task scheduler.}
\usage{
task_ls(taskname = NULL, wildcard = FALSE, encoding = "UTF-8", ...)
}
\arguments{
\item{taskname}{a character string with the name of the task. Defaults to the filename. Should not contain any spaces.}

\item{wildcard}{boolean, whether use regexpr to match task?}

\item{encoding}{encoding of the CSV which schtasks.exe generates. Defaults to UTF-8.}

\item{...}{optional arguments passed on to \code{fread} in order to read in the CSV file which schtasks generates}
}
\value{
a data.frame with scheduled tasks as returned by schtasks /Query for which the Taskname or second
column in the dataset the preceding \\ is removed
}
\description{
Get all the tasks which are currently scheduled at the Windows task scheduler.
}
\examples{
\dontrun{
d <- task_ls()
d
}
}
