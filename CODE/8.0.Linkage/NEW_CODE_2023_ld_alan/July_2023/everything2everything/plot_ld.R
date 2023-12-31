scp aob2x@rivanna.hpc.virginia.edu:/project/berglandlab/alan/pairwise_ld_window_50000_10000.Rdata ~/.

### librareis
  library(ggplot2)
  library(data.table)
  library(viridis)

### load data
  load("~/pairwise_ld_window_50000_10000.Rdata")

### pad empty spaces
  grid <- data.table(expand.grid(1:max(c(o$win1, o$win2)), 1:max(c(o$win1, o$win2))))
  setnames(grid, names(grid), c("win1", "win2"))

  grid <- grid[win1<win2]
  setkey(o, win1, win2)
  setkey(grid, win1, win2)

  o2 <- merge(o[poolOnly==T][rnp.thr==1], grid, all=T)
  o2[is.na(meanR2), meanR2:=-.01]

  table(o$win1>o$win2)
  table(o2$win1>o2$win2)

### plot
  p1 <- ggplot(data=o2[abs(win1-win2)>50][meanR2>0], aes(x=win1, y=win2, fill=meanR2)) +
                geom_raster() + scale_fill_viridis(option="H") +
        geom_raster(data=o2[win1!=win2][meanR2<0], aes(x=win1, y=win2), fill="grey39", alpha=.95) +
        theme_minimal()

  ggsave(p1, file="~/ld_mat_r.jpg", h=8, w=10)


ggplot(data=o[win1!=win2], aes(x=win1, y=win2, fill=meanR2)) + geom_tile() + scale_fill_viridis(option="F") + facet_grid(poolOnly~rnp.thr)






g2 <- ggplot(data=o2[meanR2>0], aes(x=log10(abs(mid1-mid2)), y=meanR2), alpha=.5, size=.5) + geom_point()
ggsave(g2, file="~/pairwise.jpg", h=8, w=8)

o2[,lDist:=log10(abs(mid1-mid2)+1)]
t1 <- lm(meanR2~lDist, data=o2[meanR2>0])
o2[meanR2>0,pred:=predict(t1)]
o2[,resid:=meanR2-pred]




  p1 <- ggplot(data=o2[meanR2>0], aes(x=win1, y=win2, fill=resid)) +
                geom_raster() + scale_fill_viridis(option="H") +
        geom_raster(data=o2[win1!=win2][meanR2<0], aes(x=win1, y=win2), fill="grey39", alpha=.95) +
        theme_minimal()

  ggsave(p1, file="~/ld_mat_r.jpg", h=8, w=10)
