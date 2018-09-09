hash_list="$1/hashes.txt"
filterd_list="$1/filtered.txt"
duplicated_list="$1/duplicates.txt"

find "$1"  -type f -exec md5 -r '{}' ';' | sort -k 1 > "$hash_list"
< "$hash_list" cut -d " " -f 1 | uniq -d > "$filterd_list"
while read -r -u 4 hash
do
  echo "Duplicated hash:" $hash
  grep $hash "$hash_list" | cut -d " " -f 2- | tail -n +2 > "$duplicated_list"
  while read -r -u 3 file
  do
    echo "$file"
    read -p "Are you sure? [y/n]" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        rm "$file"
        echo "deleting ..."
    fi
  done 3< "$duplicated_list"
  echo ""
done 4< "$filterd_list"

rm "$hash_list"
rm "$filterd_list"
rm "$duplicated_list"
