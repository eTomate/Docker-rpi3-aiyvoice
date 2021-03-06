FROM uptospace/rpi3-python:3.6.5

# Set our working directory
WORKDIR /usr/app

# Clone the voicekit repo and copy sources
RUN git clone -b voicekit --single-branch https://github.com/google/aiyprojects-raspbian.git AIY-projects-python

WORKDIR /usr/app/AIY-projects-python/scripts

RUN sudo ./install-services.sh %%RESIN_MACHINE_NAME%%

RUN sudo ./install-alsa-config.sh %%RESIN_MACHINE_NAME%%

WORKDIR /usr/app/

# Cleanup
RUN cp -r /usr/app/AIY-projects-python/src /usr/app/ && \
    cp -r /usr/app/AIY-projects-python/checkpoints /usr/app/src/checkpoints && \
    rm -rf /usr/app/AIY-projects-python

# Copy requirements.txt first for better cache on later pushes
COPY ./requirements.txt /requirements.txt

# This will copy all files in our root to the working  directory in the container
COPY . ./

# switch on systemd init system in container
ENV INITSYSTEM on

# Install Requirements
RUN sudo apt-get -y install alsa-base alsa-utils rsync libttspico-utils ntpdate

# pip install python deps from requirements.txt on the resin.io build server
RUN pip install -r /requirements.txt

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]