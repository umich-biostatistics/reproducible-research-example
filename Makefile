# Makefile to build and run docker image

# Variables
IMAGE_NAME = reproducible-research/my_r_image
RESULTS_DIR = ./results/

# Phony targets (not files)
.PHONY: all build run

# Default target
all: run

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

# Run the Docker container
run: build
	@mkdir -p $(RESULTS_DIR)
	docker run --rm -v $(RESULTS_DIR):/usr/src/app/results/ $(IMAGE_NAME)