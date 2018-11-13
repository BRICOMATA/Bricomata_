FROM ubuntu:artful

LABEL \
    description="Docker image containing the VSimRTI adapted ns-3 federate" \
    version="18.1" \
    maintainer="vsimrti@fokus.fraunhofer.de"

RUN \
  apt-get update && \
  apt-get install -y --allow-unauthenticated \
  build-essential \
  gcc \
  g++ \
  pkg-config \
  lbzip2 \
  libprotobuf-dev \
  libsqlite3-dev \
  libxml2-dev \
  protobuf-compiler \
  patch \
  python \
  unzip \
  rsync \
  wget

WORKDIR /home/vsimrti/bin/fed/ns3

COPY ./ns* ./

RUN \
    ./ns3_installer.sh -p --quiet && \
    mkdir -p ns3/scratch

VOLUME ["/home/vsimrti/bin/fed/ns3/scratch"]

EXPOSE 40001 40002

ENTRYPOINT \
    cp scratch/* ns3/scratch && \
    ./run.sh 40001 40002