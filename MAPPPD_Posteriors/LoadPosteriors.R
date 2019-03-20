#library(aws.s3)
#library(MCMCvis)

#version <- "sw-thnnlb3u7oclv6ey6ro4"  #Adelie
#version <- "i-0e7f319a8dfe63f7d"  #chinstrap
#version <- "i-0c2dabc04f54bab29"  #gentoo

#s3load(paste('ModelBuild/',version,'/MCMCzstate.rda', sep = ''), bucket = "penguinmap")
#s3load(paste('ModelBuild/',version,'/SiteList.rda', sep = ''), bucket = "penguinmap")

which(SiteList$site_id=="ADAM")
MCMCsummary(MCMCzstate, 
            params = 'zstate\\[XYZ,', #substitute XYZ which the number from the previous call
            ISB = FALSE, 
            round = 2, 
            func = function(x) quantile(x, probs = c(.05, .95)),
            func_name = c("5%", "95%"))

#index<-as.character(which(SiteList$site_id=="ADAM"))
#MCMCsummary(MCMCzstate, 
#            params = noquote(paste("'zstate\\[",index,",'",sep="")), 
#            ISB = FALSE, 
#            round = 2, 
#            func = function(x) quantile(x, probs = c(.05, .95)),
#            func_name = c("5%", "95%"))