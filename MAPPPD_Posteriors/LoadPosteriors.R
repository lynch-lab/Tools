#library(aws.s3)
#library(MCMCvis)

#version <- "sw-thnnlb3u7oclv6ey6ro4"  #Adelie
#version <- "i-0e7f319a8dfe63f7d"  #chinstrap
#version <- "i-0c2dabc04f54bab29"  #gentoo

#s3load(paste('ModelBuild/',version,'/MCMCzstate.rda', sep = ''), bucket = "penguinmap")
#s3load(paste('ModelBuild/',version,'/SiteList.rda', sep = ''), bucket = "penguinmap")

###Option 1: Create a Site x Year x Quantile matrix
zstateList <- MCMCpstr(MCMCzstate, func = function(x) quantile(x, probs = c(0.025, .5, 0.975)))

zstate <- zstateList[[1]]

rownames(zstate) <- SiteList$site_id

##Option #2: Pull out quantiles for particular named sites
which(SiteList$site_id=="ADAM")
MCMCsummary(MCMCzstate, 
            params = 'zstate\\[XYZ,', #substitute XYZ which the number from the previous call
            ISB = FALSE, 
            round = 2, 
            func = function(x) quantile(x, probs = c(.05, .95)),
            func_name = c("5%", "95%"))
