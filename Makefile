# Makefile to build and run docker image

# Variables
IMAGE_NAME = reproducible-research-example:deploy-package
GHCR_IMAGE = ghcr.io/umich-biostatistics/$(IMAGE_NAME)
RESULTS_DIR = ./results/

# Phony targets (not files)
.PHONY: help all run_local docker_build docker_run docker_pull

help:
	@echo "Makefile Usage:"
	@echo "  make run_local        - Run the R script locally."
	@echo "  make docker_build     - Build a Docker image from the Dockerfile."
	@echo "  make docker_run       - Run the Docker image, pull if not found."
	@echo "  make docker_pull      - Pull a remote Docker image."

# Default target
all: run

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

docker_run:
	@if docker image ls | grep $(IMAGE_NAME); then \
		echo "Found local image $(IMAGE_NAME). Running it..."; \
		docker run --rm -v $(RESULTS_DIR):/usr/src/app/results/ $(IMAGE_NAME); \
	else \
		echo "Image $(IMAGE_NAME) not found locally. Pulling from GHCR..."; \
		$(MAKE) docker_pull; \
		echo "Running pulled image..."; \
		docker run --rm -v $(RESULTS_DIR):/usr/src/app/results/ $(IMAGE_NAME); \
	fi

# Pull image from GHCR
docker_pull:
	docker pull $(GHCR_IMAGE)
