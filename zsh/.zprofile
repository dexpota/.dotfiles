eval "$(/opt/homebrew/bin/brew shellenv)"

# Setting PATH for Python 3.11
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"
export PATH
export PATH="$HOME/.local/share/mise/shims:$PATH"


# Added by Toolbox App
export PATH="$PATH:/Users/fabrizio/Library/Application Support/JetBrains/Toolbox/scripts"
