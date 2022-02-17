FROM continuumio/miniconda3
MAINTAINER Lukas Forer <lukas.forer@i-med.ac.at> / Sebastian Schönherr <sebastian.schoenherr@i-med.ac.at>
COPY environment.yml .
RUN \
   conda env update -n root -f environment.yml \
&& conda clean -a

RUN apt-get --allow-releaseinfo-change update && apt-get install -y procps unzip libgomp1 tabix
RUN apt-get install -y  cmake python-pip python-dev zlib1g-dev liblzma-dev libbz2-dev
RUN pip install cget

# Install jbang
ENV JBANG_VERSION=0.79.0
WORKDIR "/opt"
RUN wget https://github.com/jbangdev/jbang/releases/download/v${JBANG_VERSION}/jbang-${JBANG_VERSION}.zip && \
    unzip -q jbang-*.zip && \
    mv jbang-${JBANG_VERSION} jbang  && \
    rm jbang*.zip
ENV PATH="/opt/jbang/bin:${PATH}"

# TODO: install specific version of tabix

# Install eagle
ENV EAGLE_VERSION=2.4
WORKDIR "/opt"
RUN wget https://storage.googleapis.com/broad-alkesgroup-public/Eagle/downloads/old/Eagle_v${EAGLE_VERSION}.tar.gz && \
    tar xvfz Eagle_v${EAGLE_VERSION}.tar.gz && \
    rm Eagle_v${EAGLE_VERSION}.tar.gz && \
    mv Eagle_v${EAGLE_VERSION}/eagle /usr/bin/.

# Install eagle
ENV BEAGLE_VERSION=18May20.d20
WORKDIR "/opt"
RUN wget https://faculty.washington.edu/browning/beagle/beagle.${BEAGLE_VERSION}.jar && \
    mv beagle.${BEAGLE_VERSION}.jar /usr/bin/.

# Install minimac4
ENV MINIMAC_VERSION=f18fadf748ce6d1fb8d17b647c1cb07fb8819515
WORKDIR "/opt"
RUN git clone https://github.com/statgen/Minimac4  && \
    cd Minimac4 && \
    git checkout f18fadf748ce6d1fb8d17b647c1cb07fb8819515 && \
    cget install -f ./requirements.txt  && \
    mkdir build && cd build  && \
    cmake -DCMAKE_TOOLCHAIN_FILE=../cget/cget/cget.cmake .. && \
    make && \
    make install

# Install bcftools
ENV BCFTOOLS_VERSION=1.13
WORKDIR "/opt"
RUN wget https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2  && \
    tar xvfj bcftools-${BCFTOOLS_VERSION}.tar.bz2 && \
    cd  bcftools-${BCFTOOLS_VERSION}  && \
    ./configure  && \
    make && \
    make install

# Install bcftools
ENV PGS_CALC_VERSION=v0.9.6
WORKDIR "/opt"
RUN wget https://github.com/lukfor/pgs-calc/releases/download/${PGS_CALC_VERSION}/installer.sh  && \
    bash installer.sh && \
    mv pgs-calc.jar /usr/bin/.
