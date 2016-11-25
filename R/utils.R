#' @import "igraph"
#' @import "parallel"
#' @import "doParallel"
#' @import "foreach"
NLSS <- function(n1,n2) {
  a <- length(intersect(n1,n2))
  b <- length(union(n1,n2))
  ifelse(b==0,1,a/b)
}
getsim <- function(g,uid,cid) {
  sim <- NLSS(neighbors(g,uid)$label, neighbors(g,cid)$label)
  names(sim) <- cid
  return(sim)
}
vecNLSS <- function(g, uid, candidates) {
  cid <- NULL
  simvec <- foreach (cid=candidates, .combine = c) %dopar% getsim(g,uid,cid)
  return(simvec)
}
is.label.match <- function(ulab,vlab) {
  ulabvec <- strsplit(ulab, split = " ")[[1]]
  vlablist <- strsplit(vlab, split = " ")
  sapply(vlablist, function(x) all(ulabvec%in%x))
}
is.label.include <- function(g,uid, vid) {
  ulabel <- strsplit(V(g)[uid]$label, split = " ")[[1]]
  vlabel <- strsplit(V(g)[vid]$label, split = " ")[[1]]
  all(ulabel%in%vlabel)
}
is.label.equal <- function(g,uid, vid) {
  ulabel <- strsplit(V(g)[uid]$label, split = " ")[[1]]
  vlabel <- strsplit(V(g)[vid]$label, split = " ")[[1]]
  setequal(ulabel,vlabel)
}
