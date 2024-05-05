$fn = $preview ? 35 : 75;

use <../lib/screwHole.scad>

tipThickness = 10;
mainLen = 70;
floorThick = 12;
wallRaise = 15;
slopeBy = 30;
supportExtrudeX = 33.5;
supportExtrudeY = 44;

difference() {
  hull() {
    translate([ tipThickness / 2, tipThickness / 2, 0 ])
    sphere(d = tipThickness);
    translate([ tipThickness / 2, tipThickness / 2, floorThick + wallRaise ])
    sphere(d = tipThickness);

    translate([ tipThickness / 2, mainLen - tipThickness / 2, 0 ])
    sphere(d = tipThickness);
    translate([ tipThickness / 2, mainLen - tipThickness / 2, floorThick + slopeBy + wallRaise ])
    sphere(d = tipThickness);

    translate([ supportExtrudeX, supportExtrudeY, 0 ])
    sphere(d = tipThickness);
  }

  translate([ 0, 0, 18 / -2 ])
  cube([ 200, 200, 18 ], center = true);

  translate([ 7, 12, -16 ]) screwHole("4.0 x 40 pan head countersunk");
  translate([ 7, mainLen - 12, -16 ]) screwHole("4.0 x 40 pan head countersunk");
  translate([ supportExtrudeX - 5, supportExtrudeY - 2, -15 ]) screwHole("3.5 x 20 countersunk");
}
