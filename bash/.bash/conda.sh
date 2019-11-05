# Conda environment initalization script with some additional tweaks. Set the
# environment variable ENV_CONDA_ROOT to add conda. This script must be
# sourced.

if [ ! -z "$ENV_CONDA_ROOT" ]; then
	alias conda-activate='eval $("$ENV_CONDA_ROOT/bin/conda" shell.bash activate)'
	alias conda-deactivate='eval $("$ENV_CONDA_ROOT/bin/conda" shell.bash deactivate)'
fi
