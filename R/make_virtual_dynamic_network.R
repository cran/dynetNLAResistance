#' Make a vertex-increasing virtual dynamic network.
#'
#' @param network.data A data frame containing a symbolic edge list,which contains the information of whole network data.
#' @param len Time of this dynamic network lasts.
#' @param by The number of vertex added in network each time.
#' @param label.types The number of label types the network possesses.
#' @param prop.init The proportion of vertex amounts of initial network in whole network data.
#' @param prop.sensitive The proportion of amounts of vertex with sensitive label in whole network data.
#' @return A list of snapshots of a virtual dynamic network.
#' @examples
#' dynet <- make.virtual.dynamic.network()
#' @export
#' @import "igraph"
make.virtual.dynamic.network <- function(network.data = NULL, len = 10 ,by = 5, label.types = 100,
                                         prop.init = 0.001, prop.sensitive = 0.1) {
  if(!is.null(network.data)) {
    #' @importFrom "utils" "read.table"
    network <- network.data
    names(network) <- c("from", "to")
    network$from <- paste0("V", network$from)
    network$to <- paste0("V", network$to)
    network <- network[network$from<network$to,]
  }
  g.all <- graph.data.frame(network, directed = F)
  vnum <- length(V(g.all))

  label.names <- paste0("L",1:label.types)
  V(g.all)$label <- sample(label.names, vnum, replace = T)
  V(g.all)$sensitive <- sample(2,vnum,replace = T,prob = c(prop.sensitive, 1-prop.sensitive))
  V(g.all)$anonymized <- F

  id.all <- names(sort(degree(g.all),decreasing = T))
  sp.index <- seq(length(id.all)*prop.init)
  id.current <- id.all[sp.index]
  id.remain <- id.all[-sp.index]
  dynet <- list()
  for (i in seq(len)) {
    dynet[[paste0("t",i)]] <- induced.subgraph(g.all,id.current)
    dynet[[paste0("t",i)]]$label.names <- label.names
    #add vertexs
    add.index <- seq(by)
    id.add <- id.remain[add.index]
    id.remain <- id.remain[-add.index]
    id.current <- c(id.current, id.add)
  }
  class(dynet) <- "dynamic.network"
  return(dynet)
}
