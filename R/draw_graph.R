#' Draw a graph contains vertexs with sensitive or unsensitive label
#'
#' @param g A graph contains vertexs with different labels and some of which are sensitive.
#' @param main The title of graph.
#' @param label Label of vertexs.
#' @examples
#' dynet <- make.virtual.dynamic.network()
#' draw.graph(dynet$t1)
#' @export
#' @import "igraph"
draw.graph <- function(g, main = NULL, label = NA) {
  label.names <- unique(V(g)$label)
  #' @importFrom "grDevices" "rainbow"
  colbar <- rainbow(length(label.names))
  names(colbar) <- label.names
  plot.igraph(g, main = main,
          vertex.label = label,
          vertex.color = colbar[V(g)$label],
          vertex.shape = c("rectangle", "circle")[V(g)$sensitive])
}
