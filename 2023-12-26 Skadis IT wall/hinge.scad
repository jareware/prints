$fn = $preview ? 25 : 100;

magic = 0.1;
hingeMainD = 40;
hingeMainThick = 2.5;
hingeMainH = 10;
hingeToothR = 2;
hingeToothH = 1;
hingeCutout = 20;
hingeToleranceR = .3;
hingeToleranceZ = .3;
hingeArmThick = 2;
hingeArmWidth = 30;
hingeArmLength = 40;

// Sample:
hinge();

module hinge() {
  hingeInner();
  hingeOuter();
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
        translate([ -hingeArmLength, hingeArmWidth / -2, -hingeArmThick ])
        cube([ hingeArmLength, hingeArmWidth, hingeArmThick ]);
      }

      // Bottom plate dead space:
      translate([ 0, 0, -hingeArmThick - magic ])
      cylinder(d = hingeMainD - hingeMainThick * 2, h = hingeMainH * 2);
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
