# UBDS3-2025 Statistics source
If you are a student, who was very curious - well done smart ass, you have all the solutions, but please keep it as our secret :)

This repository contains teaching material for the R statistical course of the Ukrainian Biological Data Science Summer School 2025.

## Contents

* [Setup](labs/00-setup/setup.html)
* [Exploratory Data Analysis](labs/exploratory/exploratory.html)
* [Data and Randomness](labs/randomness/randomness.html)
* [Regression](labs/regression/regression.html)
* [Omics](labs/omics/omics.html)
* [Hypothesis testing](labs/testing/testing.html)
* [Clustering analysis](labs/clustering/clustering.html)
* [Multivariate analysis](labs/multivariate/multivariate.html)
* [Machine Learning](labs/ML/ML.html)


## For faculty members

### Git hook

The repo has `git hook` for automated source rendering and pushing them to the `master` branch once you commit any `*.qmd` files.

To activate the hook, add the following `git` config:

```bash
git config --local core.hooksPath .githooks/
```

### Render.sh script

The script `render.sh` can be used for batch processing multiple sources, it required `quarto-cli` binaries installed and a path to your `R_HOME` (see below). For usage run `./render.sh`.

Hook can automate source rendering with setting env variable, i.e.

```
export RENDER_AUTO=true # use `unset RENDER_AUTO` to disable automatic rendering
```

It is advised to run the `render.sh` script manually before using it in the hook to check whether `quarto` is working properly.

Make sure to have proper `R_HOME` variable, for macOS with RStudio (latest) is `R_HOME=/Library/Frameworks/R.framework/Resources`

## License

The project is licensed under CC0, see `LICENSE` for more information.
