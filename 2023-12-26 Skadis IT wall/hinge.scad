$fn = $preview ? 35 : 100;

use <mount.scad>

PLATE_DISTANCE = 120;

magic = 0.1;
hingeMainD = 45;
hingeMainThick = 2.5;
hingeMainH = 10;
hingeToothR = 1.5;
hingeToothH = 1;
hingeCutout = 18;
hingeToleranceR = .8; // .3 was a bit too little, 1 a bit too much
hingeToleranceZ = .8;
hingeArmThick = 3;
hingeArmThickExtra = 5;
hingeArmWidth = 25;
hingeArmLength = 60;
hingeMountWidth = 44;
hingeMountHeight = 50;

// Plate distance sanity check:
// translate([ PLATE_DISTANCE / -2 , 0, 0]) #cube([ PLATE_DISTANCE, 10, 100 ]);

// Sample:
// rotate([ -90, 0, 0 ]) // for a more realistic render
hinge(renderInner = true, renderOuter = true, renderInnerMount = true, renderOuterMount = true);

module hinge(leftHandSide = true, renderInner = false, renderOuter = false, renderInnerMount = false, renderOuterMount = false) {
  mirror([ 0, leftHandSide ? 0 : 1, 0 ]) {
    if (renderInner) {
      hingeInner();
    }

    if (renderInnerMount) {
      translate([ PLATE_DISTANCE / -2 + hingeArmThick, 0, 0 ])
      hingeMount(false);
    }

    if (renderOuter) {
      hingeOuter();
    }

    if (renderOuterMount) {
      mirror([ 1, 0, 0 ])
      translate([ PLATE_DISTANCE / -2 + hingeArmThick, 0, 0 ])
      hingeMount(true);
    }
  }
}

module hingeInner() {
  color("SeaGreen") { // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#color
    difference() {
      // Top clips:
      union() {
        cylinder(d = hingeMainD - hingeToleranceR, h = hingeMainH + hingeToleranceZ);
        hull() {
          translate([ 0, 0, hingeMainH + hingeToleranceZ ])
          cylinder(d = hingeMainD + hingeToothR * 2, h = hingeToothH);
          translate([ 0, 0, hingeMainH + hingeToleranceZ + hingeToothH ])
          cylinder(d = hingeMainD, h = hingeToothH);
        }
      }

      // Center big dead space:
      cylinder(d = hingeMainD - hingeMainThick * 2, h = hingeMainH * 2);

      // Cutouts:
      cube([ hingeCutout, hingeMainD * 2, hingeMainD * 1 ], center = true);
      cube([ hingeMainD * 2, hingeCutout, hingeMainD * 1 ], center = true);
    }

    difference() {
      union() {
        // Bottom plate:
        translate([ 0, 0, -hingeArmThick ])
        cylinder(d = hingeMainD + hingeMainThick * 2, h = hingeArmThick);

        // Arm:
        translate([ -hingeArmLength + hingeArmThick, hingeArmWidth / -2, -hingeArmThick ])
        cube([ hingeArmLength - hingeArmThick, hingeArmWidth, hingeArmThick + hingeArmThickExtra ]);
      }

      // Bottom plate dead space:
      translate([ 0, 0, -hingeArmThick - magic ])
      cylinder(d = hingeMainD - hingeMainThick * 2, h = hingeMainH * 2);

      // Arm extra dead space:
      translate([ 0, 0, -hingeArmThick - magic + hingeArmThick ])
      cylinder(d = hingeMainD + hingeMainThick * 2 + hingeToleranceR, h = hingeMainH * 2);

      // Screw holes:
      translate([ -hingeArmLength, 0, hingeArmThick / -2 + hingeArmThickExtra / 2 ])
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
        cube([ hingeArmLength - hingeArmThick, hingeArmWidth, hingeArmThick + hingeArmThickExtra ]);
      }

      // Center big dead space:
      translate([ 0, 0, -magic ])
      cylinder(d = hingeMainD, h = hingeMainH + magic * 2);

      // Screw holes:
      translate([ hingeArmLength, 0, (hingeArmThick + hingeArmThickExtra) / 2 ])
      rotate([ 0, 180, 0 ])
      screwHoles();
    }
  }
}

module hingeMount(positionScrewsForOuter = false) {
  raise = 11; // arbitrary tweak so that screwholes down collide with clips
  difference() {
    rotate([ 0, -90, 0 ])
    translate([ raise, 0, 0 ])
    mount(
      width = hingeMountHeight, // yes, swapped intentionally
      height = hingeMountWidth,
      thickness = hingeArmThick,
      offsetX = 21.5,
      offsetY = 7,
      clipRowsCols = [
        [true],
        [true, true],
      ]
    );

    translate([ -hingeArmThick, 0,
      positionScrewsForOuter
        ? (hingeArmThick + hingeArmThickExtra) / 2
        : hingeArmThick / -2 + hingeArmThickExtra / 2
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
