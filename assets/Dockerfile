# Install IDE
ARG BASE_IMAGE="jupyter/scipy-notebook"
FROM ${BASE_IMAGE}

ENV WORKDIR="/home/jovyan/work"
WORKDIR ${WORKDIR}

USER root

# Install developer plugins
COPY ./plugin-install.sh /usr/local/share/judo/
COPY ./setup-config.sh /usr/local/share/judo/
COPY ./developer-plugins/ /tmp/developer-plugins/

# Setup developer configuration
COPY ./developer-config.sh /tmp/developer-config.sh

# Install project plugins
COPY ./plugins/ /tmp/project-plugins/

# Setup project configuration
COPY ./config.sh /tmp/project-config.sh

RUN . /usr/local/share/judo/plugin-install.sh && . /usr/local/share/judo/setup-config.sh

# USER jovyan
