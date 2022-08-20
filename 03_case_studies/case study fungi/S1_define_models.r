# Set the base directory
setwd("U:/all stuff/TEACHING/HMSC/2022 Jyväskylä/case study fungi")

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
load(file = file.path(dataDir, "allData.RData"))
# includes XData, Y.dna, Y.fb, Y.fb.abu

View(XData)
dim(XData)
View(Y.dna)
dim(Y.dna)
View(Y.fb)
dim(Y.fb)
View(Y.fb.abu)
dim(Y.fb.abu)

Y.dna.pa = 1*(Y.dna>0)
View(Y.dna.pa)

Y.dna.abuc = Y.dna
Y.dna.abuc[Y.dna==0] = NA
Y.dna.abuc = log(Y.dna.abuc)
Y.dna.abuc = scale(Y.dna.abuc)
View(Y.dna.abuc)

Y.fb.abuc = Y.fb.abu
Y.fb.abuc[Y.fb.abu==0] = NA
Y.fb.abuc = log(Y.fb.abuc)
Y.fb.abuc = scale(Y.fb.abuc)
View(Y.fb.abuc)

Y = cbind(Y.fb,Y.fb.abuc,Y.dna.pa,Y.dna.abuc)
sps = colnames(Y.fb)
ns = length(sps)
sps.subset = colnames(Y.fb.abuc)
ns.subset = length(sps.subset)
colnames(Y) = c(paste0(sps,"_FB.PA"),paste0(sps.subset,"_FB.ABUC"),paste0(sps,"_DNA.PA"),paste0(sps,"_DNA.ABUC"))
View(Y)

TrData = data.frame(surveytype=as.factor(c(rep("FB_pa",ns),rep("FB_abu",ns.subset),rep("DNA_pa",ns),rep("DNA_abu",ns))))
rownames(TrData) = colnames(Y)
View(TrData)
##################################################################################################
# READ AND EXPLORE THE DATA (END)
##################################################################################################

##################################################################################################
# SET UP THE MODEL (BEGINNING)
##################################################################################################
studyDesign = data.frame(log = as.factor(rownames(XData)))
rL.log = HmscRandomLevel(units = levels(studyDesign$log))

# REGRESSION MODEL FOR ENVIRONMENTAL COVARIATES.
XData$sequencing.depth = log(XData$sequencing.depth)
XFormula = ~ decay + GC + uprooted +  sequencing.depth

TrFormula = ~ surveytype


my.distr = c(rep("probit",ns),rep("normal",ns.subset),rep("probit",ns),rep("normal",ns))

m = Hmsc(Y = Y,
         XData = XData,  XFormula = XFormula,
         TrData = TrData, TrFormula = TrFormula,
         distr=my.distr,
         studyDesign=studyDesign, ranLevels={list(log=rL.log)})
##################################################################################################
# SET UP THE MODEL (END)
##################################################################################################

##################################################################################################
# COMBINING AND SAVING MODELS (BEGINNING)
models = list(m)
names(models) = c("fungal model")
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

