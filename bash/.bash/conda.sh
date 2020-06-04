# Conda environment initalization script with some additional tweaks. Set the
# environment variable ENV_CONDA_ROOT to add conda. This script must be
# sourced.

if [ ! -z "$ENV_CONDA_ROOT" ]; then
	# See https://github.com/conda/conda/issues/5388
	export CONDA_ENVS_DIRS=$HOME/.config/conda/envs
	export CONDA_PKGS_DIRS=$HOME/.config/conda/pkgs

	# See https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#searching-for-condarc
	export CONDARC=$HOME/.config/conda/condarc

	if __conda_setup=$("$ENV_CONDA_ROOT/bin/conda" 'shell.bash' 'hook' 2> /dev/null); then
		eval "$__conda_setup"
	else
		if [ -f "$ENV_CONDA_ROOT/etc/profile.d/conda.sh" ]; then
			# shellcheck source=/dev/null
			. "$ENV_CONDA_ROOT/etc/profile.d/conda.sh"
		else
			export PATH="$ENV_CONDA_ROOT/bin:$PATH"
		fi
	fi
	unset __conda_setup
fi
