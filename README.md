# U-M Biostat Reproducible Research Example

This example was create for a workshop given by Mike Kleinsasser and Jacob Gladfelter.

The workshop covers tools and best practices for reproducible research

## Dependencies

- **Docker**
  - [Docker Desktop](https://docs.docker.com/get-started/get-docker/) OR
  - [Docker CE/Docker Engine](https://docs.docker.com/engine/install/)
  - Alternatively, Mac users should [OrbStack](https://orbstack.dev/)
- GNU make
  - This should be available on most Unix-like/Linux systems
  - [Windows Users](https://gnuwin32.sourceforge.net/packages/make.htm)

## Use

Simply clone the repository and run `make` from the terminal.

---

# Clone repository to your local computer

git clone ...

## Open project in RStudio



## Setup and Deployment

To build your renv.lock file for the container, you’ll want to create it on your local machine first. Here’s how to do it:

Initialize renv and install all necessary packages as you would for development.

```{r, eval = FALSE}
install.packages("renv")
renv::init()
```

Install All Required Packages:

```{r, eval = FALSE}
install.packages(c("rjags", "yaml", "tidyverse", "targets"))
```

Run renv::snapshot():

Once all packages are installed, create the renv.lock file by running:

```{r, eval = FALSE}
renv::snapshot()
```

This command will initialize renv, create the renv.lock file, and install any existing dependencies.

The `renv` package was used to lock R package dependencies for this project. If 
you are a user and would like to reproduce the results of this image, no further 
setup is required. 

If, on the other hand, you would like to rebuild the image from scratch, start by
installing these dependencies:

```{r, eval = FALSE}
install.packages(c("rjags", "yaml", "tidyverse", "targets"))
```

Current working link for JAGS sources:
https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/Source/JAGS-4.3.2.tar.gz/download

1. Docker Build Command

docker build -t my_r_image .

2. Docker Run Command

docker run --rm -it my_r_image

docker run -v $(pwd)/config.yaml:/usr/local/bin/config.yaml my_r_image
