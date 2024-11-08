$fn = $preview ? 50 : 100;

use <../lib/roundedCube.scad>

magic = 0.01;
mainThickness = 5;
mainR = mainThickness * .75;
mainX = 12; // this is effectively the "rail top clearance", the thing needs to fit between the ceiling & the rail, sideways, before rotating into place
railY = 15;
railZ = 22;
backBumpY = 3;
backBumpZ = 12.5;

// // Thinner version for a tough spot:
// mainR = mainThickness * .5;
// mainX = 8;

armThickness = 10;
armReachOut = 30;
armReachOutSupport = 8;
armReachUp = 35;
armReachUpSupport = 6;
hookD = 4;
hookZ = 12;
hookT = 1.5;

fastenerX = 30;
fastenerTopThickness = 4.5;
fastenerTolerance = .3;
fastener2ReachBack = 20;
fastener2ReachLeft = 20;
fastener2SlitZ = 5.5;
fastener2SlitX = 15;
fastener3Y = 2;
fastener3ClipY = 1;
fastener3ClipZ = 2;

// Main:
// !rotate([ 0, 90, 0 ]) // PRINT: "Vidga light strip hook"
difference() {
  union() {
    // Rail grabber main body:
    roundedCube(mainX, railY + mainThickness * 2, railZ + mainThickness, r = mainR, centerX = true);

    // Rail grabber back bump (connects with fastener):
    hull() {
      translate([ 0, railY + mainThickness, railZ + mainThickness - backBumpZ ])
      roundedCube(mainX, backBumpY + mainThickness, backBumpZ, r = mainR, flatFront = true, centerX = true);

      translate([ 0, -0, railZ + mainThickness - armThickness - armReachOutSupport ])
      roundedCube(mainX, railY + mainThickness * 2, armThickness + armReachOutSupport, r = mainR, centerX = true);
    }

    // Arm reaching out:
    hull() {
      translate([ 0, -armReachOut - armThickness, railZ + mainThickness - armThickness ])
      roundedCube(mainX, armReachOut + armThickness, armThickness, r = mainR, centerX = true);

      translate([ 0, -0, railZ + mainThickness - armThickness - armReachOutSupport ])
      roundedCube(mainX, railY + mainThickness * 2, armThickness + armReachOutSupport, r = mainR, centerX = true);
    }

    // Arm reaching up:
    translate([ 0, -armReachOut - armThickness, railZ + mainThickness - armThickness ]) {
      hull() {
        roundedCube(mainX, armThickness, armThickness + armReachUp, r = mainR, centerX = true, flatTop = true);

        translate([ 0, armThickness / 2, armReachUp + armThickness ])
        cube([ mainX, armThickness, magic ], center = true);
      }

      // Cable clip:
      union() {
        translate([ mainX / -2, hookD / 2, armReachUp + armThickness + hookZ ])
        rotate([ 0, 90, 0 ])
        cylinder(h = mainX, d = hookD);

        translate([ mainX / -2, hookD / -2 + armThickness, armReachUp + armThickness + hookZ ])
        rotate([ 0, 90, 0 ])
        cylinder(h = mainX, d = hookD);

        translate([ 0, armThickness / 2, armReachUp + armThickness + hookZ / 2 ]) {
          difference() {
            cube([ mainX, armThickness, hookZ ], center = true);
            cube([ mainX + magic, (armThickness - hookT * 2), hookZ + magic * 2 ], center = true);
          }
        }
      }
    }

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
}

// Fastener (type 1):
// !rotate([ 0, 180, 0 ]) // PRINT: "Vidga light strip hook - fastener 1"
*difference() {
  hull() {
    translate([ 0, mainThickness, railZ + mainThickness - backBumpZ ])
    roundedCube(mainX + mainThickness * 2, railY + mainThickness + backBumpY * .5, mainR, flatTop = true, flatFront = true, r = mainR, centerX = true);

    translate([ 0, mainThickness, railZ + mainThickness ])
    roundedCube(fastenerX, railY + mainThickness + backBumpY * .5, fastenerTopThickness, flatTop = true, flatFront = true, r = mainR, centerX = true);
  }

  translate([ -magic - fastenerX / 2, mainThickness - magic, 0 ])
  cube([ fastenerX + magic * 2, railY, railZ ]);

  translate([ -magic - mainX / 2 - fastenerTolerance / 2, mainThickness - magic, 0 ])
  cube([ mainX + magic * 2 + fastenerTolerance, railY + mainThickness + backBumpY, railZ + mainThickness ]);
}

// Fastener (type 2, turned out to kinda suck):
// !rotate([ 0, 180, 0 ]) // PRINT: "Vidga light strip hook - fastener 2"
*difference() {
  union() {
    hull() {
      translate([ 0, mainThickness + railY, railZ + mainThickness - backBumpZ ])
      roundedCube(mainX + mainThickness * 2, mainThickness + backBumpY, fastenerTopThickness + backBumpZ, flatTop = true, flatFront = true, r = mainR, centerX = true);

      translate([ 0, mainThickness + railY + fastener2ReachBack, railZ + mainThickness - armThickness + fastenerTopThickness ])
      roundedCube(mainX + mainThickness * 2, mainThickness + backBumpY, armThickness, flatTop = true, flatFront = true, r = mainR, centerX = true);
    }

    hull() {
      translate([ 0, mainThickness + railY + fastener2ReachBack, railZ + mainThickness - armThickness + fastenerTopThickness ])
      roundedCube(mainX + mainThickness * 2, mainThickness + backBumpY, armThickness, flatTop = true, flatFront = true, r = mainR, centerX = true);

      translate([ -fastener2ReachLeft, mainThickness + railY + fastener2ReachBack, railZ + mainThickness - armThickness + fastenerTopThickness ])
      roundedCube(mainX + mainThickness * 2, mainThickness + backBumpY, armThickness, flatTop = true, flatFront = true, r = mainR, centerX = true);
    }
  }

  translate([ -magic - mainX / 2 - fastenerTolerance / 2, mainThickness - magic, 0 ])
  cube([ mainX + magic * 2 + fastenerTolerance, railY + mainThickness + backBumpY, railZ + mainThickness ]);

  translate([ -fastener2ReachLeft - fastener2ReachLeft / 2, 50, railZ + mainThickness + fastenerTopThickness - armThickness / 2 ])
  cube([ fastener2SlitX * 2, 50, fastener2SlitZ ], center = true);
}

// Fastener (type 3):
*rotate([ 0, 180, 0 ]) // PRINT: "Vidga light strip hook - fastener 3"
difference() {
  translate([ 0, mainThickness - fastener3Y, -fastener3ClipZ ])
  roundedCube(fastenerX, railY + fastener3Y * 2, railZ + mainThickness + fastenerTopThickness + fastener3ClipZ, r = mainR, centerX = true);

  translate([ -magic - mainX / 2 - fastenerTolerance / 2, 100 / -2, -100 + railZ + mainThickness + fastenerTolerance ])
  cube([ mainX + magic * 2 + fastenerTolerance, 100, 100 ]);

  translate([ 100 / -2, mainThickness - magic, 0 ])
  cube([ 100, railY, railZ ]);

  translate([ 100 / -2, mainThickness + fastener3ClipY, -railZ + magic ])
  cube([ 100, railY - fastener3ClipY * 2, railZ ]);
}
