#sh create.sh ~/Desktop/AppIcon.png Release Red Blue .

createFolders() {
mkdir "$1/AppIcon-$2.appiconset"
cd "$1/AppIcon-$2.appiconset/"
}

resizeImage() {
/usr/local/bin/convert $1 -scale $2x$2 $3.png
}

resizeIcon() {
resizeImage icon180.png $1 icon$1
}

createSmallIcons() {
resizeIcon 152
resizeIcon 120
resizeIcon 87
resizeIcon 80
resizeIcon 76
resizeIcon 58
resizeIcon 40
resizeIcon 29
}

createTemp() {
/usr/local/bin/convert -background transparent -undercolor $3 -fill $4 -font /Library/Fonts/Arial.ttf -size 125x125 -rotate 45 -pointsize 20 -gravity North label:"$1" .fileName.png
/usr/local/bin/convert -page +22-17 .fileName.png -background none -flatten $2.png
rm .fileName.png
}

combine() {
/usr/local/bin/convert  $1.png $2.png -gravity center   -composite   $3.png
rm $1.png
rm $2.png
}

createWatermark() {
createTemp "                                                         " .ribbon $2 transparent
createTemp "$1" .labelText transparent $3
combine .ribbon .labelText .watermark
}

createFolders $5 $2
createWatermark $2 $3 $4
resizeImage $1 180 .resized
combine .resized .watermark icon180
createSmallIcons
