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

## Configuration

In order to minimize the size of multiple Docker images, packages a Developer always needs and differ from the base image installs, can be added to a user-specific config-file.
For example, to add the torch library to all images built by a certain user, add the following line to the config-file in `~/.config/judo/config.sh`. Note that this file might need to be created if not already present.
```shell
pip install torch
```

Since this is a common shell-script, arbitrary commands and configurations of the jupyter environment can be defined here. See the following example, activating dark mode by default:
```shell
mkdir -p /opt/conda/share/jupyter/lab/settings
echo '''
{
    "@jupyterlab/apputils-extension:themes": {
        "theme": "JupyterLab Dark"    
    }
}
''' > /opt/conda/share/jupyter/lab/settings/overrides.json
```

### Plugin Installation and Usage
Plugins can be added to further benefit from the judo-environment.
To find a list of installed plugins and plugins used in the current judo-project, run `judo plugins list`. \
Plugins can be installed via the following command:
```shell
# Install from github-repository
judo plugins install dennisschneider-ml/judo-datasets
# Install from local directory
cd <plugin-directory>
judo plugins install
```
In order to use a plugin, it either can be added to `~/.config/judo/plugins`, or in the local config of your project in `<project-directory>/.judo/plugins`.

#### Available Plugins

[judo-datasets](https://github.com/dennisschneider-ml/judo-datasets): Add a reproducible way to preprocess datasets.
