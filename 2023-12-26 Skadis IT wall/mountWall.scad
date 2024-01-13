$fn = $preview ? 35 : 75;

use <mountPlate.scad>
use <../lib/roundedCube.scad>

magic = 0.01;
mainZ = 15;
mainWidth = 20;
mainHeight = 70;
mountRounding = 4;
screwD = 4; // screw diameter
screwH = 8; // thickness between wall & screw
screwAccessD = 10; // large enough for screwdriver head

// Sample:
mountWall();

// Printed as "Skadis IT wall - Wall mount"

module mountWall() {
  difference() {
    mountPlate(
      width = mainWidth,
      height = mainHeight,
      thickness = mainZ,
      offsetX = mainWidth / 2 - 3.5, // these magic values work for centering a single row
      offsetY = (mainHeight - 55) / 2, // ^ ditto
      clipRowsCols = [
        [true],
        [false],
        [true],
      ]
    );

    // Screw hole:
    translate([ 0, 0, -magic ])
    cylinder(d = screwD, h = mainZ + magic * 2);

    // Access hole:
    translate([ 0, 0, screwH ])
    cylinder(d = screwAccessD, h = mainZ);
  }
}
