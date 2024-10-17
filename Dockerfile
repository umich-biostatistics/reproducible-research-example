# Use the latest Rocker image for R
FROM rocker/r-ver:4.4

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the source code from the host to the container
COPY . /usr/src/app

# Update package repository and install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget g++ make libssl-dev libcurl4-openssl-dev libxml2-dev \
    libfontconfig1-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev zlib1g-dev \
    libcairo2-dev libharfbuzz-dev libfribidi-dev libxt-dev libglpk-dev jags=4.3.* && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && apt-get clean

# Download and install Quarto CLI based on system architecture
RUN ARCHITECTURE=$(dpkg --print-architecture) && \
    if [ "$ARCHITECTURE" = "arm64" ]; then \
        wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.57/quarto-1.5.57-linux-arm64.deb; \
    elif [ "$ARCHITECTURE" = "amd64" ]; then \
        wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.57/quarto-1.5.57-linux-amd64.deb; \
    else \
        echo "Unsupported architecture: $ARCHITECTURE" && exit 1; \
    fi && \
    dpkg -i quarto-1.5.57-linux-*.deb && \
    rm quarto-1.5.57-linux-*.deb

# Install renv package and restore environment
RUN R -e "renv::restore()"

# Set the default command to run the R script
ENTRYPOINT ["Rscript", "-e", "targets::tar_make()"]

# For debugging
#ENTRYPOINT ["R"]