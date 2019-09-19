
remote=$(git remote get-url --all origin)

url=$(echo "$remote" | sed -rn "s/.*:(.*)\.git/https:\/\/github.com\/\1/p")

xdg-open "$url"
