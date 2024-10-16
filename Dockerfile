# Use the latest Rocker image for R
#FROM rocker/r-ver:latest

# Set the working directory in the container
#WORKDIR /usr/src/app

# Copy the source code from the host to the container
#COPY . /usr/src/app

# Update package repository and install dependencies
#RUN apt-get update && \
#    apt-get install -y wget g++ make libssl-dev libcurl4-openssl-dev libxml2-dev \
#    libfontconfig1-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev zlib1g-dev && \
#    rm -rf /var/lib/apt/lists/*

# Download and install JAGS from GitHub
#RUN wget -O JAGS-4.3.2.tar.gz https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/Source/JAGS-4.3.2.tar.gz/download && \
#    tar -zxvf JAGS-4.3.2.tar.gz && \
#    cd JAGS-4.3.2 && \
#    ./configure --prefix=/usr/local && \
#    make && \
#    make install && \
#    cd .. && \
#    rm -rf JAGS-4.3.2.tar.gz download

# Set the JAGS_HOME environment variable
#ENV JAGS_HOME /usr/local

# Install R packages
#RUN Rscript -e "install.packages(c('rjags', 'yaml', 'targets', 'tidyverse'), repos='https://cloud.r-project.org')"








# Use the latest Rocker image for R
FROM rocker/r-ver:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the source code from the host to the container
COPY . /usr/src/app

# Update package repository and install dependencies
RUN apt-get update && \
    apt-get install -y wget g++ make libssl-dev libcurl4-openssl-dev libxml2-dev \
    libfontconfig1-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev zlib1g-dev \
    libcairo2-dev libharfbuzz-dev libfribidi-dev libxt-dev && \
    rm -rf /var/lib/apt/lists/*

# Download and install JAGS from GitHub
RUN wget -O JAGS-4.3.2.tar.gz https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/Source/JAGS-4.3.2.tar.gz/download && \
    tar -zxvf JAGS-4.3.2.tar.gz && \
    cd JAGS-4.3.2 && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    cd .. && \
    rm -rf JAGS-4.3.2.tar.gz download

# Set the JAGS_HOME environment variable
ENV JAGS_HOME /usr/local

# Install R packages
RUN Rscript -e "install.packages(c('rjags', 'yaml', 'targets', 'tidyverse'), repos='https://cloud.r-project.org')"


# Set the default command to run the R script
#CMD ["Rscript", "-e", "targets::tar_make()"]

#CMD ["Rscript", "sim-binomial-bayes.R"]













# apt-get install r-cran-rjags

# Install JAGS and dependencies for rjags
#RUN apt-get update && apt-get install -y \
#    jags \
#    libssl-dev \
#    libcurl4-openssl-dev \
#    libxml2-dev && \
#    rm -rf /var/lib/apt/lists/*

# Update package list
# RUN apt-get update && apt-get install -y \
#    wget \
#     g++ \
#     make  && \
#     wget https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/jags-4.x.tar.gz && \
#     tar -zxvf jags-4.x.tar.gz && \
#     cd jags-4.x && \
#     ./configure && \
#     make && \
#     make install && \
#     cd .. && \
#     rm -rf jags-4.x jags-4.x.tar.gz


# Copy the R script into the container
#COPY sim-binomial-bayes.R /usr/local/bin/sim-binomial-bayes.R

# Set the default command to run the R script
#CMD ["Rscript", "/usr/local/bin/sim-binomial-bayes.R"]