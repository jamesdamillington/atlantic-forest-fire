library(sf)

CAR = st_read("data/CAR_MataAtlantica_AI/CAR_IRU.shp")

CARsub = st_read("data/CAR_MataAtlantica_AI/CAR_IRU_subset.shp")

plot(st_geometry(CARsub))


CARsubf = st_union(CARsub,by_feature=FALSE)
CARsubt = st_union(CARsub,by_feature=TRUE)

CARsubi = st_intersection(CARsub)

plot(CARsubf)
plot(CARsubt)
plot(CARsubi)


plot(sut, col = sf.colors(categorical = TRUE, alpha = .5))


sc = st_combine(s)
scl=sc[[1]]

class(scl)
scl[1]

st_write(CARsubi, "data/CAR_MataAtlantica_AI/CAR_IRU_subset_SI.shp")
