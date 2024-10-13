$fn = $preview ? 50 : 100;

use <../lib/roundedCube.scad>

mainThickness = 5;
mainR = mainThickness * .75;
railY = 15;
railZ = 22;
mainX = 12; // this is effectively the "rail top clearance", the thing needs to fit between the ceiling & the rail, sideways, before rotating into place

armThickness = 10;
armReachOut = 25;
armReachOutSupport = 8;
armReachUp = 30;
armReachUpSupport = 6;
hookD = 6;
hookZ = -2.3;

difference() {
  union() {
    // Rail grabber main body:
    roundedCube(mainX, railY + mainThickness * 2, railZ + mainThickness, r = mainR);

    // Arm reaching out:
    hull() {
      translate([ 0, -armReachOut - armThickness, railZ + mainThickness - armThickness ])
      roundedCube(mainX, armReachOut + armThickness, armThickness, r = mainR);

      translate([ 0, -0, railZ + mainThickness - armThickness - armReachOutSupport ])
      roundedCube(mainX, railY + mainThickness * 2, armThickness + armReachOutSupport, r = mainR);
    }

    // Arm reaching up:
    translate([ 0, -armReachOut - armThickness, railZ + mainThickness - armThickness ])
    roundedCube(mainX, armThickness, armThickness + armReachUp, r = mainR);

    // Up reaching arm support:
    hull() {
      translate([ 0, -armReachOut - armThickness, railZ + mainThickness - armThickness ])
      roundedCube(mainX, armThickness, armThickness + armReachUpSupport, r = mainR);

      translate([ 0, -armReachOut - armThickness, railZ + mainThickness - armThickness ])
      roundedCube(mainX, armThickness + armReachUpSupport, armThickness, r = mainR);
    }
  }

  // Cut out space for the rail:
  translate([ 0, mainThickness, 0 ])
  #cube([ mainX, railY, railZ ]);

  // Hook that holds onto the wire:
  translate([ 0, -armReachOut - armThickness / 2, railZ + mainThickness + armReachUp + hookZ ])
  rotate([ 0, 90, 0 ])
  #cylinder(h = mainX, d = hookD);
}
