#!/bin/bash

# install and start venv
apt-get install -y python3-venv
python -m venv .venv
source .venv/bin/activate

# add venv to jupyter notebook
pip install -y ipykernel
python -m ipykernel install --name=.venv

# install requirements locally
pip install -r requirements.txt

# start jupyter notebook
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --no-browser
