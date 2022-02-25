FROM continuumio/miniconda3
MAINTAINER Lukas Forer <lukas.forer@i-med.ac.at> / Sebastian Schönherr <sebastian.schoenherr@i-med.ac.at>
COPY environment.yml .
RUN \
   conda env update -n root -f environment.yml \
&& conda clean -a
RUN apt-get update && apt-get install -y build-essential unzip tabix
RUN pip install cget

# Install jbang
ENV JBANG_VERSION=0.79.0
WORKDIR "/opt"
RUN wget https://github.com/jbangdev/jbang/releases/download/v${JBANG_VERSION}/jbang-${JBANG_VERSION}.zip && \
    unzip -q jbang-*.zip && \
    mv jbang-${JBANG_VERSION} jbang  && \
    rm jbang*.zip
ENV PATH="/opt/jbang/bin:${PATH}"

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
WORKDIR "/opt"
RUN mkdir minimac4
COPY files/bin/minimac4 minimac4/.
ENV PATH="/opt/minimac4:${PATH}"

# Install PGS-CALC
ENV PGS_CALC_VERSION=v0.9.14
WORKDIR "/opt"
RUN wget https://github.com/lukfor/pgs-calc/releases/download/${PGS_CALC_VERSION}/installer.sh  && \
    bash installer.sh && \
    mv pgs-calc.jar /usr/bin/.
