#' Get Region of Interest
#'
#' Create a spatial polygon describing the convex hull of a set of spatial points.
#'
#' @param x,y
#'   Coordinate vectors of a set of points.
#'   Alternatively, a single argument \code{x} can be provided.
#'   Functions \code{\link[grDevices]{xy.coords}} and \code{\link[sp]{coordinates}}
#'   are used to extract point coordinates.
#' @param alpha 'numeric' number.
#'   Value of \eqn{\alpha}, used to implement a generalization of the convex hull
#'   (Edelsbrunner and others, 1983).
#'   As \eqn{\alpha} decreases, the shape shrinks.
#'   Requires that the \pkg{alphahull} and \pkg{maptools} packages are available.
#'   The \href{https://CRAN.R-project.org/package=alphahull}{alphahull} package
#'   is released under a restrictive non-free software license.
#' @param width 'numeric' number.
#'   Buffer distance from geometry of convex hull.
#' @param ...
#'   Additional arguments to be passed to the \code{\link{gBuffer}} function.
#'
#' @return An object of class 'SpatialPolygons'.
#'
#' @author J.C. Fisher, U.S. Geological Survey, Idaho Water Science Center
#'
#' @references
#'   Edelsbrunner, H., Kirkpatrick, D.G. and Seidel, R., 1983,
#'   On the shape of a set of points in the plane:
#'   IEEE Transactions on Information Theory, v. 29, no. 4, p. 551--559.
#'
#' @seealso
#'   Functions \code{\link[grDevices]{chull}} and \code{\link[alphahull]{ashape}}
#'   are used to calculate the convex hull and generalized convex hull, respectively.
#'
#'   Function \code{\link[maptools]{checkPolygonsHoles}} is used to identify polygon holes.
#'
#' @keywords utilities
#'
#' @export
#'
#' @examples
#' set.seed(123)
#'
#' n <- 50
#' x <- list("x" = stats::runif(n), "y" = stats::runif(n))
#' sp::plot(GetRegionOfInterest(x, width = 0.05), border = "blue", lty = 2)
#' sp::plot(GetRegionOfInterest(x), border = "red", add = TRUE)
#' sp::plot(GetRegionOfInterest(x, width = -0.05), lty = 2, add = TRUE)
#' points(x, pch = 3)
#'
#' \dontrun{
#' n <- 300
#' theta <- stats::runif(n, 0, 2 * pi)
#' r <- sqrt(stats::runif(n, 0.25^2, 0.50^2))
#' x <- sp::SpatialPoints(cbind(0.5 + r * cos(theta), 0.5 + r * sin(theta)),
#'                        proj4string = sp::CRS("+init=epsg:32610"))
#' sp::plot(GetRegionOfInterest(x, alpha = 0.1, width = 0.05),
#'          col = "green")
#' sp::plot(GetRegionOfInterest(x, alpha = 0.1),
#'          col = "yellow", add = TRUE)
#' sp::plot(x, add = TRUE)
#' }
#'

GetRegionOfInterest <- function(x, y=NULL, alpha=NULL, width=NULL, ...) {
  checkmate::assertNumber(alpha, lower=0, finite=TRUE, null.ok=TRUE)
  checkmate::assertNumber(width, finite=TRUE, null.ok=TRUE)

  if (inherits(x, "Spatial")) {
    xy <- sp::coordinates(x)
    crs <- raster::crs(x)
  } else {
    xy <- do.call("cbind", grDevices::xy.coords(x, y)[1:2])
    crs <- sp::CRS(as.character(NA))
  }

  if (is.null(alpha)) {
    pts <- xy[grDevices::chull(xy), ]
    ply <- sp::Polygons(list(sp::Polygon(pts)), ID=1)
  } else {
    ply <- .GeneralizeConvexHull(xy, alpha)
  }
  ply <- sp::SpatialPolygons(list(ply), proj4string=crs)

  if (is.numeric(width))
    ply <- rgeos::gBuffer(ply, width=width, ...)

  ply
}


# Compute alpha-shape of points in plane

.GeneralizeConvexHull <- function(xy, alpha) {
  checkmate::assertMatrix(xy, mode="numeric", any.missing=FALSE, ncols=2)
  checkmate::assertNumber(alpha, lower=0, finite=TRUE)

  for (pkg in c("alphahull", "maptools")) {
    if (!requireNamespace(pkg, quietly=TRUE))
      stop(sprintf("alpha-shape computation requires the %s package", pkg))
  }

  # remove duplicate points
  xy <- unique(xy)

  # code adapted from RPubs document titled Alpha Shapes to Polygons
  # by Barry Rowlingson, accessed November 15, 2018
  # at https://rpubs.com/geospacedman/alphasimple
  shp <- alphahull::ashape(xy, alpha=alpha)
  el <- cbind(as.character(shp$edges[, "ind1"]), as.character(shp$edges[, "ind2"]))
  gr <- igraph::graph_from_edgelist(el, directed=FALSE)
  clu <- igraph::components(gr, mode="strong")
  ply <- sp::Polygons(lapply(seq_len(clu$no), function(i) {
    vids <- igraph::groups(clu)[[i]]
    g <- igraph::induced_subgraph(gr, vids)
    if (any(igraph::degree(g) != 2))
      stop("non-circular polygon, try increasing alpha value", call.=FALSE)
    gcut <- g - igraph::E(g)[1]
    ends <- names(which(igraph::degree(gcut) == 1))
    path <- igraph::shortest_paths(gcut, ends[1], ends[2])$vpath[[1]]
    idxs <- as.integer(igraph::V(g)[path]$name)
    pts <- shp$x[c(idxs, idxs[1]), ]
    sp::Polygon(pts)
  }), ID=1)

  maptools::checkPolygonsHoles(ply)
}
