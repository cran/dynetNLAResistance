#' Calculate anonymization cost of two nodes.
#'
#' @param g A graph contains vertexs with different labels and some of which are sensitive.
#' @param uid Name of a node with sensitive label.
#' @param vid Name of a node with unsensitive label.
#' @param alpha Weight of anonymization cost resulted from label generalization.
#' @param beta Weight of anonymization cost resulted from adding edges.
#' @param gamma Weight of anonymization cost resulted from adding nodes.
#' @return Anonymization cost of two nodes.
#' @export
#' @import "igraph"
cost <- function(g, uid, vid, alpha = 1, beta = 2, gamma = 3) {
  anony.info <- anonymize2node(g, uid, vid)
  lgc <- function(id) {
    ga <- anony.info$ga
    g.label <- strsplit(V(g)[id]$label, split =  " ")[[1]]
    ga.label <- strsplit(V(g)[id]$label, split = " ")[[1]]
    1-length(intersect(g.label, ga.label))/length(union(g.label, ga.label))
  }
  etdiff <- length(E(anony.info$guva))-length(E(anony.info$guv))
  vtdiff <- length(V(anony.info$guva))-length(V(anony.info$guv))
  lgc.sum <- sum(sapply(V(anony.info$guv)$name,lgc))
  return(alpha*lgc.sum+beta*etdiff+gamma*vtdiff)
}
