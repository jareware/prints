$fn = $preview ? 25 : 75;

magic = 0.01;
clipX = 5;
clipY = 15;
clipH = 5.3; // i.e. IKEA Skådis plate thickness
clipTolerance = .5;
clipCoreD1 = 2.5;
clipCoreD2 = 3.5;
clipTwistH = 7;
clipSupportD = .5;
clipSupportDist = 1.4;
clipSupportX = .5;
clipSupportY = -.3;

// Sample:
translate([ 8 / -2, 18 / -2, -3 ])
cube([ 8, 18, 3 ]);
difference() {
  clipTwistBody();
  clipTwistPin();
}
translate([ 15, 0, 0 ]) {
  translate([ 5 / -2, 10 / -2, -3 ])
  cube([ 5, 10, 3 ]);

  translate([ 0, 0, 9.2 ])
  rotate([ 0, 180, 0 ])
  clipTwistPin();
}


module clipTwist() {
  color("Chocolate") { // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#color
    // Base plug:
    clipTwistBody();

    difference() {
      // Twist plug:
      translate([ 0, 0, clipH + clipTolerance ])
      clipTwistBody(clipTwistH - clipTolerance);

      // Remove core:
      translate([ 0, 0, clipH ])
      cylinder(d1 = clipCoreD1 + clipTolerance * 2, d2 = clipCoreD2 + clipTolerance * 2, h = clipTwistH + magic);
    }

    // Core peg:
    translate([ 0, 0, clipH ])
    cylinder(d1 = clipCoreD1, d2 = clipCoreD2, h = clipTwistH);
  }

  intersection() {
    translate([ 0, 0, clipH ])
    clipTwistBody();

    for (y = [-10 : 10]) {
      for (x = [-10 : 10]) {
        translate([ x * clipSupportDist + clipSupportX, y * clipSupportDist + clipSupportY, clipH ])
        cube([ clipSupportD, clipSupportD, 1 ]);
      }
    }
  }
}


module clipTwistBody(height = clipH) {
  hull() {
    translate([ 0, (clipY - clipX) / 2, 0 ])
    cylinder(d = clipX, h = height);
    translate([ 0, (clipY - clipX) / -2, 0 ])
    cylinder(d = clipX, h = height);
  }
}

pinThickness = clipX * .6;
pinThicknessBottom = pinThickness * 1.1;
module clipTwistPin() {
  hull() {
    translate([ 0, 0, pinThickness / 2 ])
    sphere(d = pinThickness);

    translate([ 0, 0, clipH * 2 ])
    sphere(d = pinThickness);
  }

  translate([ 0, 0, clipH / 2 ])
  resize([ pinThicknessBottom, pinThicknessBottom, clipH ])
  sphere(d = 1);
}

