#' Anonymize two node.
#'
#' @param g A graph contains vertexs with different labels and some of which are sensitive.
#' @param uid Name of a node with sensitive label.
#' @param vid Name of a node with unsensitive label.
#' @param noise Current amount of noise nodes.
#' @return A list with information of anonymized network.
#' @export
#' @import "igraph"
anonymize2node <- function(g , uid, vid, noise = g$noise) {
  flag <- F
  if(degree(g)[uid]<degree(g)[vid]) {
    tid <- uid; uid <- vid; vid <- tid; rm(tid); flag <- T
  }
  gu <- make_ego_graph(g,1,uid)[[1]]
  gv <- make_ego_graph(g,1,vid)[[1]]
  guv <- induced_subgraph(g,union(V(gu)$name, V(gv)$name))
  nodes.match <- function() {
    nu.degree <- sort(degree(gu, neighbors(gu,uid)), decreasing = T)
    nu.match <- vector(length = length(nu.degree))
    names(nu.match) <- names(nu.degree)
    nv.degree <- sort(degree(gv, neighbors(gv,vid)), decreasing = T)
    nv.match <- vector(length = length(nv.degree))
    names(nv.match) <- names(nv.degree)
    matchlist <- list()

    if(length(nv.match)>0) {
      nv.label.equal <- sapply(names(nv.match),is.label.equal, g = g, uid = uid)
      nv.label.include <- sapply(names(nv.match),is.label.include, g = g, uid = uid)
      for (nuid in names(nu.match)) {
        vid.match <- names(nv.match[!nv.match & nv.label.equal])
        if(length(vid.match)==0) {
          vid.match <- names(nv.match[!nv.match & nv.label.include])
        }
        if (length(vid.match)==1) {
          nu.match[nuid] <- T
          nv.match[vid.match] <- T
          matchlist[[nuid]] <- vid.match
        } else if(length(vid.match)>1) {
          nu.match[nuid] <- T
          vid.match <- names(which.min(abs(nv.degree[vid.match]-nu.degree[nuid])))
          nv.match[vid.match] <- T
          matchlist[[nuid]] <- vid.match
        }
      }
      for (nuid in names(nu.match[nu.match==F])) {
        nvid.dclose <- names(which.min(abs(nv.degree[nv.match==F]-nu.degree[nuid])))
        if(length(nvid.dclose)>0) {
          nu.match[nuid] <- T
          nv.match[nvid.dclose[1]] <- T
          matchlist[[nuid]] <- nvid.dclose[1]
        }
      }
    }
    if(!all(nu.match)) {
      candidates <- V(g)[V(g)$anonymied==F]$name
      candidates <- setdiff(candidates,c(uid, vid, names(nu.match), names(nv.match)))
      for (nuid in names(nu.match[nu.match==F])) {
        if(length(candidates)>0) {
          cid.match <- V(g)[V(g)$name%in%candidates & is.label.match(V(g)[nuid]$label,V(g)$label)]
          cid.match <- names(which.min(degree(g,cid.match)))
          if(length(cid.match)>0) {
            nu.match[nuid] <- T
            matchlist[[nuid]] <- cid.match
            candidates <- setdiff(candidates,cid.match)
          }
        }
      }
    }
    for (nuid in names(nu.match[nu.match==F])) {
      noise <<- noise+1
      nvid <- paste0("N",noise)
      g <<- g+vertex(name = nvid, label = V(g)[nuid]$label, sensitive = 2, anonymized = F)
      matchlist[[nuid]] <- nvid
    }
    nuid.match <- names(matchlist)
    nvid.match <- unlist(matchlist,use.names = F)
    return(data.frame(nuid = nuid.match, nvid = nvid.match, stringsAsFactors = F))
  }
  match <- nodes.match()
  gmatch <- match[!mapply(is.label.include, uid = match$nuid, vid = match$nvid, MoreArgs = list(g = g)),]
  if(nrow(gmatch)>0) {
    ulabel <- strsplit(V(g)[gmatch$nuid]$label, split = " ")
    vlabel <- strsplit(V(g)[gmatch$nvid]$label, split = " ")
    union.label <- unlist(mapply(function(lu,lv) paste(union(lu,lv),collapse = " "), ulabel, vlabel))
    V(g)[gmatch$nvid]$label <- union.label
  }

  gua.adjm <- as_adjacency_matrix(induced_subgraph(g, c(uid, match$nuid)))
  gva.adjm <- as_adjacency_matrix(induced_subgraph(g, c(vid, match$nvid)))
  gua.adjm <- gua.adjm[c(uid,match$nuid),c(uid,match$nuid)]
  gva.adjm <- gva.adjm[c(vid,match$nvid),c(vid,match$nvid)]
  eua.graph <- graph.adjacency((gua.adjm|gva.adjm)-gua.adjm, mode = "undirected")
  eva.graph <- graph.adjacency((gva.adjm|gua.adjm)-gva.adjm, mode = "undirected")
  ga <- graph.union(g,eua.graph, eva.graph)
  ga$noise <- noise

  V(ga)$label <- V(g)$label
  V(ga)$sensitive <- V(g)$sensitive
  V(ga)$anonymized <- V(g)$anonymized
  V(ga)[c(uid,vid)]$anonymized <- T

  gua <- make_ego_graph(ga, 1, uid)[[1]]
  gva <- make_ego_graph(ga, 1, vid)[[1]]
  guva <- induced_subgraph(ga,union(V(gua)$name, V(gva)$name))

  if(flag == T) {
    temp <- gu; gu <- gv; gv <- temp;
    temp <- gua; gua <- gva; gva <- temp;
  }
  return(list(gu = gu, gv = gv, guv=guv, gua = gua, gva = gva, guva=guva, ga = ga))
}
