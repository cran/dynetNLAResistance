#' Generate a grouped dynamic network by lw-grouping algorithm.
#'
#' @param dynet An ungrouped dynamic network.
#' @param l Kinds of labels in each unmerged group.
#' @param w Width of window of lw-grouping algorithm.
#' @return A list of grouped network with attribute of gs.merged.
#' @export
#' @import "igraph"
lw.grouping <- function(dynet = NULL, l = 2, w = 3) {
  noise = 0
  gs.table <- list()
  dynet.grouped <- list()
  if(is.null(dynet)) {
    dynet <- make.virtual.dynamic.network()
  }
  for (i in seq(length(dynet))) {
    result <- global.similarity.grouping(dynet[[i]],l,gs.table = gs.table,noise,i)
    noise <- result$noise
    gs.table <- c(gs.table,list(result$gs))
    if (i>w) gs.table[[1]] <- NULL
    dynet.grouped[[paste0("t",i)]] <- merged.groups(result$grouped.graph,gs.table)
    dynet.grouped[[paste0("t",i)]]$noise <- noise
  }
  class(dynet.grouped) <- "dynamic.network.grouped"
  return(dynet.grouped)
}
