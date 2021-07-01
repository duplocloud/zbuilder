FROM ubuntu:20.04
RUN apt-get clean
RUN apt-get update
RUN apt-get install --yes --no-install-recommends apt-transport-https ca-certificates software-properties-common
RUN apt-get install --yes --no-install-recommends curl
RUN apt-get install --yes --no-install-recommends wget

RUN apt-get install --yes --no-install-recommends build-essential python2.7 python2.7-dev
RUN add-apt-repository universe
RUN apt update
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
RUN python2.7 get-pip.py

RUN apt-get install -y apt-transport-https  ca-certificates curl gnupg-agent software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) \ stable"
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io
RUN apt-get install --yes --no-install-recommends supervisor
RUN apt-get install --yes --no-install-recommends vim
RUN apt-get install --yes --no-install-recommends apt-transport-https

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


# other stuff needed by the builder scripts
RUN pip install --upgrade six>=1.10
RUN pip install setuptools
RUN pip install boto
RUN pip install -U pip
RUN pip install awscli

RUN pip install requests logger

COPY zbuild.sh /zbuild.sh
COPY zbuildmonitor.py /zbuildmonitor.py

# set up supervisord
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf -n"]