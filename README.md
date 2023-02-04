# jupy
A small shell utility to provide an isolated Jupyter-Lab runtime for isolated, reproducable development keeping the host-machine uncluttered.
The result is a minimal Docker-image which can be used out of the box while enabling maximum productivity by initializing a gitignore-file suitable for Jupyter Lab and preinstalling any requirements listed in `requirements.txt`.

## Installation

Clone this git-repository and run the following command:
```
sudo make install
```

## Uninstallation

Run the following command:
```
sudo make uninstall
```

## Usage

In order to start an isolated Jupyter-Lab session in a certain directory, simply run the following command.
```
jupy init
```
Requirements listed in `requirements.txt` will automatically be installed in the container. \
After initializing a git-repository and the Docker environment, the environment can be run.
```
jupy run
```

Available commands and configuration options can be viewed by:
```
jupy help
```
