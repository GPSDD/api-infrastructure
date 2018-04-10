FROM ubuntu:latest

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

# Cron
RUN mkdir /cronjobs && mkdir /cronjobs/backups
COPY cronjobs.sh /cronjobs/cronjobs.sh

# pip
RUN easy_install pip && pip install --upgrade pip
RUN pip install requests
# Install AWS
RUN pip install awscli --upgrade --user

# Backups
RUN mkdir /cronjobs/backups/mongo
COPY automongobackup.sh /cronjobs/automongobackup.sh
COPY autoelasticbackup.sh /cronjobs/autoelasticbackup.sh

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

COPY entrypoint.sh /cronjobs/entrypoint.sh
WORKDIR /cronjobs
ENV PATH /root/.local/bin:$PATH

# Run the command on container startup
ENTRYPOINT ["./entrypoint.sh"]
