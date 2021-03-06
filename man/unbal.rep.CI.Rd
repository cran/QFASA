% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/All_Rep_Code.R
\name{unbal.rep.CI}
\alias{unbal.rep.CI}
\title{Measure of Repeatability for Diet Estimates (Unbalanced/Missing Value Case)}
\usage{
unbal.rep.CI(
  data,
  B,
  R,
  CI = TRUE,
  alpha,
  prey.database,
  fatcont.mat,
  dist.meas,
  ext.fa,
  gamma.QFASA = 1,
  gamma.rho = 1
)
}
\arguments{
\item{data}{data frame of diet estimates. First column must denote the predator
and second column the second factor (eg. year or season).  Need not contain
the same number of repeated measurements for each predator.}

\item{B}{number of pseudo predators samples to generate for bias calculation.
Default is set to 50 because is slow to run.}

\item{R}{number of bootstrap samples (i.e. \code{R} samples for each generated sample
of pseudo predators). Default is set to 100 because it is slow to run.}

\item{CI}{indicates if a confidence interval for rho is to be calculated.
Default is FALSE since this is time consuming to obtain.}

\item{alpha}{a (1-alpha/2)X100 percent confidence interval is calculated for rho
if \code{CI=TRUE}.}

\item{prey.database}{prey data base that was used to compute the QFASA diet
estimates in \code{data}. Will be used to generate pseudo predators.}

\item{fatcont.mat}{data frame or matrix of length equal to the number of prey
FA signatures in prey data base.  First column is name of species and
second column is lipid.}

\item{dist.meas}{distance measure to use in \code{p.QFASA}.}

\item{ext.fa}{subset of FAs to use.}

\item{gamma.QFASA}{if \code{dist.meas=3}, gamma is required.  Default is 1.}

\item{gamma.rho}{value of gamma to be used to compute CS distance
in repeatablity functions.  Default is 1.}
}
\value{
Bias corrected measure of repeatability, estimate of the bias and
     (if \code{CI=TRUE}) a confidence interval for the true repeatability.
}
\description{
Computes a measure of repeatability for a sample of predators with repeated
diet estimate measurements (Unbalanced/Missing Value Case)
}
\keyword{internal}
