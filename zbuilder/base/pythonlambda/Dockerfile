FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get clean
RUN apt-get update
RUN apt-get install --yes --no-install-recommends software-properties-common
RUN apt-get install -y build-essential checkinstall
RUN apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev
RUN apt-get install -y wget vim git


RUN apt-get install --yes --no-install-recommends rsyslog
RUN apt-get install --yes --no-install-recommends curl

RUN apt-get update
RUN apt-get install --yes --no-install-recommends libmysqlclient-dev
RUN apt-get install --yes --no-install-recommends --fix-missing mysql-client
RUN apt-get install --yes --no-install-recommends nginx
RUN apt-get install -y --no-install-recommends  encfs uwsgi nginx nginx-extras   uuid-dev libcap-dev libpcre3-dev git
RUN apt-get install -y libxml2-dev libxslt1-dev


RUN apt-get update &&  apt-get install -y curl python3.7 python3.7-dev python3.7-distutils python3-venv
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
RUN update-alternatives --set python /usr/bin/python3.7
RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py --force-reinstall && \
    rm get-pip.py

RUN apt-get install -y  python3-dateutil python3-mysqldb uwsgi-plugin-python3
RUN pip install --upgrade setuptools

RUN pip3 install supervisor
RUN ln -s /usr/local/bin/supervisorctl /usr/bin/supervisorctl
RUN ln -s /usr/local/bin/supervisord /usr/bin/supervisord

RUN pip3 install boto3
RUN apt-get install -y awscli
RUN apt-get install -y openssh-client

#jdk repository
RUN add-apt-repository ppa:openjdk-r/ppa

USER root
###  remove below if using build-image.sh
COPY zbuild.sh /zbuild.sh
COPY zbuildmonitor.py /zbuildmonitor.py
RUN chmod 777 /*.sh

# set up supervisord
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf -n"]
