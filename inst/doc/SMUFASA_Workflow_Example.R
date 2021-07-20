## ----message=FALSE, warning=FALSE---------------------------------------------
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

## ----eval=FALSE---------------------------------------------------------------
#  smufasa.est <- p.SMUFASA(predator.matrix, prey.red, FC.red, fa.set)

## ----eval=FALSE---------------------------------------------------------------
#  CalEst <- smufasa.est$Cal_Estimates

## ----eval=FALSE---------------------------------------------------------------
#  DietEst <- smufasa.est$Diet_Estimates

## ----eval=FALSE---------------------------------------------------------------
#  nll <- smufasa.est$nll

## ----eval=FALSE---------------------------------------------------------------
#  VarEps <- smufasa.est$Var_Epsilon

## ----eval=FALSE---------------------------------------------------------------
#  Q = p.QFASA(predator.matrix=predator.matrix, prey.matrix=prey.matrix,
#              cal.mat=CalEst, dist.meas=2, gamma=1, FC=FC.red,
#              start.val=rep(1,nrow(prey.red)), ext.fa=fa.set)

## ---- eval=FALSE--------------------------------------------------------------
#  DietEst.Q <- Q$'Diet Estimates'

## ----eval=FALSE---------------------------------------------------------------
#  M <- p.SMUFASA(predator.matrix, prey.red, cal.est, FC.red, fa.set)
#  DietEst.M <- M$Diet_Estimates

