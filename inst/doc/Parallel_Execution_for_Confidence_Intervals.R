## ---- eval=TRUE---------------------------------------------------------------
parallel::detectCores()

## ---- eval=FALSE--------------------------------------------------------------
#  options(qfasa.parallel.numcores = 8)
#  options(qfasa.parallel.cluster = parallel::makeCluster(getOption('qfasa.parallel.numcores'),
#                                                         type='FORK'))
#  #
#  # Note that if using windows, do not include type='FORK'.
#  

## ---- eval=FALSE--------------------------------------------------------------
#  parallel::stopCluster(getOption('qfasa.parallel.cluster'))

