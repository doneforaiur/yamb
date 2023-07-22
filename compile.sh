#! /bin/sh

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


# current entries
for file in $(ls -t ./entries/current/*.md); do
    created=$(stat -c "%y" "$file")

    basefilename="$(basename  $file)"

    title_of_entry=$(echo "$basefilename" | sed 's/\..*$//;s/_/ /g')

    echo "$title_of_entry"
    echo "<tr><td style=\"text-align: left;\">$title_of_entry</td></tr>" >> ./tmp/current_table.html

    sed -i "18r ./tmp/current_table.html" ./tmp/current.html
    rm ./tmp/current_table.html
done

# standalone entries
for file in $(ls -t ./entries/standalone/*.md); do
    basefilename="$(basename  $file)"
    basefilename=$(echo "$basefilename" | sed 's/\..*$//')

    echo "$basefilename"
    pandoc -f markdown -t html "$file" > ./tmp/bare_"${basefilename}".html
    cp ./templates/header.html ./www/"${basefilename}".html
    sed -i "50r ./tmp/bare_"${basefilename}".html" ./www/"${basefilename}".html
done

# recent and archive entries
for file in $(ls -t ./entries/recent/*.md); do
    basefilename="$(basename  $file)"

    title_of_entry=$(echo "$basefilename" | sed 's/\..*$//;s/_/ /g')

    pandoc -f markdown -t html "$file" > ./tmp/bare_"${basefilename%.*}".html
    cp ./templates/header.html ./www/entries/"${basefilename%.*}".html
    sed -i "50r ./tmp/bare_"${basefilename%.*}".html" ./www/entries/"${basefilename%.*}".html
    
    created=$(stat -c "%y" "$file")
    created=$(date -d "$created" +"%d/%m/%Y")

    echo "<tr><td style=\"text-align: left;\">$created</td>" >> ./tmp/archive_table.html
    echo "<td style=\"text-align: left;\"><a href=\"entries/${basefilename%.*}.html\">$title_of_entry</a></td></tr>" >> ./tmp/archive_table.html

    sed -i "16r ./tmp/archive_table.html" ./tmp/archive.html
    rm ./tmp/archive_table.html


    if [ "$(wc -l < ./tmp/recent.html)" -gt 60 ]; then
        continue
    fi

    echo "<tr><td style=\"text-align: left;\">$created</td>" >> ./tmp/recent_table.html
    echo "<td style=\"text-align: left;\"><a href=\"entries/${basefilename%.*}.html\">$title_of_entry</a></td></tr>" >> ./tmp/recent_table.html

    sed -i "16r ./tmp/recent_table.html" ./tmp/recent.html
    rm ./tmp/recent_table.html
done

for file in $(ls -t ./entries/soon/*.md); do
    created=$(stat -c "%y" "$file")
    created=$(date -d "$created" +"%m/%Y")

    basefilename="$(basename  $file)"
    title_of_entry=$(echo "$basefilename" | sed 's/\..*$//;s/_/ /g')

    echo "<tr><td style=\"text-align: left;\">$created</td>" >> ./tmp/soon_table.html
    echo "<td style=\"text-align: left;\">$title_of_entry</td></tr>" >> ./tmp/soon_table.html

    sed -i "19r ./tmp/soon_table.html" ./tmp/soon.html
    rm ./tmp/soon_table.html
done

cat ./tmp/recent.html ./tmp/current.html ./tmp/soon.html > ./tmp/index_body.html
sed -i "50r ./tmp/index_body.html" ./www/index.html
sed -i "50r ./tmp/archive.html" ./www/archive.html
pandoc -f markdown -t html ./templates/about.md > ./tmp/about_body.html
sed -i "50r ./tmp/about_body.html" ./www/about.html

rm -rf ./tmp