FROM python:3.12-slim

# update image packages &&
# install cron daemon to support in-container cron schedule
RUN apt-get update && \
    apt-get install -y cron

# add a user so the tool is encapsulated
RUN useradd -m -U -G crontab -s /bin/bash ot

# allow the user to have cron schedules
RUN touch /var/spool/cron/crontabs/ot && \
    chown ot:crontab /var/spool/cron/crontabs/ot && \
    chmod u+s /usr/sbin/cron

# install the tool onto the image
RUN pip3 install -U organize-tool

# prepare the image EntryPoint
COPY scripts/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# prepare the run script
COPY scripts/organize-run.conf /home/ot/
COPY scripts/organize-run.sh /home/ot/
RUN chown ot:ot /home/ot/organize-run.conf && \
    chown ot:ot /home/ot/organize-run.sh && \
    chmod +x /home/ot/organize-run.sh

# allow app to operate on data, source & target folders
# allow folders for config & logs
RUN mkdir -p /data   && chmod go+rw /data   && \
    mkdir -p /source && chmod go+rw /source && \
    mkdir -p /target && chmod go+rw /target && \
    mkdir -p /config && chmod go+rw /config && \
    mkdir -p /logs   && chmod go+rw /logs

# declare volumes
VOLUME /data /source /target /config /logs

# allow app to find config files on default path
ENV ORGANIZE_CONFIG=/config/config.yaml

# switch to the user
USER ot
WORKDIR /home/ot

ENTRYPOINT ["/entrypoint.sh"]
