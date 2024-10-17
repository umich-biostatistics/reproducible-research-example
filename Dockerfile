# Use the latest Rocker image for R
FROM mkleinsa/sim-binom-bayes-base-image:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the source code from the host to the container
COPY . /usr/src/app

# Set the default command to run the R script
ENTRYPOINT ["Rscript", "-e", "targets::tar_make()"]