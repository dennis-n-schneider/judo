FROM ubuntu:20.04

WORKDIR /project

COPY boot /

RUN apt-get update -y && apt-get install -y python3 python3-pip && \
    pip3 install \
	    numpy \
	    pandas \
	    matplotlib \
	    torch \
	    torchvision \
            jupyterlab && \
    pip install pytorch-lightning && \
    chmod +x /entrypoint.sh

CMD /entrypoint.sh && jupyter-lab --ip=0.0.0.0 --no-browser --allow-root
