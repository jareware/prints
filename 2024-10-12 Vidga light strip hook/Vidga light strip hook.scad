$fn = $preview ? 50 : 100;

use <../lib/roundedCube.scad>

magic = 0.01;
mainThickness = 5;
mainR = mainThickness * .75;
railY = 15;
railZ = 22;
mainX = 12; // this is effectively the "rail top clearance", the thing needs to fit between the ceiling & the rail, sideways, before rotating into place
backBumpY = 7;
backBumpZ = 15;

armThickness = 10;
armReachOut = 25;
armReachOutSupport = 8;
armReachUp = 30;
armReachUpSupport = 6;
hookD = 5;
hookZ = -2.5;

fastenerX = 34;
fastenerTopThickness = 10;
fastenerTolerance = .75;

// Main:
difference() {
  union() {
    // Rail grabber main body:
    roundedCube(mainX, railY + mainThickness * 2, railZ + mainThickness, r = mainR, centerX = true);

    // Rail grabber back bump (connects with fastener):
    translate([ 0, railY + mainThickness, railZ + mainThickness - backBumpZ ])
    roundedCube(mainX, backBumpY + mainThickness, backBumpZ, r = mainR, flatFront = true, centerX = true);

    // Arm reaching out:
    hull() {
      translate([ 0, -armReachOut - armThickness, railZ + mainThickness - armThickness ])
      roundedCube(mainX, armReachOut + armThickness, armThickness, r = mainR, centerX = true);

      translate([ 0, -0, railZ + mainThickness - armThickness - armReachOutSupport ])
      roundedCube(mainX, railY + mainThickness * 2, armThickness + armReachOutSupport, r = mainR, centerX = true);
    }

    // Arm reaching up:
    translate([ 0, -armReachOut - armThickness, railZ + mainThickness - armThickness ])
    roundedCube(mainX, armThickness, armThickness + armReachUp, r = mainR, centerX = true);

    // Up reaching arm support:
    hull() {
      translate([ 0, -armReachOut - armThickness, railZ + mainThickness - armThickness ])
      roundedCube(mainX, armThickness, armThickness + armReachUpSupport, r = mainR, centerX = true);

      translate([ 0, -armReachOut - armThickness, railZ + mainThickness - armThickness ])
      roundedCube(mainX, armThickness + armReachUpSupport, armThickness, r = mainR, centerX = true);
    }
  }

  // Cut out space for the rail:
  translate([ -magic - mainX / 2, mainThickness, 0 ])
  cube([ mainX + magic * 2, railY, railZ ]);

  // Hook that holds onto the wire:
  translate([ -magic - mainX / 2, -armReachOut - armThickness / 2, railZ + mainThickness + armReachUp + hookZ ])
  rotate([ 0, 90, 0 ])
  cylinder(h = mainX + magic * 2, d = hookD);
}

// Fastener:
difference() {
  translate([ 0, mainThickness, railZ + mainThickness - backBumpZ ])
  roundedCube(fastenerX, railY + mainThickness + backBumpY - mainR, backBumpZ + fastenerTopThickness, flatTop = true, flatFront = true, r = mainR, centerX = true);

  translate([ -magic - fastenerX / 2, mainThickness - magic, 0 ])
  cube([ fastenerX + magic * 2, railY, railZ ]);

  translate([ -magic - mainX / 2 - fastenerTolerance / 2, mainThickness - magic, 0 ])
  cube([ mainX + magic * 2 + fastenerTolerance, railY + mainThickness + backBumpY, railZ + mainThickness ]);
}
