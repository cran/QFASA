## ---- eval=TRUE----------------------------------------------------------
library(QFASA)

## ---- eval=TRUE----------------------------------------------------------
dist.meas=1

## ---- eval=TRUE----------------------------------------------------------
fa.set = read.csv(file=system.file("exdata", "FAset.csv", package="QFASA"), as.is=TRUE)
fa.set = as.vector(unlist(fa.set))

## ---- eval=TRUE----------------------------------------------------------
predators = read.csv(file=system.file("exdata", "predatorFAs.csv", package="QFASA"), as.is=TRUE)
tombstone.info = predators[,1:4]
predator.matrix = predators[,5:(ncol(predators))]

# number of predator FA signatures this is used to create the matrix of CC values (see section 6 below)
npredators = nrow(predator.matrix)

## ---- eval=TRUE----------------------------------------------------------
#full file
prey=read.csv(file=system.file("exdata", "preyFAs.csv", package="QFASA"), as.is=TRUE)

#extract prey FA only from data frame and subset them for the FA set designated above
prey.sub=(prey[,4:(ncol(prey))])[fa.set]

#renormalize over 1
prey.sub=prey.sub/apply(prey.sub,1,sum) 

#extract the modelling group names from the full file
group=as.vector(prey$Species) 

#add modelling group names to the subsetted and renormalized FAs
prey.matrix=cbind(group,prey.sub)

#create an average value for the FA signature for each designated modelling group
prey.matrix=MEANmeth(prey.matrix) 

## ---- eval=TRUE----------------------------------------------------------
#numbers are the column which identifies the modelling group, and the column which contains the lipid contents
FC = prey[,c(2,3)] 
FC = as.vector(tapply(FC$lipid,FC$Species,mean,na.rm=TRUE))

## ---- eval=TRUE----------------------------------------------------------
cal = read.csv(file=system.file("exdata", "CC.csv", package="QFASA"), as.is=TRUE)
cal.vec = cal[,2]
cal.mat = replicate(npredators, cal.vec)

## ---- eval=TRUE----------------------------------------------------------
Q = p.QFASA(predator.matrix, prey.matrix, cal.mat, dist.meas, gamma=1, FC, start.val=rep(1,nrow(prey.matrix)), fa.set)

## ---- eval=TRUE----------------------------------------------------------
DietEst = Q$'Diet Estimates'

#estimates changed from proportions to percentages
DietEst = round(DietEst*100,digits=2)
colnames(DietEst) = (as.vector(rownames(prey.matrix)))
DietEst = cbind(tombstone.info,DietEst)

## ---- eval=TRUE----------------------------------------------------------
# plyr package
library(plyr)
Add.meas = ldply(Q$'Additional Measures', data.frame)

