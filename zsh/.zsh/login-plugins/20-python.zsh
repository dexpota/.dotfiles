python_bin="/Library/Frameworks/Python.framework/Versions/3.11/bin"
if [[ -d "$python_bin" ]]; then
    path=("$python_bin" $path)
fi
unset python_bin
