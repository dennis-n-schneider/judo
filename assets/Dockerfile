# Install IDE
ARG BASE_IMAGE="jupyter/scipy-notebook"
FROM ${BASE_IMAGE}

ENV WORKDIR="/home/jovyan/work"
WORKDIR ${WORKDIR}

USER root

# Copy install script.
COPY ./plugin-install.sh /usr/local/bin/before-notebook.d/

# Setup configuration.
COPY ./combined_config.sh /tmp/config.sh

# Install plugins.
COPY ./plugins_dir /tmp/plugins/

RUN sh /tmp/config.sh
