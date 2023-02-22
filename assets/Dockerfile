# Install IDE
ARG BASE_IMAGE="jupyter/scipy-notebook"
FROM ${BASE_IMAGE}

ENV WORKDIR="/home/jovyan/work"
WORKDIR ${WORKDIR}

USER root

# Copy install script.
COPY ./plugin-install.sh /usr/local/bin/before-notebook.d/

# Install plugins.
COPY ./plugins_dir /tmp/plugins/

# Setup configuration.
COPY ./combined_config.sh /tmp/config.sh
RUN sh /tmp/config.sh

# Install project-specific requirements.
COPY ./requirements.txt /home/jovyan/work/requirements.txt
RUN pip install -r /home/jovyan/work/requirements.txt
