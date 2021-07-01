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
    apt-utils \
    openssl

RUN apt update

# ENV NVM_DIR /usr/local/nvm
# ENV NODE_VERSION 16.1.0
# RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
# RUN apt-get install -y nodejs
# RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
# RUN $NVM_DIR/nvm.sh \
#     && nvm install $NODE_VERSION \
#     && nvm alias default $NODE_VERSION \
#     && nvm use default
# ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
# ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash

RUN apt-get install -y nodejs
RUN node -v
RUN npm -v


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