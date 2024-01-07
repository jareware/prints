$fn = $preview ? 15 : 50;

use <../lib/roundedCube.scad>

magic = 0.01;
clipX = 5 - .3;
clipY = 15 - .3;
clipH1 = 5.3; // i.e. IKEA Skådis plate thickness
clipH2 = 8; // i.e. height above plate
clipHoleD = clipX;
clipHoleRaise = 2;
clipTolerance = .5;
clipPinLength = clipY;
pinRightFinY = clipHoleD * .75;

// Sample:
translate([ 8 / -2, 18 / -2, -3 ])
cube([ 8, 18, 3 ]);
clipPinned();
translate([ 15, 0, -clipH1 - clipTolerance - 3 ])
rotate([ 0, 0, 90 ])
clipPinnedPin();

module clipPinned() {
  difference() {
    roundedCube(clipX, clipY, clipH1 + clipH2, centerX = true, centerY = true, r = clipX / 2, flatBottom = true);

    translate([ clipPinLength / -2, 0, clipH1 + clipHoleRaise ])
    rotate([ 0, 90, 0 ])
    cylinder(h = clipPinLength, d = clipHoleD + clipTolerance);
  }

  if ($preview)
  #translate([ clipX / -2, clipY / -2, 0 ])
  cube([ clipX, clipY, clipH1 + clipTolerance ]);
}

module clipPinnedPin() {
  difference() {
    union() {
      translate([ clipPinLength / -2 + clipHoleD / 2, 0, clipH1 + clipHoleRaise ])
      rotate([ 0, 90, 0 ])
      cylinder(h = clipPinLength - clipHoleD / 2, d = clipHoleD);

      translate([ clipPinLength / -2 + clipHoleD / 2, 0, clipH1 + clipHoleRaise ])
      sphere(d = clipHoleD);

      translate([ clipX / 2  + clipTolerance, 0, clipH1 + clipTolerance ])
      roundedCube(
        (clipPinLength - clipX) / 2 - clipTolerance,
        pinRightFinY,
        clipH2 - clipTolerance,
        centerY = true,
        r = pinRightFinY / 2,
        flatRight = true
      );
    }

    translate([ clipPinLength / -2, clipY / -2, 0 ])
    cube([ clipPinLength, clipY, clipH1 + clipTolerance ]);
  }

  if ($preview)
  #roundedCube(clipX, clipY, clipH1 + clipH2, centerX = true, centerY = true);
}
