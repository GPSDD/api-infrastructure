FROM ubuntu:latest

RUN apt-get update && apt-get -y install gnupg curl

# Install MongoDB Tools
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list

RUN apt-get update && apt-get -y install curl \
    openssh-client \
    apt-transport-https \
    cron \
    mongodb-org \
    python-setuptools \
    python-dev \
    build-essential

# pip
RUN apt-get -y install python-pip
RUN python2.7 -m pip install -U setuptools
RUN pip install requests
# Install AWS
RUN pip install awscli --upgrade --user

# Cron
RUN mkdir /cronjobs && mkdir /cronjobs/backups
COPY cronjobs.sh /cronjobs/cronjobs.sh

# Backups
RUN mkdir /cronjobs/backups/mongo
COPY automongobackup.sh /cronjobs/automongobackup.sh
COPY autoelasticbackup.sh /cronjobs/autoelasticbackup.sh

COPY entrypoint.sh /cronjobs/entrypoint.sh
WORKDIR /cronjobs

# Run the command on container startup
ENTRYPOINT ["./entrypoint.sh"]
