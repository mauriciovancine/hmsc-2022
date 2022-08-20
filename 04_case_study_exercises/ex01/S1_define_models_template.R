# Set the base directory using your favorite method
setwd("/home/mude/data/onedrive/doutorado/04_cursos/cursos_realizados/hmsc_2022")

##################################################################################################
# INPUT AND OUTPUT OF THIS SCRIPT (BEGINNING)
##################################################################################################
#	INPUT. Original datafiles of the case study, placed in the data folder.

#	OUTPUT. Unfitted models, i.e., the list of Hmsc model(s) that have been defined
# but not fitted yet, stored in the file "models/unfitted_models.RData".
##################################################################################################
# INPUT AND OUTPUT OF THIS SCRIPT (END)
##################################################################################################


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
localDir = "04_case_study_exercises"
dataDir = file.path(localDir, "data")
modelDir = file.path(localDir, "ex01/models")
if(!dir.exists(modelDir)) dir.create(modelDir)

##################################################################################################
# SET DIRECTORIES (END)
##################################################################################################


##################################################################################################
# READ AND EXPLORE THE DATA (BEGINNING)
##################################################################################################
# Write here the code needed to read in the data, and explore it by (with View, plot, hist, ...)
# to get and idea of it and ensure that the data are consistent

# Load the community data
y <- readr::read_csv(file.path(dataDir, "species.csv")) |> 
    dplyr::select(-1)
y
hist(as.matrix(y))

# Load the covariate data
x <- readr::read_csv(file.path(dataDir, "environment.csv")) |> 
    dplyr::mutate(id = as.factor(id),
                  volume = log(volume),
                  tree = as.factor(tree),
                  site = as.factor(site),
                  decay = ifelse(decay == 4, 3, decay))
x

##################################################################################################
# READ AND EXPLORE THE DATA (END)
##################################################################################################

##################################################################################################
# SELECT COMMON SPECIES (BEGINNING)
##################################################################################################

sp20 <- colSums(y) >= 20
sp20_names <- names(sp20[sp20 == TRUE])
y20 <- dplyr::select(y, sp20_names)
y20

hist(as.matrix(y20))
hist(colSums(y20))

##################################################################################################
# SELECT COMMON SPECIES (END)
##################################################################################################


##################################################################################################
# SET UP THE MODEL (BEGINNING)
##################################################################################################
# Note that many of the components are optional 
# Here instructions are given at generic level, the details will depend on the model

# Organize the community data in the matrix Y

# Organize the environmental data into a dataframe XData
# Define the environmental model through XFormula
XFormula = ~tree + volume + decay + index 

# Use the Hmsc model constructor to define a model
m = Hmsc(Y = y20,
         XData = x, XFormula=XFormula,
         distr = "probit")

# view model (assuming m is your fitted model)
m
head(m$X)

# note that in the random effects the left-hand sides in the list (year, location, sample)
# refer to the columns of the studyDesign

# In this example we assumed the probit distribution as appropriate for presence-absence data

# It is always a good idea to look at the model object, so type m to the console and press enter
# Look at the components of the model by exploring m$...

# You may define multiple models, e.g.
# alternative covariate selections
# alternative random effect choices
# alternative ways to model the data (e.g. lognormal Poisson versus hurdle model)
# models for different subsets of the data

##################################################################################################
# SET UP THE MODEL (END)
##################################################################################################


##################################################################################################
# In the general case, we could have multiple models. We combine them into a list and given them names.
# COMBINING AND SAVING MODELS (START)
models = list(m)
names(models) = c("presence-absence model")
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
