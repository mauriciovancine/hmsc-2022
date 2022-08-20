# THIS SCRIPT CONSTRUCTS THE HMSC MODELS FOR THE PLANT EXAMPLE (SECTION 6.7) OF THE BOOK
# Ovaskainen, O. and Abrego, N. 2020. Joint Species Distribution Modelling - With Applications in R. Cambridge University Press.

# Set the base directory
setwd("/home/mude/data/onedrive/doutorado/04_cursos/cursos_realizados/hmsc_2022")


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
# Load the data
load(file=file.path(dataDir,"allData.RData"))
# Y, XData, TrData, plant.tree

# the matrix `Y` contains species abundances
dim(Y)
head(Y)

# the dataframe `XData` contains the environmental variable TMG
dim(XData)
head(XData)
# Sites on mesic, north-facing slopes receive lower numbers of TMG
# and sites on warmer, south-facing slopes receive higher numbers of
# TMG (Damschen et al. 2010, Miller et al. 2018).

# The dataframe `TrData` contains the functional trait that Miller et
# al. (2018) selected for their analyses: leaf tissue
# carbon-to-nitrogen ratio (C:N).

dim(TrData)
head(TrData)

# The variable plant.tree contains a taxonomy of the species
plant.tree
plot(plant.tree,cex=0.5)

# ECOLOGICAL CONTEXT AND HYPOTHESES
#
# The C:N ratio can be considered as a surrogate of competitive
# ability, plants with low C:N growing faster but having lower stress
# tolerance than plants with high C:N (Miller et al. 2018, Cornelissen
# et al. 2003, Poorter & Bongers 2006).

# It can be thus expected that species occurring on drier and warmer
# sites have on average higher C:N ratio, leading to positive
# relationship between TMG and C:N ratio.
#
# Miller et al. (2018) applied several statistical methods to examine
# if there is an association with the C:N ratio and the environmental
# gradient.
#
# Here we re-analyse this question with HMSC.

# After this initial exploration of the data, we are ready to set up
# the HMSC models.
##################################################################################################
# READ AND EXPLORE THE DATA (END)
##################################################################################################

##################################################################################################
# SET UP THE MODEL (BEGINNING)
##################################################################################################

# For simplicity, we will fit just a a probit model for presence-absence data

Y.pa = 1*(Y>0)
head(Y.pa)

# We will use TMG as the only environmental covariate, and assume a
# linear effect

XFormula = ~TMG

# We will use CN as the only trait covariate, and assume a linear
# effect

TrFormula = ~CN


# We next define the Hmsc model.

m = Hmsc(Y=Y.pa,
         XData = XData,  XFormula=XFormula,
         TrData = TrData, TrFormula = TrFormula,
         phyloTree = plant.tree,
         distr="probit")

# We included environmental covariates through XData and XFormula

# We included trait covariates by TrData and TrFormula

# We included the phylogenetic relationships by phyloTree

# We assumed the probit distribution as appropriate for
# presence-absence data

# The data have no specific structure and we did not include any random
# effects, thus we did not beed to define studyDesign nor ranLevels

# It is always a good idea to look at the model object.

m
##################################################################################################
# SET UP THE MODEL (END)
##################################################################################################


##################################################################################################
# In the general case, we could have multiple models. We combine them into a list and given them names.
# COMBINING AND SAVING MODELS (START)
models = list(m)
names(models) = c("plants.pa.model")
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
