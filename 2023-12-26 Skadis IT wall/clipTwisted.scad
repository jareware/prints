$fn = $preview ? 25 : 75;

magic = 0.01;
clipX = 5;
clipY = 15;
clipH = 5.3; // i.e. IKEA Skådis plate thickness
clipTolerance = .3;
clipCoreD1 = 3;
clipCoreD2 = 3.5;
clipCoreD3 = 6.7; // screw head max D
clipCoreH3 = 3.7; // screw head H
clipTopH = 7;

// Sample:
// translate([ 0, 0, 3 / -2 ])
// difference() {
//   cube([ 8, 18, 3 ], center = true);
//   translate([ 0, 0, -10 ]) cylinder(d = clipCoreD1, h = 20);
// }
// clipTwisted();

// For printing:
clipTwisted(bottom = true, top = false);
translate([ 10, 0, -clipH - clipTolerance ])
clipTwisted(bottom = false, top = true);


module clipTwisted(bottom = true, top = true) {
  color("Chocolate") { // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#color
    if (bottom)
    difference() {
      // Base:
      clipTwistedBody();

      // Screw hole:
      cylinder(d = clipCoreD1, h = clipH + magic);
    }

    if (top)
    translate([ 0, 0, clipH + clipTolerance ])
    difference() {
      // Base:
      clipTwistedBody(clipTopH);

      // Screw hole:
      cylinder(d = clipCoreD2, h = clipTopH + magic);

      // Screw head hole:
      translate([ 0, 0, clipTopH - clipCoreH3 ])
      #cylinder(d1 = clipCoreD2, d2 = clipCoreD3, h = clipCoreH3 + magic);
    }
  }
}


module clipTwistedBody(height = clipH) {
  hull() {
    translate([ 0, (clipY - clipX) / 2, 0 ])
    cylinder(d = clipX, h = height);
    translate([ 0, (clipY - clipX) / -2, 0 ])
    cylinder(d = clipX, h = height);
  }
}
