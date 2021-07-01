FROM duplocloud/zbuilder:v7

ENV GOROOT /opt/go
ENV GOPATH /root/.go

ENV GOVERSION 1.15.3
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV LANG en_US.UTF-8

RUN  apt-get update && apt-get -y install \
    bash \
    git  \
    make \
    wget \
    vim \
    unzip \
    curl \
    jq \
    ca-certificates \
    apt-transport-https \
    gnupg-agent \
    software-properties-common \
    openssl

RUN cd /opt && wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
    tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz
RUN mkdir -p $GOPATH
ENV GOBIN="$HOME/go/bin"
RUN mkdir -p $GOBIN
ENV PATH=$PATH:$GOROOT/bin:$GOBIN

RUN  apt-get update && apt-get -y install libprotobuf-dev protobuf-compiler golang-goprotobuf-dev