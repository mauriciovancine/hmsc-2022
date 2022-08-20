# THIS SCRIPT PREPROCESSES DATA FOR THE PLANT EXAMPLE (SECTION 6.7) OF THE BOOK
# Ovaskainen, O. and Abrego, N. 2020. Joint Species Distribution Modelling - With Applications in R. Cambridge University Press.

# We first set the working directory to the directory that has all the
# files for this case study. We recommend that you create always the
# subdirectories "data", "models" and "results" under the main directory. If running
# the script in another computer, all that needs to be changed in the
# script below is the main directory. Working directory defined below works
# only in our local computer system, and you need to modify that in
# your own system. For instance, in a MacOS system this could be
# "~/Data/HMSC_book/Section_6_7_plants".

setwd("/home/mude/data/onedrive/doutorado/04_cursos/cursos_realizados/hmsc_2022")
localDir = "03_case_studies/case study plants/"
data.directory = file.path(localDir, "data")

# The factor variables are coded as character strings in our data
# set, and we need them be handled as factors, but this depends on
# the version of R and local settings of options, and therefore we
# use 'stringsAsFactors=TRUE' in read.csv
# We also set the numerical variable site as a factor

data = read.csv(file=file.path(data.directory,"whittaker revisit data.csv"),
                stringsAsFactors=TRUE)
data$site = factor(data$site)
head(data)

# The data are in the long format: each row corresponds to one plant
# species in one site.  The column `value` is plant abundance.  The
# column `env` is Whittaker's index describing the site position on
# the topographic moisture gradient (TMG).

# Sites on mesic, north-facing slopes receive lower numbers of TMG
# and sites on warmer, south-facing slopes receive higher numbers of
# TMG (Damschen et al. 2010, Miller et al. 2018).

# The column `trait` is the functional trait that Miller et
# al. (2018) selected for their analyses: leaf tissue
# carbon-to-nitrogen ratio (C:N).

# We first reformat the data so that it works as input for Hmsc.To do
# so, in the script below we construct

# the matrix `Y` of species abundances

# the dataframe `XData` of the environmental variable TMG

# and the dataframe `TrData` of the trait C:N ratio.

sites = levels(data$site)
species = levels(data$species)
n = length(sites)
ns = length(species)

Y = matrix(NA, nrow = n, ncol = ns)
env = rep(NA,n)
trait = rep(NA,ns)
for (i in 1:n){
  for (j in 1:ns){
    row = data$site==sites[i] & data$species==species[j]
    Y[i,j] = data[row,]$value
    env[i] = data[row,]$env
    trait[j] = data[row,]$trait
  }
}

colnames(Y) = species
XData = data.frame(TMG = env)
TrData = data.frame(CN = trait)
rownames(TrData) = colnames(Y)

# To account for relatedness among the species, we use a taxonomy as a
# proxy for phylogeny.

# To do so, we read in a classification of the species into families
# and genera.

# We then use the function `as.phylo` from the `ape` package to
# construct a taxonomical tree.

# We assume equal branch lengths among families, among genera within a
# family, and among species within a genus.

taxonomy = read.csv(file=file.path(data.directory, "taxonomy.csv"), stringsAsFactors=TRUE)
library(ape)
plant.tree = as.phylo(~family/genus/species, data=taxonomy, collapse = FALSE)
plant.tree$edge.length = rep(1,length(plant.tree$edge))

save(Y, XData, TrData, plant.tree, file=file.path(data.directory,"allData.RData"))
