$fn = $preview ? 50 : 100;

use <mountPlate.scad>

PLATE_DISTANCE = 120;

magic = 0.1;
hingeMainD = 40;
hingeMainThick = 4.5;
hingeMainH = 7;
hingeToothR = .15;
hingeToothH1 = .8;
hingeToothH2 = 1.2;
hingeCutout = 10;
hingeToleranceR = .8;
hingeToleranceZ = .4;
hingeArmThick = hingeMainH; // Prod value: hingeMainH
hingeArmWidth = 30;
hingeArmLength = 65;
hingeMountWidth = 44;
hingeMountHeight = 30;
hingeMountThick = 3;
hingeBottomSlopeH = 2;
hingeBottomSlopeD = 1;

// Plate distance sanity check:
// translate([ PLATE_DISTANCE / -2 , 0, 0]) #cube([ PLATE_DISTANCE, 10, 100 ]);

// Sample:
rotate([ -90, 0, 0 ]) // for a more realistic render
hinge(renderInner = true, renderOuter = true, renderOuterMount = true, renderInnerMount = true);

// Printed as "Skadis IT wall - Hinge inner":
// hinge(renderInner = true);

// Printed as "Skadis IT wall - Hinge outer":
// hinge(renderOuter = true);

// Printed as "Skadis IT wall - Hinge mount 1" and "2":
// hinge(renderInnerMount = true, renderOuterMount = true);

// Printed as "Skadis IT wall - Hinge mount R 1" and "2":
// hinge(leftHandSide = false, renderInnerMount = true, renderOuterMount = true);

module hinge(leftHandSide = true, renderInner = false, renderOuter = false, renderInnerMount = false, renderOuterMount = false) {
  mirror([ 0, leftHandSide ? 0 : 1, 0 ]) {
    if (renderInner) {
      hingeInner();
    }

    if (renderInnerMount) {
      translate([ PLATE_DISTANCE / -2 + hingeMountThick, 0, 0 ])
      hingeMount(false);
    }

    if (renderOuter) {
      hingeOuter();
    }

    if (renderOuterMount) {
      mirror([ 1, 0, 0 ])
      translate([ PLATE_DISTANCE / -2 + hingeMountThick, 0, 0 ])
      hingeMount(true);
    }
  }
}

module hingeInner() {
  color("SeaGreen") { // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#color
    difference() {
      union() {
        // Top clips:
        cylinder(d = hingeMainD - hingeToleranceR, h = hingeMainH + hingeToleranceZ);
        hull() {
          translate([ 0, 0, hingeMainH + hingeToleranceZ ])
          cylinder(d = hingeMainD + hingeToothR * 2, h = hingeToothH1);
          translate([ 0, 0, hingeMainH + hingeToleranceZ + hingeToothH2 ])
          cylinder(d = hingeMainD - hingeMainThick * 2, h = hingeToothH2);
        }

        // Bottom plate:
        translate([ 0, 0, -hingeArmThick ])
        cylinder(d = hingeMainD + hingeMainThick * 2, h = hingeArmThick);

        // Arm:
        translate([ -hingeArmLength + hingeArmThick, hingeArmWidth / -2, -hingeArmThick ])
        cube([ hingeArmLength - hingeArmThick, hingeArmWidth, hingeArmThick ]);
      }

      // Center big dead space:
      translate([ 0, 0, -hingeArmThick - magic ])
      cylinder(d = hingeMainD - hingeMainThick * 2, h = hingeMainH * 3);

      // Clip cutouts:
      translate([ 0, 0, hingeMainD / 2 ]) {
        cube([ hingeCutout, hingeMainD * 1.5, hingeMainD ], center = true);
        cube([ hingeMainD * 1.5, hingeCutout, hingeMainD ], center = true);
      }

      // Screw holes:
      translate([ -hingeArmLength, 0, hingeArmThick / -2 ])
      screwHoles();
    }
  }
}

module hingeOuter() {
  color("DeepSkyBlue") { // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#color
    // Main ring:
    difference() {
      union() {
        cylinder(d = hingeMainD + hingeMainThick * 2, h = hingeMainH);

        // Arm:
        translate([ 0, hingeArmWidth / -2, 0 ])
        cube([ hingeArmLength - hingeArmThick, hingeArmWidth, hingeArmThick ]);
      }

      // Center big dead space:
      translate([ 0, 0, -magic ])
      cylinder(d = hingeMainD, h = hingeMainH + magic * 2);

      // Screw holes:
      translate([ hingeArmLength, 0, hingeArmThick / 2 ])
      rotate([ 0, 180, 0 ])
      screwHoles();

      // Bottom guide slope:
      translate([ 0, 0, -magic ])
      cylinder(d1 = hingeMainD + hingeBottomSlopeD, d2 = hingeMainD, h = hingeBottomSlopeH + magic * 2);
    }
  }
}

module hingeMount(positionScrewsForOuter = false) {
  raise = 0; // arbitrary tweak so that screwholes down collide with clips
  difference() {
    rotate([ 0, -90, 0 ])
    translate([ raise, 0, 0 ])
    mountPlate(
      width = hingeMountHeight, // yes, swapped intentionally
      height = hingeMountWidth,
      thickness = hingeMountThick,
      offsetX = 21.5,
      offsetY = 7,
      clipRowsCols = [
        [true],
        [true],
      ]
    );

    translate([ -hingeMountThick, 0,
      positionScrewsForOuter
        ? hingeArmThick / 2
        : hingeArmThick / -2
    ])
    screwHoles();
  }
}

module screwHole() {
  // TX10, 3.5 x 15 mm
  cylinder(h = 3, d1 = 1, d2 = 3);
  translate([ 0, 0, 3 ])
  cylinder(h = 15 - 3, d = 3);
  translate([ 0, 0, 15 - 3.5 ])
  cylinder(h = 3, d1 = 3, d2 = 7);
  translate([ 0, 0, 15 - .5 ])
  cylinder(h = .5, d = 7);
}

module screwHoles() {
  translate([ 15 - magic, hingeArmWidth * .35, 0 ])
  rotate([ 0, -90, 0 ])
  screwHole();

  translate([ 15 - magic, hingeArmWidth * -.35, 0 ])
  rotate([ 0, -90, 0 ])
  screwHole();
}
