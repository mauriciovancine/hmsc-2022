# Set the base directory
setwd("U:/all stuff/TEACHING/HMSC/2022 Jyväskylä/case study phenology")

##################################################################################################
# MAKE THE SCRIPT REPRODUCIBLE (BEGINNING)
##################################################################################################
set.seed(1)
##################################################################################################
## MAKE THE SCRIPT REPRODUCIBLE (END)
##################################################################################################


##################################################################################################
# LOAD PACKAGES (BEGINNING)
##################################################################################################
library(Hmsc)
##################################################################################################
# LOAD PACKAGES (END)
##################################################################################################


##################################################################################################
# SET DIRECTORIES (BEGINNING)
##################################################################################################
localDir = "."
dataDir = file.path(localDir, "data")
modelDir = file.path(localDir, "models")
if(!dir.exists(modelDir)) dir.create(modelDir)
##################################################################################################
# SET DIRECTORIES (END)
##################################################################################################


##################################################################################################
# READ AND EXPLORE THE DATA (BEGINNING)
##################################################################################################
# We read in the data and have a look at it
load(file = file.path(dataDir, "reducedData.RData"))
# includes Y, species, event, group

j = 10
plot(year,Y[,j],main=colnames(Y)[j],ylab="date")
abline(lm(Y[,j]~year))

hist(Y)
##################################################################################################
# READ AND EXPLORE THE DATA (END)
##################################################################################################

##################################################################################################
# SET UP THE MODEL (BEGINNING)
##################################################################################################
studyDesign = data.frame(year=as.factor(year))

XData = data.frame(year)

mdoy=colMeans(Y,na.rm = TRUE)

mY=mean(Y,na.rm = T)
sdY=sd(Y,na.rm = T)
Y=Y-mY
Y=Y/sdY
hist(Y)

TrData = data.frame(mdoy,as.factor(group))

#rL.year = HmscRandomLevel(units = levels(studyDesign$year))

xy.year = matrix(year)
rownames(xy.year) = studyDesign$year
colnames(xy.year) = "year"
head(xy.year)
rownames(xy.year)
xy.year[,1]
rL.year = HmscRandomLevel(sData = xy.year)

XFormula = ~year
TrFormula = ~group + (cos(2*pi*mdoy/365) + sin(2*pi*mdoy/365))

m = Hmsc(Y=Y, XData = XData,  XFormula = XFormula,
         TrData = TrData,TrFormula = TrFormula,
         distr="normal",
         studyDesign=studyDesign, ranLevels={list(year=rL.year)})
##################################################################################################
# SET UP THE MODEL (END)
##################################################################################################


##################################################################################################
# COMBINING AND SAVING MODELS (BEGINNING)
models = list(m)
names(models) = c("phenology model")
save(models, file = file.path(modelDir, "unfitted_models.RData"))
##################################################################################################
# COMBINING AND SAVING MODELS (END)
##################################################################################################


##################################################################################################
# TESTING THAT MODELS FIT WITHOUT ERRORS (BEGINNING)
##################################################################################################
for(i in 1:length(models)){
  print(i)
  sampleMcmc(models[[i]],samples=2)
}
##################################################################################################
# TESTING THAT MODELS FIT WITHOUT ERRORS (END)
##################################################################################################

