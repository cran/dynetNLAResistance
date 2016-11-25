#' @import "igraph"
#' @import "parallel"
#' @import "doParallel"
global.similarity.grouping <- function(g, l, gs.table, noise, t) {
  remain <- names(sort(degree(g),decreasing = T))
  v.protect <- V(g)[V(g)$sensitive==1]$name
  len <- length(v.protect)
  group.set <- list()
  cl <- makeCluster(detectCores()-1)
  registerDoParallel(cl)
  while (length(v.protect)>0) {
    us <- v.protect[1]
    v.protect <- v.protect[-1]
    group <- us
    candidates <- remain[!V(g)[remain]$label%in%V(g)[group]$label]
    candidates <- setdiff(candidates,v.protect)
    if(length(gs.table)>0) {
      ex <- unlist(lapply(gs.table, function(gs) {
        gs[[us]] <- NULL
        unlist(lapply(gs, rownames))
      }))
      candidates <- setdiff(candidates,ex)
    }
    if(length(candidates)>0) {
      simvec <- vecNLSS(g, us, candidates)
      while (length(group)<l) {
        if(length(simvec)>0) {
          umax <- names(which.max(simvec))
          group <- c(group, umax)
          cat("candidates number: ", length(simvec), " selected id: ", umax, "\n")
          simvec <- simvec[V(g)[names(simvec)]$label!=V(g)[umax]$label]
        }else break
      }
    }
    remain <- setdiff(remain, group)
    if(length(group)<l) {
      n <- l-length(group)
      noise.id <- paste0("N", (noise+1):(noise+n))
      noise.label <- sample(setdiff(g$label.names,V(g)[group]$label),n)
      g <- add_vertices(g,n, name = noise.id, label = noise.label, sensitive = 2, anonymized = F)
      group <- c(group, noise.id)
      noise <- noise+n
      cat("NoiseID: ", noise.id," NoiseLabel: ", noise.label,"\n")
    }
    group.set[[us]] <- group
    cat("Grouping t",t," ",(1-length(v.protect)/len)*100,"%\n",sep = "")
  }
  stopCluster(cl)
  group.set <- lapply(group.set,function(group)
    data.frame(name = group, label = V(g)[group]$label,sensitive = V(g)[group]$sensitive,
               anonymized = V(g)[group]$anonymized, row.names = group, stringsAsFactors = F))
  return(list(gs = group.set, grouped.graph = g, noise = noise))
}
