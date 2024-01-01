$fn = $preview ? 35 : 100;

use <mount.scad>

magic = 0.1;
hingeMainD = 45;
hingeMainThick = 2.5;
hingeMainH = 10;
hingeToothR = 2;
hingeToothH = 1;
hingeCutout = 20;
hingeToleranceR = .8; // .3 was a bit too little, 1 a bit too much
hingeToleranceZ = .8;
hingeArmThick = 3;
hingeArmWidth = 35;
hingeArmLength = 60;
hingeMountWidth = 42;
hingeMountHeight = 53;
hingeMountBaseR = 23;

// Sample:
hinge(renderOuter = false);

module hinge(leftHandSide = true, renderInner = true, renderOuter = true) {
  mirror([ 0, leftHandSide ? 0 : 1, 0 ]) {
    if (renderInner) {
      * hingeInner();
      difference() {
        translate([ -hingeArmLength + hingeArmThick, 0, hingeMountHeight / 2 ])
        hingeMount(lowerBy = hingeArmThick);
        screwHoles();
      }
    }

    if (renderOuter) {
      hingeOuter();
      translate([ hingeArmLength - hingeArmThick, 0, hingeMountHeight / 2 ])
      mirror([ 1, 0, 0 ])
      hingeMount();
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
        cube([ hingeArmLength - hingeArmThick, hingeArmWidth, hingeArmThick ]);

        // Base slope:
        translate([ -hingeArmLength + hingeArmThick, 0, 0 ])
        hingeBaseSlope();
      }

      // Bottom plate dead space:
      translate([ 0, 0, -hingeArmThick - magic ])
      cylinder(d = hingeMainD - hingeMainThick * 2, h = hingeMainH * 2);

      // Screw holes:
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
        cube([ hingeArmLength, hingeArmWidth, hingeArmThick ]);
      }

      // Center big dead space:
      translate([ 0, 0, -magic ])
      cylinder(d = hingeMainD, h = hingeMainH + magic * 2);
    }
  }
}

module hingeMount(lowerBy = 0) {
  rotate([ 0, -90, 0 ])
  translate([ lowerBy / -2, 0, 0 ])
  mount(
    width = hingeMountHeight + lowerBy, // yes, swapped intentionally
    height = hingeMountWidth,
    thickness = hingeArmThick,
    offsetX = 5 + lowerBy,
    offsetY = 3.5,
    clipRowsCols = [
      [true, true],
      [false, true],
    ]
  );
}

module hingeBaseSlope() {
  difference() {
    translate([ 0, hingeArmWidth / -2, 0 ])
    cube([ hingeMountBaseR, hingeArmWidth, hingeMountBaseR ]);

    translate([ hingeMountBaseR, hingeArmWidth, hingeMountBaseR ])
    rotate([ 90, 0, 0 ])
    cylinder(r = hingeMountBaseR, h = hingeArmWidth * 2);

    translate([ 0, hingeArmWidth / -2, hingeMountBaseR * .6 ])
    cube([ hingeMountBaseR, hingeArmWidth, hingeMountBaseR ]);
  }
}

module screwHole() {
  // TX10, 3.5 x 15 mm
  translate([ 0, 0, 3 ])
  cylinder(h = 15 - 3, d = 3);
  translate([ 0, 0, 15 - 3.5 ])
  cylinder(h = 3.5, d1 = 3, d2 = 7);
  cylinder(h = 3, d1 = 1, d2 = 3);
}

module screwHoles() {
  translate([ -hingeArmLength + 15 - magic, hingeArmWidth * .35, 1 ])
  rotate([ 0, -90, 0 ])
  screwHole();

  translate([ -hingeArmLength + 15 - magic, hingeArmWidth * -.35, 1 ])
  rotate([ 0, -90, 0 ])
  screwHole();
}
