$fn = $preview ? 35 : 75;

use <mountPlate.scad>
use <../lib/roundedCube.scad>

magic = 0.01;
mainZ = 15;
mainWidth = 20;
mainHeight = 70;
mountRounding = 4;
screwD = 10; // screw chute diameter
anchorHeadD = 22;
anchorHeadH = 2;
topWasherD = 22;
topWasherH = 5;

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

    // Top washer movement space:
    translate([ 0, 0, mainZ - topWasherH + magic ])
    scale([ 2, 1, 1 ])
    cylinder(d = topWasherD, h = topWasherH);

    // Bottom anchor head space:
    translate([ 0, 0, -magic ])
    scale([ 2, 1, 1 ])
    cylinder(d = anchorHeadD, h = anchorHeadH);
  }
}
