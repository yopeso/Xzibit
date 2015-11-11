#sh create.sh Beta Arial red blue 150
removeTemp() {
  convert -page +$move-$move \
          $1.png \
          -background none \
          -flatten \
          $2.png
  rm $1.png
}


createTemp() {
  move=$((185*$6/1024))
  convert -background transparent \
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
  pointsize=$((150 * $5 / 1024))
  createTemp "                            " .ribbon $2 $3 transparent $5 $pointsize
  createTemp "$1" .labelText $2 transparent $4 $5 $pointsize

  convert  .ribbon.png .labelText.png \
           -gravity center   -composite   ~/Desktop/$1.png
  rm .labelText.png
  rm .ribbon.png

}

createFinal $1 $2 $3 $4 $5
