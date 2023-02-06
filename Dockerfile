FROM jupyter/scipy-notebook

WORKDIR /home/jovyan/work

# Install project-specific requirements.
COPY requirements.txt .
RUN pip install -r requirements.txt

