# library(igraph)
# library(doParallel)
# library(foreach)
test_that("mvdn",{
  glist <- make.virtual.dynamic.network(prop.init = 0.03)
  print(V(glist[[1]])$name[1:10])
})
