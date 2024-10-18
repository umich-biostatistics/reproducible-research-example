# Makefile to build and run docker image

# Variables
IMAGE_NAME = reproducible-research-example:latest
GHCR_IMAGE = ghcr.io/umich-biostatistics/$(IMAGE_NAME)
RESULTS_DIR = ./results/
DOC_DIR = ./doc/

# Phony targets (not files)
.PHONY: help all run_local docker_build docker_run docker_pull

help:
	@echo "Makefile Usage:"
	@echo "  make local        - Run the R script locally."
	@echo "  make docker_build     - Build a Docker image from the Dockerfile."
	@echo "  make docker_run       - Run the Docker image, pull if not found."
	@echo "  make docker_pull      - Pull a remote Docker image."

# Default target
all: help

local:
	Rscript -e "renv::restore();targets::tar_make()"

# Build the Docker image
docker_build:
	docker build -t $(IMAGE_NAME) .

docker_run:
	@if docker image ls | grep -q ^reproducible-research-example; then \
		echo "Found local image $(IMAGE_NAME). Running it..."; \
		docker run --rm -v $(RESULTS_DIR):/usr/src/app/results/ -v $(DOC_DIR):/usr/src/app/doc/ $(IMAGE_NAME); \
	else \
		echo "Image $(IMAGE_NAME) not found locally. Pulling from GHCR..."; \
		$(MAKE) docker_pull; \
		echo "Running pulled image..."; \
		docker run --rm -v $(RESULTS_DIR):/usr/src/app/results/ -v $(DOC_DIR):/usr/src/app/doc/ $(GHCR_IMAGE); \
	fi

# Pull image from GHCR
docker_pull:
	docker pull $(GHCR_IMAGE)
