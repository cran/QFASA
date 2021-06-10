## -----------------------------------------------------------------------------
library(QFASA)
library(dplyr)
library(compositions)

## -----------------------------------------------------------------------------
data(FAset)
fa.set = as.vector(unlist(FAset))

## -----------------------------------------------------------------------------
data(predatorFAs)
tombstone.info = predatorFAs[,1:4]
predator.matrix = predatorFAs[,5:(ncol(predatorFAs))]
npredators = nrow(predator.matrix)

## -----------------------------------------------------------------------------
data(preyFAs)
prey.matrix = preyFAs[,-c(1,3)]

# Selecting 5 prey species to include
spec.red <-c("capelin", "herring", "mackerel", "pilchard", "sandlance")
spec.red <- sort(spec.red)
prey.red <- prey.matrix %>%
  filter(Species %in% spec.red)


## -----------------------------------------------------------------------------
FC = preyFAs[,c(2,3)] 
FC = FC %>%
  arrange(Species)
FC.vec = tapply(FC$lipid,FC$Species,mean,na.rm=TRUE)
FC.red <- FC.vec[spec.red]

## -----------------------------------------------------------------------------
data(CC)
cal.vec = CC[,2]
cal.m = replicate(npredators, cal.vec)
rownames(cal.m) <- CC$FA

## ----eval=FALSE---------------------------------------------------------------
#  M <- p.MUFASA(predator.matrix, prey.red, cal.m, FC.red, fa.set)

## ----eval=FALSE---------------------------------------------------------------
#  Diet_Estimates <- M$Diet_Estimates

## ----eval=FALSE---------------------------------------------------------------
#  nll <- M$nll

## ----eval=FALSE---------------------------------------------------------------
#  VarEps <- M$Var_Epsilon

