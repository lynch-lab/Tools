SiteLocations <- read_excel("~/Documents/Projects/MAPPPD/Construction/SiteLocations.xlsx")
CHPEabundance<-rep(NA,times=nrow(SiteLocations))
ADPEabundance<-rep(NA,times=nrow(SiteLocations))
GEPEabundance<-rep(NA,times=nrow(SiteLocations))
EMPEabundance<-rep(NA,times=nrow(SiteLocations))
CHPElast.year<-rep(2018,times=nrow(SiteLocations))
GEPElast.year<-rep(2018,times=nrow(SiteLocations))
ADPElast.year<-rep(2018,times=nrow(SiteLocations))
EMPElast.year<-rep(2018,times=nrow(SiteLocations))
SiteLocations<-cbind(SiteLocations,CHPEabundance,CHPElast.year,GEPEabundance,GEPElast.year,ADPEabundance,ADPElast.year,EMPEabundance,EMPElast.year)
ADPEdata<-read.csv("ADPE_data_global_4January2016.csv")
CHPEdata<-read.csv("CHPE_data_global_4January2016.csv")
GEPEdata<-read.csv("GEPE_data_global_4January2016.csv")
EMPEdata<-read.csv("EMPE_data_global_4January2016.csv")

for (i in 1:nrow(SiteLocations))
{
  code<-SiteLocations[i,1]
  temp.adpe<-ADPEdata[ADPEdata$CODE==code,]
  if (nrow(temp.adpe)>0)
  {
    last.year<-temp.adpe[temp.adpe$YEAR==max(temp.adpe$YEAR),]$YEAR
    last.count<-temp.adpe[temp.adpe$YEAR==max(temp.adpe$YEAR),]$COUNT
    SiteLocations[i,]$ADPEabundance<-max(last.count)
    SiteLocations[i,]$ADPElast.year<-last.year[1]
  }
  if (nrow(temp.adpe)==0)
  {
    SiteLocations[i,]$ADPEabundance<-0
  }
  temp.gepe<-GEPEdata[GEPEdata$CODE==code,]
  if (nrow(temp.gepe)>0)
  {
    last.year<-temp.gepe[temp.gepe$YEAR==max(temp.gepe$YEAR),]$YEAR
    last.count<-temp.gepe[temp.gepe$YEAR==max(temp.gepe$YEAR),]$COUNT
    SiteLocations[i,]$GEPEabundance<-max(last.count)
    SiteLocations[i,]$GEPElast.year<-last.year[1]
  }
  if (nrow(temp.gepe)==0)
  {
    SiteLocations[i,]$GEPEabundance<-0
  }
  temp.chpe<-CHPEdata[CHPEdata$CODE==code,]
  if (nrow(temp.chpe)>0)
  {
    last.year<-temp.chpe[temp.chpe$YEAR==max(temp.chpe$YEAR),]$YEAR
    last.count<-temp.chpe[temp.chpe$YEAR==max(temp.chpe$YEAR),]$COUNT
    SiteLocations[i,]$CHPEabundance<-max(last.count)
    SiteLocations[i,]$CHPElast.year<-last.year[1]
  }
  if (nrow(temp.chpe)==0)
  {
    SiteLocations[i,]$CHPEabundance<-0
  }
  temp.empe<-EMPEdata[EMPEdata$CODE==code,]
  if (nrow(temp.empe)>0)
  {
    last.year<-temp.empe[temp.empe$YEAR==max(temp.empe$YEAR),]$YEAR
    last.count<-temp.empe[temp.empe$YEAR==max(temp.empe$YEAR),]$COUNT
    SiteLocations[i,]$EMPEabundance<-max(last.count)
    SiteLocations[i,]$EMPElast.year<-last.year[1]
  }
  if (nrow(temp.empe)==0)
  {
    SiteLocations[i,]$EMPEabundance<-0
  }
}

score<-rep(0,times=nrow(SiteLocations))
SiteLocations<-cbind(SiteLocations,score)

for (i in 1:nrow(SiteLocations))
{
  #SiteLocations$score[i]<-0
  SiteLocations$score[i]<-log10(SiteLocations$CHPEabundance[i]+1)*(2019-SiteLocations$CHPElast.year[i])+log10(SiteLocations$ADPEabundance[i]+1)*(2019-SiteLocations$ADPElast.year[i])
}

scoreranks<-rank(-SiteLocations$score,ties.method = "random")
SortedSiteLocations<-SiteLocations[order(scoreranks),]

targetlist<-SortedSiteLocations[1,]
for (i in 2:nrow(SiteLocations))
{
  if (sum(as.numeric(spDistsN1(as.matrix(targetlist[,c(6,5)]),as.numeric(SortedSiteLocations[i,c(6,5)]),longlat=TRUE)<15))==0)
  {
    targetlist<-rbind(targetlist,SortedSiteLocations[i,])
  }
}
