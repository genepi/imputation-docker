FROM continuumio/miniconda3
MAINTAINER Lukas Forer <lukas.forer@i-med.ac.at> / Sebastian Schönherr <sebastian.schoenherr@i-med.ac.at>

RUN apt-get --allow-releaseinfo-change update && apt-get install -y procps unzip libgomp1 tabix cmake python-pip python-dev zlib1g-dev liblzma-dev libbz2-dev
RUN pip install cget

# Install jbang (not as conda package available)
WORKDIR "/opt"
RUN wget https://github.com/jbangdev/jbang/releases/download/v0.79.0/jbang-0.79.0.zip && \
    unzip -q jbang-*.zip && \
    mv jbang-0.79.0 jbang  && \
    rm jbang*.zip
ENV PATH="/opt/jbang/bin:${PATH}"

# Install eagle
WORKDIR "/opt"
RUN wget https://storage.googleapis.com/broad-alkesgroup-public/Eagle/downloads/Eagle_v2.4.1.tar.gz && \
    tar xvfz Eagle_v2.4.1.tar.gz && \
    rm Eagle_v2.4.1.tar.gz && \
    mv Eagle_v2.4.1/eagle /usr/bin/.

# Install minimac4 v1.0.2
WORKDIR "/opt"
RUN git clone https://github.com/statgen/Minimac4  && \
    cd Minimac4 && \
    git checkout tags/v1.0.2  && \
    cget install -f ./requirements.txt  && \
    mkdir build && cd build  && \
    cmake -DCMAKE_TOOLCHAIN_FILE=../cget/cget/cget.cmake .. && \
    make && \
    make install

# Install bcftools
WORKDIR "/opt"
RUN wget https://github.com/samtools/bcftools/releases/download/1.13/bcftools-1.13.tar.bz2  && \
    tar xvfj bcftools-1.13.tar.bz2 && \
    cd  bcftools-1.13  && \
    ./configure  && \
    make && \
    make install
