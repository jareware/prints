$fn = $preview ? 25 : 75;

use <clip.scad>

magic = 0.01;
distanceX = 40;
distanceY = 20;

// Sample:
difference() {
  translate([ 20, -20, 0 ])
  scale([ 1, .5, 1 ])
  cylinder(h = 2, r = 45);

  translate([ 20, -20, 0 ])
  scale([ 1, .5, 1 ])
  cylinder(h = 3, r = 35);
}
clipMatrix([
  [true, true],
  [true, false, true],
  [true, true],
]);

module clipMatrix(rowList) {
  mirror([ 0, 1, 0 ]) {
    for (y = [0 : len(rowList) - 1]) {
      for (x = [0 : len(rowList[y]) - 1]) {
        if (rowList[y][x]) {
          translate([ x * distanceX + (y % 2 == 1 ? distanceX / -2 : 0), y * distanceY, 0 ])
          clipLayer(10, 0);
        }
      }
    }
  }
}
