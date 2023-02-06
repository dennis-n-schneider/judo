# judo

**Ju**pyter in a **Do**cker-Container!

A small shell utility to provide an isolated Jupyter-Lab runtime for isolated, reproducible development keeping the host-machine uncluttered.
The result is a minimal Docker-image which can be used out of the box while enabling maximum productivity by initializing a gitignore-file suitable for Jupyter Lab and preinstalling any requirements listed in `requirements.txt`.

## Installation

Clone this git-repository and run the following command:
```shell
sudo make
```

## Uninstallation

Run the following command:
```shell
sudo make uninstall
```

## Usage

In order to start an isolated Jupyter-Lab session in a certain directory, simply run the following command.
```shell
judo init
```
Requirements listed in `requirements.txt` will automatically be installed in the container. \
After initializing a git-repository and the Docker environment, the environment can be run.
```shell
judo run
```

Available commands and configuration options can be viewed by:
```shell
judo help
```

### Extensions

[judo-datasets](https://github.com/dennisschneider-ml/judo-datasets): Add a reproducible way to preprocess datasets.
