FROM jupyter/scipy-notebook

WORKDIR /home/jovyan/work

# Install static project requirements.
COPY requirements.txt .
RUN pip install -r requirements.txt

