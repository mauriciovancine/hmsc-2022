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
    dplyr::select(-1) |> 
    dplyr::rename_with(~gsub("-", ".", .x, fixed = TRUE)) |> 
    dplyr::rename_with(~gsub("/", ".", .x, fixed = TRUE))
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
# READ AND MODIFY TRAIT DATA (BEGINNING)
##################################################################################################
tr <- readr::read_csv(file.path(dataDir, "traits.csv")) |> 
    as.data.frame()
tr

all(colnames(y) == tr$species)
rownames(tr) <- tr$species
tr

plot(tr)
hist(tr$volume)

tr <- tr |> 
    dplyr::mutate(volume_log = log(volume),
                  shape_log = log(shape))
tr

ggplot(tr, aes(volume)) + geom_histogram(color = "white", fill = "steelblue") + theme_bw()
ggplot(tr, aes(shape)) + geom_histogram(color = "white", fill = "steelblue") + theme_bw()

ggplot(tr, aes(volume_log)) + geom_histogram(color = "white", fill = "steelblue") + theme_bw()
ggplot(tr, aes(shape_log)) + geom_histogram(color = "white", fill = "steelblue") + theme_bw()

##################################################################################################
# READ AND MODIFY TRAIT DATA (END)
##################################################################################################

##################################################################################################
# SELECT COMMON SPECIES (BEGINNING)
##################################################################################################

sp20 <- colSums(y) >= 20
sp20_names <- names(sp20[sp20 == TRUE])
y20 <- dplyr::select(y, sp20_names)
y20

tr20 <- dplyr::filter(tr, species %in% sp20_names)
tr20 <- droplevels(tr20)
tr20
dim(tr20)

##################################################################################################
# SELECT COMMON SPECIES (END)
##################################################################################################



##################################################################################################
# SET UP THE MODEL (BEGINNING)
##################################################################################################

# STUDY DESIGN
sd <-  data.frame(site = x$site, id = x$id)
sd

# RANDOM EFFECT STRUCTURE, HERE Site (hierarchical study design)
rl_site <- HmscRandomLevel(units = levels(sd$site))
rl_site

# and optionally id, if we are interested in species associations at that level
rl_id <- HmscRandomLevel(units = levels(sd$id))
rl_id

# REGRESSION MODEL FOR ENVIRONMENTAL COVARIATES.
XFormula = ~ tree + volume + decay + index

# REGRESSION MODEL FOR TRAITS
TrFormula = ~ fb + orn + shape + volume
table(tr20$fb)
table(tr20$orn)

# CONSTRUCT TAXONOMICAL TREE TO BE USED AS PROXY FOR PHYLOGENETIC TREE
tr_t <- tr20 |>
    dplyr::select(phylum:genus, species) |> 
    dplyr::mutate(across(phylum:species, as.factor))
tr_t

tt <- as.phylo(~phylum/class/order/family/genus/species, data = tr_t, collapse = FALSE)
tt$edge.length <- rep(1, length(tt$edge))
plot(tt, cex = 0.5)

# CONSTRUCT THE MODELS.

# Use the Hmsc model constructor to define a model
m <- Hmsc(Y = y20,
          XData = x, XFormula = XFormula,
          TrData = tr20, TrFormula = TrFormula,
          phyloTree = tt,
          distr = "probit",
          studyDesign = sd, ranLevels = list(site = rl_site, id = rl_id))


# view model (assuming m is your fitted model)
m
head(m$X)
head(m$XScaled)
head(m$Tr)
head(m$TrScaled)

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
