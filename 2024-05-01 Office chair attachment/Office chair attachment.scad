$fn = $preview ? 35 : 75;

use <../lib/screwHole.scad>

tipThickness = 10;
midThickness = 11.25;
railGap = 4.5;
bottomWiden = 0;
mainLen = 70;
floorThick = 12;
midRaise = floorThick + 18;
wallRaise = 15;
slopeBy = 30;
supportExtrudeX = 33.5;
supportExtrudeY = 44;

// %difference() {
//   union() {
//     hull() {
//       translate([ 0, 0, midThickness / 2 + tipThickness / 2 ])
//       sphere(d = midThickness);

//       translate([ 0, 0, midRaise - (midThickness / 2) ])
//       sphere(d = midThickness);

//       translate([ 0, mainLen, 0 ]) {
//         translate([ 0, 0, midThickness / 2 + tipThickness / 2 ])
//         sphere(d = midThickness);

//         translate([ 0, 0, midRaise - (midThickness / 2) + slopeBy ])
//         sphere(d = midThickness);
//       }
//     }

//     // for (i = [1, -1])
//     // translate([ (midThickness / -2 + tipThickness / -2 - railGap) * i, 0, 0 ])
//     // #hull() {
//     //   translate([ 0, 0, tipThickness / 2 ])
//     //   sphere(d = tipThickness);

//     //   translate([ 0, 0, midRaise - (tipThickness / 2) ])
//     //   sphere(d = tipThickness);

//     //   translate([ bottomWiden * -i, 0, tipThickness / 2 ])
//     //   sphere(d = tipThickness);

//     //   translate([ 0, mainLen, 0 ]) {
//     //     translate([ 0, 0, tipThickness / 2 ])
//     //     sphere(d = tipThickness);

//     //     translate([ 0, 0, midRaise - (tipThickness / 2) + slopeBy ])
//     //     sphere(d = tipThickness);

//     //     translate([ bottomWiden * -i, 0, tipThickness / 2 ])
//     //     sphere(d = tipThickness);
//     //   }
//     // }

//     cylH = midThickness / 2 + railGap + tipThickness / 2;
//     hull() {
//       translate([ -cylH, 0, tipThickness / 2 ])
//       rotate([ 0, 90, 0 ])
//       cylinder(h = cylH * 2, d = tipThickness);

//       translate([ -cylH, mainLen, tipThickness / 2 ])
//       rotate([ 0, 90, 0 ])
//       cylinder(h = cylH * 2, d = tipThickness);

//       translate([ -cylH, 0, tipThickness / 2 + (floorThick - tipThickness) ])
//       rotate([ 0, 90, 0 ])
//       cylinder(h = cylH * 2, d = tipThickness);

//       translate([ -cylH, mainLen, tipThickness / 2 + (floorThick - tipThickness) + slopeBy ])
//       rotate([ 0, 90, 0 ])
//       cylinder(h = cylH * 2, d = tipThickness);
//     }
//   }

//   translate([ 0, -25 - tipThickness / 2, 50 ])
//   cube([ 50, 50, 100 ], center = true);

//   translate([ 0, 25 + tipThickness / 2 + mainLen, 50 ])
//   cube([ 50, 50, 100 ], center = true);

//   // For test prints:
//   // translate([ 0, mainLen / 2, 50 + 2.5 ])
//   // cube([ 70, mainLen, 100 ], center = true);
//   // translate([ 0, mainLen / 2, 50 - 5 ])
//   // cube([ midThickness + railGap + bottomWiden * 2 + 5, mainLen - 8, 100 ], center = true);
// }






difference() {
  hull() {
    translate([ tipThickness / 2, tipThickness / 2, 0 ])
    sphere(d = tipThickness);
    translate([ tipThickness / 2, tipThickness / 2, floorThick + wallRaise ])
    sphere(d = tipThickness);

    translate([ tipThickness / 2, mainLen - tipThickness / 2, 0 ])
    sphere(d = tipThickness);
    translate([ tipThickness / 2, mainLen - tipThickness / 2, floorThick + slopeBy + wallRaise ])
    sphere(d = tipThickness);

    translate([ supportExtrudeX, supportExtrudeY, 0 ])
    sphere(d = tipThickness);
  }

  translate([ 0, 0, 18 / -2 ])
  cube([ 200, 200, 18 ], center = true);

  #translate([ 7, 12, -16 ]) screwHole("4.0 x 40 pan head countersunk");
  #translate([ 7, mainLen - 12, -16 ]) screwHole("4.0 x 40 pan head countersunk");
  #translate([ supportExtrudeX - 5, supportExtrudeY - 2, -15 ]) screwHole("3.5 x 20 countersunk");
}








// difference() {
// union() {
// hull() {
// translate([ tipThickness / 2, tipThickness / 2, 0 ])
// sphere(d = tipThickness);
// translate([ tipThickness / 2, tipThickness / 2, floorThick + wallRaise ])
// sphere(d = tipThickness);
// }

// hull() {
// translate([ tipThickness / 2, mainLen - tipThickness / 2, 0 ])
// sphere(d = tipThickness);
// translate([ tipThickness / 2, mainLen - tipThickness / 2, floorThick + slopeBy + wallRaise ])
// sphere(d = tipThickness);
// }

// hull() {
// translate([ tipThickness / 2, tipThickness / 2, 0 ])
// sphere(d = tipThickness);
// translate([ tipThickness / 2, mainLen - tipThickness / 2, 0 ])
// sphere(d = tipThickness);
// }


// hull() {
// translate([ supportExtrudeX, supportExtrudeY, 0 ])
// sphere(d = tipThickness);
// translate([ tipThickness / 2, tipThickness / 2, 0 ])
// sphere(d = tipThickness);
// }
// }

// translate([ 0, 0, -25 ])
// cube([ 200, 200, 50 ], center = true);
// }
