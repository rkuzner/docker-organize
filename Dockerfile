FROM python:3.12-slim

# add a user so the tool is encapsulated
RUN useradd -ms /bin/bash ot

# update image packages
RUN apt-get update

# install cron daemon to support in-container cron schedule
RUN apt-get install cron -y

# allow the user to have cron schedules
RUN touch /var/spool/cron/crontabs/ot

# install the tool onto the image
RUN pip3 install -U organize-tool

# prepare the image EntryPoint
COPY scripts/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# switch to the user
USER ot
WORKDIR /home/ot

ENTRYPOINT ["/entrypoint.sh"]
