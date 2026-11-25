if [[ -x /usr/libexec/java_home ]]; then
    java_home="$(/usr/libexec/java_home -v 17 2>/dev/null)" && export JAVA_HOME="$java_home"
fi
unset java_home

export ANDROID_HOME="$HOME/Library/Android/sdk"
export KUBECONFIG="$HOME/.kube/config"
