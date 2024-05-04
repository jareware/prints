$fn = $preview ? 35 : 75;

tipThickness = 5;
midThickness = 11.5;
railGap = 4;
bottomWiden = 0;
mainLen = 75;
floorThick = 16;
midRaise = floorThick + 15;
slopeBy = 44 - floorThick;

difference() {
  union() {
    hull() {
      translate([ 0, 0, midThickness / 2 + tipThickness / 2 ])
      sphere(d = midThickness);

      translate([ 0, 0, midRaise - (midThickness / 2) ])
      sphere(d = midThickness);

      translate([ 0, mainLen, 0 ]) {
        translate([ 0, 0, midThickness / 2 + tipThickness / 2 ])
        sphere(d = midThickness);

        translate([ 0, 0, midRaise - (midThickness / 2) + slopeBy ])
        sphere(d = midThickness);
      }
    }

    for (i = [1, -1])
    translate([ (midThickness / -2 + tipThickness / -2 - railGap) * i, 0, 0 ])
    hull() {
      translate([ 0, 0, tipThickness / 2 ])
      sphere(d = tipThickness);

      translate([ 0, 0, midRaise - (tipThickness / 2) ])
      sphere(d = tipThickness);

      translate([ bottomWiden * -i, 0, tipThickness / 2 ])
      sphere(d = tipThickness);

      translate([ 0, mainLen, 0 ]) {
        translate([ 0, 0, tipThickness / 2 ])
        sphere(d = tipThickness);

        translate([ 0, 0, midRaise - (tipThickness / 2) + slopeBy ])
        sphere(d = tipThickness);

        translate([ bottomWiden * -i, 0, tipThickness / 2 ])
        sphere(d = tipThickness);
      }
    }

    cylH = midThickness / 2 + railGap + tipThickness / 2;
    hull() {
      translate([ -cylH, 0, tipThickness / 2 ])
      rotate([ 0, 90, 0 ])
      cylinder(h = cylH * 2, d = tipThickness);

      translate([ -cylH, mainLen, tipThickness / 2 ])
      rotate([ 0, 90, 0 ])
      cylinder(h = cylH * 2, d = tipThickness);

      translate([ -cylH, 0, tipThickness / 2 + (floorThick - tipThickness) ])
      rotate([ 0, 90, 0 ])
      cylinder(h = cylH * 2, d = tipThickness);

      translate([ -cylH, mainLen, tipThickness / 2 + (floorThick - tipThickness) + slopeBy ])
      rotate([ 0, 90, 0 ])
      cylinder(h = cylH * 2, d = tipThickness);
    }
  }

  translate([ 0, -25 - tipThickness / 2, 50 ])
  cube([ 50, 50, 100 ], center = true);

  translate([ 0, 25 + tipThickness / 2 + mainLen, 50 ])
  cube([ 50, 50, 100 ], center = true);

  // For test prints:
  translate([ 0, mainLen / 2, 50 + 4 ])
  cube([ 70, mainLen - 2, 100 ], center = true);
  translate([ 0, mainLen / 2, 50 - 5 ])
  cube([ midThickness + railGap + bottomWiden * 2, mainLen - 8, 100 ], center = true);
}
