% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/All_CI_Code.R
\name{opt.beta.lim}
\alias{opt.beta.lim}
\title{Find simultaneous confidence intervals for diet
proportions of a single prey species i.e. solve f(pio) = PVAL(pio)
= alpha1.  Calls root finding function root.beta.}
\usage{
opt.beta.lim(alpha1, par.list, R, p.mat, k)
}
\arguments{
\item{alpha1}{simultaneous confidence level}

\item{par.list}{a list of R.p lists of I beta distribution parameters phi
and theta that define diet proportion estimates for each of the
prey species. Effectively R.p beta distributions for each of the
I prey species from which we bootstrap to calculate p-values.}

\item{R}{number of bootstrap replicates to use in p-value estimation.}

\item{p.mat}{predator diet estimates.}

\item{k}{prey species index 1...I}
}
\value{
upper and lower limits simultaneous
    intervals respectively.
}
\description{
Find simultaneous confidence intervals for diet
proportions of a single prey species i.e. solve f(pio) = PVAL(pio)
= alpha1.  Calls root finding function root.beta.
}
\keyword{internal}
