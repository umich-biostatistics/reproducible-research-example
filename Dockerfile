# Use the latest Rocker image for R
FROM rocker/r-ver:4.4

# Update package repository and install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget g++ make libssl-dev libcurl4-openssl-dev libxml2-dev \
    libfontconfig1-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev zlib1g-dev \
    libcairo2-dev libharfbuzz-dev libfribidi-dev libxt-dev libglpk-dev jags=4.3.* && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && apt-get clean

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the source code from the host to the container
COPY . /usr/src/app

# Install renv package and restore environment
RUN echo 'options(Ncpus = as.integer(system("/usr/bin/nproc", intern = TRUE)) - 1)' >> /usr/local/lib/R/etc/Rprofile.site \
    && R -e "renv::restore()"

# Set the default command to run the R script
ENTRYPOINT ["Rscript", "-e", "targets::tar_make()"]
