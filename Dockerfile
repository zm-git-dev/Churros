### Churros: Docker image for ChIP-seq analysis
FROM rnakato/database:Ensembl106
MAINTAINER Ryuichiro Nakato <rnakato@iqb.u-tokyo.ac.jp>

WORKDIR /opt

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt update \
    && apt install -y --no-install-recommends \
    build-essential \
    libboost-all-dev \
    libbz2-dev \
    libcurl4-gnutls-dev \
    libgtkmm-3.0-dev \
    libgzstream0 \
    libgzstream-dev \
    liblzma-dev \
    libz-dev \
    cmake \
    curl \
    pigz \
    && apt clean \
    && rm -rf /var/lib/apt/list

# BWA 0.7.17
COPY bwa-0.7.17.tar.bz2 bwa-0.7.17.tar.bz2
RUN tar xvfj bwa-0.7.17.tar.bz2 \
    && cd bwa-0.7.17 \
    && make \
    && rm /opt/bwa-0.7.17.tar.bz2

# Bowtie1.3.1
COPY bowtie-1.3.1-linux-x86_64.zip bowtie-1.3.1-linux-x86_64.zip
RUN unzip bowtie-1.3.1-linux-x86_64.zip \
    && rm bowtie-1.3.1-linux-x86_64.zip

# Bowtie2.4.5
COPY bowtie2-2.4.5-linux-x86_64.zip bowtie2-2.4.5-linux-x86_64.zip
RUN unzip bowtie2-2.4.5-linux-x86_64.zip \
    && rm bowtie2-2.4.5-linux-x86_64.zip

RUN git clone https://github.com/rnakato/SSP.git \
    && cd SSP \
    && make
RUN git clone --recursive https://github.com/rnakato/DROMPAplus \
    && cd DROMPAplus \
    && git submodule foreach git pull origin master \
    && make

ENV PATH ${PATH}:/opt/SSP/bin:/opt/DROMPAplus/bin:/opt/DROMPAplus/submodules/cpdf/Linux-Intel-64bit:/opt/DROMPAplus/otherbins:/opt:/opt/bwa-0.7.17:/opt/bowtie-1.3.1-linux-x86_64:/opt/bowtie2-2.4.5-linux-x86_64