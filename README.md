# Reproducible Research: Tools and Best Practices

2024-10-18

## Goal

Create a reproducible example that attendees can clone and run on their local machine using their existing install of R **if they have met dependencies**, or build/pull docker container and run.

Example will run 2 R scripts using Targets and renv, then produce an HTML file using Quarto.

If using docker, they should be able to either build or pull an existing image.
The container will mount the necessary directories as volumes to allow viewing of results.

We can fulfill these options using **make**:

| **make Command** | **Description**                                                    |
| ---------------: | :----------------------------------------------------------------- |
|     docker_build | build a local image                                                |
|       docker_run | run the container                                                  |
|      docker_pull | pull the image from GHCR.io                                        |
|            local | run the `Rscript -e "renv::restore();targets::tar_make()"` command |


## Dependencies

### Docker Option

-  [Docker Desktop](https://docs.docker.com/get-started/get-docker/) or [Docker CE/Docker Engine](https://docs.docker.com/engine/install/)
    - macOS users can try [OrbStack](https://orbstack.dev/)
- make
    - available by default on most linux/unix-like systems
    - [Windows Users](https://gnuwin32.sourceforge.net/packages/make.htm)

### Local Option

- make (see above)
- [JAGS](https://sourceforge.net/projects/mcmc-jags/)
    - Alternatively check your local package manager for a binary
        - macOS - homebrew
        - linux - apt/pacman/dnf/yum/etc
- [Quarto](https://quarto.org/docs/get-started/)

## Usage

### Docker

1. Install dependencies Docker Option
2. `git clone https://github.com/umich-biostatistics/reproducible-research-example.git` 
3. `cd reproducible-research-example`
4. `make docker_pull`
    - if you'd like to build the image yourself, use `make docker_build && make docker_run`

### Local

1. Install all Dependencies
2. `git clone https://github.com/umich-biostatistics/reproducible-research-example.git` 
3. `cd reproducible-research-example`
4. `make local`

## Checking Results

Using either method, you should have results in the `results/` directory.
