FROM tverous/pytorch-notebook:latest

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

VOLUME ./.venv
ENTRYPOINT /entrypoint.sh
