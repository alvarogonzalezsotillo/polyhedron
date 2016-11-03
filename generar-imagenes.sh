#!/bin/sh -x
SCADFILE=./view-stl.scad


fondoblanco(){
  local IMAGE=$1
  convert $IMAGE -fuzz 0%  -transparent '#fafafa' $IMAGE
}

imagenes() {
  local N=$1
  local BIG=images/poliedro-$N.png
  local SMALL=images/poliedro-$N-small.png
  local SMALLWHITE=images/poliedro-$N-small-white.png
  openscad -o $BIG --camera=0,0,525,0,0,0 --colorscheme=Nature -D STLFILE=\"stl/poliedro-$N.stl\" "$SCADFILE"
  fondoblanco $BIG
  convert -resize 128x128 $BIG $SMALL
}

for i in $(seq 4 24)
do
  imagenes $i
done

for i in $(find images/manual/*.png)
do
    fondoblanco $i
done
