# Makefile to build and run docker image

# Variables
IMAGE_NAME = umich-biostatistics/reproducible-research-example:sim-binom-bayes
RESULTS_DIR = ./results/

# Phony targets (not files)
.PHONY: help all run_local docker_build docker_run docker_pull

help:
	@echo "Makefile Usage:"
	@echo "  make run_local        - Run the R script locally."
	@echo "  make docker_build     - Build a Docker image from the Dockerfile."
	@echo "  make docker_run       - Run the Docker image built locally."
	@echo "  make docker_pull      - Pull a remote Docker image and run it."

# Default target
all: help

run_local:
	Rscript -e "renv::restore();targets::tar_make()"

# Build the Docker image
docker_build:
	docker build -t $(IMAGE_NAME) .

# Run existing Docker container
docker_run:
	docker run --rm -v $(RESULTS_DIR):/usr/src/app/results/ $(IMAGE_NAME)

# Pull from GHCR and run
docker_pull:
	docker pull ghcr.io/umich-biostatistics/reproducible-research-example:sim-binom-bayes
