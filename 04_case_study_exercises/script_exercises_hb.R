# Set the base directory
#setwd("U:/all stuff/TEACHING/HMSC/2022 Jyv?skyl?/case study for exercises")
#setwd("C:/Users/rburner/OneDrive - DOI/Hmsc workshop/JYU 2022/pipeline and case study/")

#Set working directory (should be universal)
setwd(
  dirname(
    rstudioapi::callFun(
      'getActiveDocumentContext'
    )$path
  )
);getwd()

##################################################################################################
# INPUT AND OUTPUT OF THIS SCRIPT (BEGINNING)
##################################################################################################
#	INPUT. Original datafiles of the case study, placed in the data folder.

#	OUTPUT. Unfitted models, i.e., the list of Hmsc model(s) that have been defined but not fitted yet,
# stored in the file "models/unfitted_models.RData".
##################################################################################################
# INPUT AND OUTPUT OF THIS SCRIPT (END)
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
##################################################################################################
# SET DIRECTORIES (END)
##################################################################################################


##################################################################################################
# READ AND SELECT SPECIES DATA (BEGINNING)
##################################################################################################
data = read.csv(file.path(dataDir, "species.csv"))
Y = as.matrix(data[,2:658])
sp.names = colnames(Y)
hist(Y)
##################################################################################################
# READ AND SELECT SPECIES DATA (END)
##################################################################################################


##################################################################################################
# READ AND MODIFY ENVIRONMENTAL DATA (BEGINNING)
##################################################################################################
XData = read.csv(file.path(dataDir, "environment.csv"), as.is = FALSE)
head(XData)
XData$id = as.factor(XData$id)
plot(XData)
hist(XData$volume)
XData$volume = log(XData$volume)
hist(XData$volume)
hist(XData$decay)
XData$decay[XData$decay==4]=3
hist(XData$decay)
##################################################################################################
# READ AND MODIFY ENVIRONMENTAL DATA (BEGINNING)
##################################################################################################


##################################################################################################
# READ AND MODIFY TRAIT DATA (BEGINNING)
##################################################################################################
TrData = read.csv(file.path(dataDir, "traits.csv"), as.is = FALSE)
head(TrData)
sp.names[1:10]
TrData$species[1:10]
all(sp.names == TrData$species)
rownames(TrData) = TrData$species
plot(TrData)
hist(TrData$volume)
TrData$volume = log(TrData$volume)
hist(TrData$volume)
hist(TrData$shape)
TrData$shape = log(TrData$shape)
hist(TrData$shape)
##################################################################################################
# READ AND MODIFY TRAIT DATA (END)
##################################################################################################


##################################################################################################
# SELECT COMMON SPECIES AND COUNT SPECIES RICHNESS FOR COMMON AND RARE SPECIES (BEGINNING)
##################################################################################################
prev = colSums(Y)
hist(prev)
sum(prev>=10)
sum(prev>=20)
sel.sp = (prev>=20)
S.common = rowSums(Y[,sel.sp]) #species richness of common = selected species
S.rare = rowSums(Y[,!sel.sp]) #species richness of rare = unselected species
plot(S.common,S.rare)
Y = Y[,sel.sp] #presence-absence data for selected species
TrData = TrData[sel.sp,]
TrData = droplevels(TrData)
dim(TrData)
head(TrData)
str(TrData)
##################################################################################################
# SELECT COMMON SPECIES AND COUNT SPECIES RICHNESS FOR COMMON AND RARE SPECIES (END)
##################################################################################################


##################################################################################################
# SET UP THE MODEL (BEGINNING)
##################################################################################################
# STUDY DESIGN
studyDesign = data.frame(site=XData$site, id=XData$id)
# RANDOM EFFECT STRUCTURE, HERE Site (hierarchical study design)
rL.site = HmscRandomLevel(units = levels(studyDesign$site))
# REGRESSION MODEL FOR ENVIRONMENTAL COVARIATES.
XFormula = ~ tree+volume+decay+index
# REGRESSION MODEL FOR TRAITS
TrFormula = ~ fb+orn+shape+volume
# CONSTRUCT TAXONOMICAL TREE TO BE USED AS PROXY FOR PHYLOGENETIC TREE
library(ape)
library(phytools)
taxonomicTree = as.phylo.formula(~phylum/class/order/family/genus/species,data = TrData)
plot(taxonomicTree)
source("./as.phylo.formula.R") #NOTE; SHOULD USE FORMULA FROM A PACKAGE RATHER THAN SELF-MADE; CHECK IF TREE REMAINS ULTRAMETRIC
taxonomicTree = as.phylo.formula(~phylum/class/order/family/genus/species,data = TrData)
plot(taxonomicTree)
# CONSTRUCT THE MODELS.

# PRESENCE-ABSENCE MODEL FOR INDIVIDUAL SPECIES (COMMON ONLY)
m = Hmsc(Y=Y, XData = XData,  XFormula = XFormula,
         #TrData = TrData, TrFormula = TrFormula,
         #phyloTree = taxonomicTree,
         distr="probit"  )#,
         #studyDesign = studyDesign, ranLevels=list(site=rL.site))

m

# SPECIES RICHNESS MODEL FOR COMMON AND RARE SPECIES
Y.S = cbind(S.common,S.rare)
colnames(Y.S) = c("S.common","S.rare")
hist(Y.S)
m.S = Hmsc(Y=Y.S, XData = XData,  XFormula = XFormula,
           distr="poisson",
           studyDesign = studyDesign, ranLevels=list(site=rL.site))
##################################################################################################
# SET UP THE MODEL (END)
##################################################################################################


##################################################################################################
# COMBINING AND SAVING MODELS (START)
##################################################################################################
models = list(m,m.S)
names(models) = c("presence-absence model","species richness model")
save(models, file = file.path(modelDir, "unfitted_models.RData"))
##################################################################################################
# COMBINING AND SAVING MODELS (END)
##################################################################################################


##################################################################################################
# TESTING THAT MODELS FIT WITHOUT ERRORS (START)
##################################################################################################
for(i in 1:length(models)){
  print(i)
  sampleMcmc(models[[i]],samples=2)
}
##################################################################################################
# TESTING THAT MODELS FIT WITHOUT ERRORS (END)
##################################################################################################
