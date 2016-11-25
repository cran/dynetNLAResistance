#' @import "igraph"
merged.groups <- function(g.grouped, gs.table) {
  cat("merge.groups\n")
  sensitive.nodes <- V(g.grouped)[V(g.grouped)$sensitive == 1]$name
  merged <- list()
  lapply(gs.table, function(gs) lapply(gs, function(group) {
    unexist <- group[setdiff(group$name, V(g.grouped)$name),]
    if(nrow(unexist)>0) {
      cat("unexit: ", unexist$name,"\n")
      g.grouped <<- add.vertices(g.grouped, nrow(unexist),
                                 name = unexist$name, label = unexist$label,
                                 sensitive = unexist$sensitive, anonymized = unexist$anonymized)
    }
    if(group$name[1]%in%sensitive.nodes) {
      merged[[group$name[1]]] <<- unique(c(merged[[group$name[1]]], group$name))
    }
    return(NULL)
  }))
  merged <- merged[names(sort(sapply(merged,length), decreasing = T))]
  g.grouped$gs.merged <- merged
  return(g.grouped)
}
