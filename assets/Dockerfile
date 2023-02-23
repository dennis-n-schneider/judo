# Install IDE
ARG BASE_IMAGE="jupyter/scipy-notebook"
FROM ${BASE_IMAGE}

ENV WORKDIR="/home/jovyan/work"
WORKDIR ${WORKDIR}

USER root

# Copy install script.
COPY ./plugin-install.sh /usr/local/bin/before-notebook.d/

# Install active plugins.
COPY ./plugins_dir /tmp/plugins/

# Setup configuration.
COPY ./common_config.sh /tmp/common_config.sh
RUN sh /tmp/common_config.sh

# Setup project-specific configuration.
COPY ./project_config.sh /tmp/project_config.sh
RUN sh /tmp/project_config.sh

# Install project-specific requirements.
COPY ./requirements.txt /home/jovyan/work/requirements.txt
RUN pip install -r /home/jovyan/work/requirements.txt
