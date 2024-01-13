$fn = $preview ? 35 : 75;

use <clipPinned.scad>
use <../lib/roundedCube.scad>

magic = 0.01;
mainZ = 15;
mainD1 = 20;
mainD2 = 15;
mainSkew = 14;
screwD = 5; // large enough for screwdriver head
screwH = 4; // thickness between wall & screw
screwAccessD = 10; // large enough for screwdriver head

// Sample:
mountWall();

module mountWall() {
  difference() {
    union() {
      translate([ 0, mainSkew, mainZ ])
      clipPinned();

      hull() {
        cylinder(d = mainD1, h = mainZ / 2);

        translate([ 0, mainSkew, 0 ])
        cylinder(d = mainD1, h = mainZ);
      }
    }

    translate([ 0, 0, -magic ])
    cylinder(d = screwD, h = mainZ + magic);

    translate([ 0, 0, screwH ])
    cylinder(d = screwAccessD, h = mainZ + magic);
  }
}
