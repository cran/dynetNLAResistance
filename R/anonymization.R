#' Anonymize a snapshot of a dynamic network.
#'
#' @param g A network grouped by lw-grouping algorithm.
#' @param alpha Weight of anonymization cost resulted from label generalization.
#' @param beta Weight of anonymization cost resulted from adding edges.
#' @param gamma Weight of anonymization cost resulted from adding nodes.
#' @export
#' @import "igraph"
#' @import "parallel"
#' @import "doParallel"
#' @import "foreach"
anonymization <- function(g, alpha = 1, beta = 2, gamma = 3) {
  gs.merged <- g$gs.merged
  group.anonymized <- vector(length = length(gs.merged))
  names(group.anonymized) <- names(gs.merged)
  cl <- makeCluster(detectCores()-1)
  registerDoParallel(cl)
  while(length(gs.merged)>0) {
    cat("Merged group-set's size: ", length(gs.merged), "\n")
    cat("Vertex number: ", length(V(g)), "\n")
    group <- gs.merged[1]
    gf <- group[[1]]
    gs.merged[1] <- NULL
    uf <- gf[1]
    gf <- gf[-1]
    ui.cost <- foreach(ui=gf,.combine = c) %dopar% cost(g,uf,ui,alpha,beta,gamma)
    names(ui.cost) <- gf
    gf <- names(sort(ui.cost))
    cat("iterating...\n")
    for( ui in gf) {
      result <- anonymize2node(g, uf, ui)
      g <- result$ga
    }
    group.anonymized[names(group)] <- T
    cat("Anonymized nodes with sensitive label:\n",names(group.anonymized[group.anonymized==T]),"\n\n")
  }
  stopCluster(cl)
  return(g)
}
