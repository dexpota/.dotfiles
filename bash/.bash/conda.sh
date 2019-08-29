CONDA_ROOT=$HOME/miniconda3

__conda_setup=$("$CONDA_ROOT/bin/conda" 'shell.bash' 'hook' 2> /dev/null)
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
        . "$CONDA_ROOT/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_ROOT/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
