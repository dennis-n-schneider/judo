# ml-kickstarter
A small Docker Image which runs jupyter-notebook and any needed packages inside a Docker-Container and installs packages to a venv.

This results in an uncluttered work-station which installs large packages like Python and PyTorch once (within the Docker-Image) while being able to keep isolated working environments within each project by installing them locally within the venv.

The token of the Jupyter-Notebook Session is preset to "Hello", which should be changed in `docker-compose.yml`.

In order to start an isolated Jupyter-Notebook session in a certain directory, copy the file `docker-compose.yml` into the root-directory and run `docker-compose up`.

