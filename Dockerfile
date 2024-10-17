# Use the latest Rocker image for R
FROM rocker/r-ver:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the source code from the host to the container
COPY . /usr/src/app

# Update package repository and install dependencies
RUN apt-get update && \
    apt-get install -y wget g++ make libssl-dev libcurl4-openssl-dev libxml2-dev \
    git cmake pandoc \
    libfontconfig1-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev zlib1g-dev \
    libcairo2-dev libharfbuzz-dev libfribidi-dev libxt-dev && \
    rm -rf /var/lib/apt/lists/*

# Download and install JAGS from SourceForge
RUN wget -O JAGS-4.3.2.tar.gz https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/Source/JAGS-4.3.2.tar.gz/download && \
    tar -zxvf JAGS-4.3.2.tar.gz && \
    cd JAGS-4.3.2 && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    cd .. && \
    rm -rf JAGS-4.3.2.tar.gz download

# wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.57/quarto-1.5.57-linux-arm64.deb
# dpkg -i quarto-1.5.57-linux-arm64.deb

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

# Set the JAGS_HOME environment variable
#ENV JAGS_HOME /usr/local

# Install renv package and restore environment
RUN R -e "renv::restore()"

# Install R packages (uncomment if needed)
# RUN Rscript -e "install.packages(c('rjags', 'yaml', 'targets', 'tidyverse'), repos='https://cloud.r-project.org')"

# Set the default command to run the R script
#CMD ["Rscript", "-e", "targets::tar_make()"]

# Alternative command to run a specific R script (uncomment if needed)
# CMD ["Rscript", "sim-binomial-bayes.R"]
