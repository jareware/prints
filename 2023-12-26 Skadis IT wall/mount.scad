$fn = $preview ? 25 : 75;

use <clip.scad>

magic = 0.01;
clipX = 3.5; // so that offsetX of 0 ends up in top left corner
clipY = -7.5; // ditto for Y
clipDistanceX = 40;
clipDistanceY = 20;
mountRounding = 4;

// Sample:
mount(
  width = 50,
  height = 38,
  offsetX = 1.5,
  offsetY = 1.5,
  clipRowsCols = [
    [true, true],
    [false, true],
  ]
);

module mount(width = 40, height = 20, thickness = 2, offsetX = 0, offsetY = 0, clipRowsCols = [[true]]) {
  mountPlate(width, height, thickness);
  translate([ width / -2 + offsetX + clipX, height / 2 - offsetY + clipY, thickness ])
  mountClips(clipRowsCols);
}

module mountPlate(width, height, thickness) {
  hull() {
    translate([ (width - mountRounding * 2) / -2, (height - mountRounding * 2) / -2, 0 ])
    cylinder(r = mountRounding, h = thickness);
    translate([ (width - mountRounding * 2) / 2, (height - mountRounding * 2) / 2, 0 ])
    cylinder(r = mountRounding, h = thickness);
    translate([ (width - mountRounding * 2) / -2, (height - mountRounding * 2) / 2, 0 ])
    cylinder(r = mountRounding, h = thickness);
    translate([ (width - mountRounding * 2) / 2, (height - mountRounding * 2) / -2, 0 ])
    cylinder(r = mountRounding, h = thickness);
  }
}

module mountClips(clipRowsCols) {
  color("Chocolate") // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#color
  mirror([ 0, 1, 0 ]) {
    for (y = [0 : len(clipRowsCols) - 1]) {
      for (x = [0 : len(clipRowsCols[y]) - 1]) {
        if (clipRowsCols[y][x]) {
          translate([ x * clipDistanceX + (y % 2 == 1 ? clipDistanceX / -2 : 0), y * clipDistanceY, 0 ])
          clip();
        }
      }
    }
  }
}
