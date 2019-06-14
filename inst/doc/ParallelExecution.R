## ---- eval=TRUE----------------------------------------------------------
parallel::detectCores()

## ---- eval=FALSE---------------------------------------------------------
#  options(qfasa.parallel.numcores = 8)
#  options(qfasa.parallel.cluster = parallel::makeCluster(getOption('qfasa.parallel.numcores'),
#                                                         type='FORK'))

## ---- eval=FALSE---------------------------------------------------------
#  ci = beta.meths.CI(predator.mat = predator.matrix,
#                     prey.mat = prey.matrix.full,
#                     cal.mat = cal.mat,
#                     dist.meas = 2,
#                     nprey = 10,
#                     R.p = 1,
#                     R.ps = 10,
#                     R = 10,
#                     p.mat = diet.est,
#                     alpha = 0.05,
#                     ext.fa = fa.set)

## ---- eval=FALSE---------------------------------------------------------
#  parallel::stopCluster(getOption('qfasa.parallel.cluster'))

