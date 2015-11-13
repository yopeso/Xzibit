#sh create.sh Beta Arial red blue
removeTemp() {
/usr/local/bin/convert -page +$move-$move \
$1.png \
-background none \
-flatten \
$2.png
rm $1.png
}


createTemp() {
move=$((185*$6/1024))
/usr/local/bin/convert -background transparent \
-undercolor $4 \
-fill $5 \
-font /Library/Fonts/"$3".ttf \
-size $6x$6 \
-rotate 45 \
-pointsize $7 \
-gravity North \
label:"$1" \
.fileName.png
removeTemp .fileName "$2" move
}

createFinal() {
pointsize=$((200 * $5 / 1024))
createTemp "                            " .ribbon $2 $3 transparent $5 $pointsize
createTemp "$1" .labelText $2 transparent $4 $5 $pointsize

/usr/local/bin/convert  .ribbon.png .labelText.png \
-gravity center   -composite   .watermark.png
rm .labelText.png
rm .ribbon.png
}


resize() {
/usr/local/bin/convert icon180.png -scale $1x$1 icon$1.png
}
mkdir "$6/AppIcon-$2.appiconset"
cd "$6/AppIcon-$2.appiconset/"

createFinal $2 $3 $4 $5 125

/usr/local/bin/convert "$1" -scale 180x180 .resized.png

/usr/local/bin/convert  .resized.png .watermark.png \
-gravity center   -composite   icon180.png
rm .resized.png
rm .watermark.png
resize 152
resize 120
resize 87
resize 80
resize 76
resize 58
resize 40
resize 29
