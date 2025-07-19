# download packages
pkgs_needed = c("MASS","ExperimentHub", "tidyverse","glmnet", "RColorBrewer","caret")
letsinstall = setdiff(pkgs_needed, installed.packages()) 
if (length(letsinstall) > 0) {
  for (pkg in letsinstall) {
    BiocManager::install(pkg, dependencies = TRUE)
  }
}

# downoad gene expression data
download.file(
  url = "http://web.stanford.edu/class/bios221/data/diabetes.csv",
  destfile = "diabetes.csv",
  mode = "wb"
)
