#! /bin/bash

rm -rf ./www/* > /dev/null 2>&1

mkdir -p ./www/entries
mkdir -p ./www/media
mkdir -p ./tmp
cp ./entries/media/* ./www//media/

cp ./templates/current.html ./tmp/current.html
cp ./templates/recent.html ./tmp/recent.html
cp ./templates/soon.html ./tmp/soon.html
cp ./templates/archive.html ./tmp/archive.html
cp ./templates/header.html ./www/index.html
cp ./templates/header.html ./www/about.html
cp ./templates/header.html ./www/archive.html

cp ./styles/style.css ./www/style.css
cp ./styles/fonts/* ./www/

tmp_file=$(mktemp)
awk -v RS='\r?\n' 'FNR==1 {print $0 ":" FILENAME}' ./entries/current/* > "$tmp_file"
sorted_tmp_file=$(sort -t '/' -k 3,3 -k 2,2 -k 1,1 "$tmp_file")

# current entries
while IFS=':' read -r entry_date file; do
    basefilename="$(basename  $file)"

    title_of_entry=$(echo "$basefilename" | sed 's/\..*$//;s/_/ /g')

    echo "<tr><td style=\"text-align: left;\">$entry_date</td><td style=\"text-align: left;\">$title_of_entry</td></tr>" >> ./tmp/current_table.html

    insert_line=$(( $(grep -n "auto-generate-marker" ./tmp/current.html | cut -f1 -d: | head -1)))

    sed -i -e "${insert_line}r ./tmp/current_table.html" "./tmp/current.html"
    rm ./tmp/current_table.html
done <<< "$sorted_tmp_file"

# standalone entries
for file in $(ls -t ./entries/standalone/*.md); do
    basefilename="$(basename  $file)"
    basefilename=$(echo "$basefilename" | sed 's/\..*$//')

    pandoc -f markdown -t html "$file" > "./tmp/bare_${basefilename}.html"
    cp "./templates/header.html" "./www/${basefilename}.html"

    insert_line=$(( $(grep -n "auto-generate-marker" ./www/"${basefilename}".html | cut -f1 -d: | head -1) ))

    sed -i -e "${insert_line}r ./tmp/bare_${basefilename}.html" ./www/${basefilename}.html 
done

awk -v RS='\r?\n' 'FNR==1 {print $0 ":" FILENAME}' ./entries/recent/* > "$tmp_file"
sorted_tmp_file=$(sort -t '/' -k 3,3 -k 2,2 -k 1,1 "$tmp_file")

# recent and archive entries
index=0
while IFS=':' read -r entry_date file; do
    basefilename="$(basename  $file)"

    title_of_entry=$(echo "$basefilename" | sed 's/\..*$//;s/_/ /g')

    pandoc -f markdown -t html "$file" > ./tmp/bare_"${basefilename%.*}".html
    cp ./templates/header.html ./www/entries/"${basefilename%.*}".html

    insert_line=$(( $(grep -n "auto-generate-marker" ./www/entries/"${basefilename%.*}".html | cut -f1 -d: | head -1) ))
    sed -i -e "${insert_line}r ./tmp/bare_${basefilename%.*}.html" "./www/entries/${basefilename%.*}.html"

    echo "<tr><td style=\"text-align: left;\">$entry_date</td><td style=\"text-align: left;\"><a href=\"entries/${basefilename%.*}.html\">$title_of_entry</a></td></tr>" >> ./tmp/archive_table.html

    insert_line=$(( $(grep -n "auto-generate-marker" ./tmp/archive.html | cut -f1 -d: | head -1) ))

    sed -i "${insert_line}r ./tmp/archive_table.html" ./tmp/archive.html
    rm ./tmp/archive_table.html

    # current entries count check
    if [ $index -gt 9 ]; then
        continue
    fi

    echo "<tr><td style=\"text-align: left;\">$entry_date</td><td style=\"text-align: left;\"><a href=\"entries/${basefilename%.*}.html\">$title_of_entry</a></td></tr>" >> ./tmp/recent_table.html

    insert_line=$(( $(grep -n "auto-generate-marker" ./tmp/recent.html | cut -f1 -d: | head -1) ))
    sed -i "${insert_line}r ./tmp/recent_table.html" "./tmp/recent.html"

    rm ./tmp/recent_table.html

    index=$((index+1))
done <<< "$sorted_tmp_file"

awk -v RS='\r?\n' 'FNR==1 {print $0 ":" FILENAME}' ./entries/soon/* > "$tmp_file"
sorted_tmp_file=$(sort -r -t ':' -k1 "$tmp_file")

while IFS=':' read -r entry_date file; do
    basefilename="$(basename  $file)"
    title_of_entry=$(echo "$basefilename" | sed 's/\..*$//;s/_/ /g')

    echo "<tr><td style=\"text-align: left;\">$entry_date</td><td style=\"text-align: left;\">$title_of_entry</td></tr>" >> ./tmp/soon_table.html

    insert_line=$(($(grep -n "auto-generate-marker" ./tmp/soon.html | cut -f1 -d: | head -1 )))
    sed -i "${insert_line}r ./tmp/soon_table.html" ./tmp/soon.html

    rm ./tmp/soon_table.html
done <<< "$sorted_tmp_file"

cat ./tmp/recent.html ./tmp/current.html ./tmp/soon.html > ./tmp/index_body.html
insert_line=$(($(grep -n "auto-generate-marker" ./www/index.html | cut -f1 -d: | head -1 )))

sed -i "${insert_line}r ./tmp/index_body.html" ./www/index.html
sed -i "${insert_line}r ./tmp/archive.html" ./www/archive.html
pandoc -f markdown -t html ./templates/about.md > ./tmp/about_body.html
sed -i "${insert_line}r ./tmp/about_body.html" ./www/about.html

rm -rf ./tmp
rm "$tmp_file"