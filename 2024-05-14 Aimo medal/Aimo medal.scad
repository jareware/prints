$fn = $preview ? 25 : 200;

use <../lib/screwHole.scad>

svgScale = .7;
bodyThickness = 10;
partThickness = 8;
partRaise = 5;
partTolerance = .4;
tunnelD = 7;
tunnelR = 50;
tunnelY = 100;
handlePlateH = 7;
handlePlateD1 = 70;
handlePlateD2 = 45;
handleD = 30;
handleH = 100;
handleStandH = handlePlateH;
handleStandD = 60;
handleTilt = 45;
handleAdjust = 0;
handleMove = 10;


// Body:
difference() {
  svg(body = true);
  minkowski() {
    svg(parts = true);
    translate([ 0, 0, -partTolerance ])
    cylinder(h = partTolerance * 2, r = partTolerance);
  }
  tunnel();
  screws();
}

// // Parts:
// difference() {
//   svg(parts = true);
//   tunnel();
// }

// // Handle:
// difference() {
//   handle();
//   screws();
// }

// Mount:
difference() {
  mount();
  screws();
}

module svg(body = false, parts = false) {
  scale([ svgScale, svgScale, 1 ])
  translate([ -104, 27.5, 0 ]) { // this is related to the SVG content, and thus not parametrizable
    if (body) {
      color("white")
      linear_extrude(height = bodyThickness)
      import("aimo-01-body.svg", $fn = 200);
    }

    if (parts)
    translate([ 0, 0, partRaise ]) {
      color("black")
      linear_extrude(height = partThickness)
      import("aimo-02-arrow.svg");

      color("blue")
      linear_extrude(height = partThickness)
      import("aimo-03-feathers.svg");

      color("hotpink")
      linear_extrude(height = partThickness)
      import("aimo-04-cheek.svg", $fn = 100);

      color("yellow")
      linear_extrude(height = partThickness)
      import("aimo-05-beak.svg");
    }
  }
}

module tunnel() {
  translate([ 0, tunnelY, bodyThickness / 2 ])
  rotate_extrude(convexity = 10)
  translate([ tunnelR, 0, 0 ])
  circle(d = tunnelD);
}

handleScrewSink = 16;
handleScrewMove1 = 7;
handleScrewMove2 = 10;

module handle() {
  translate([ 0, handleMove, 0 ]) {
    difference() {
      union() {
        color("darkgray")
        resize([ handlePlateD1, handlePlateD2, handlePlateH ])
        translate([ 0, 0, -handlePlateH ])
        cylinder(h = handlePlateH, d = handlePlateD1);

        color("DarkSlateGray")
        translate([ 0, handleAdjust, 0 ])
        difference() {
          rotate([ -handleTilt, 0, 0 ]) {
            translate([ 0, 0, -handlePlateH ])
            cylinder(h = 50, d = handleD);

            translate([ 0, 0, -handlePlateH - handleH ])
            cylinder(h = handleH, d = handleD);

            translate([ 0, 0, -handlePlateH - handleH - handleStandH ])
            cylinder(h = handleStandH, d = handleStandD);
          }

          cylinder(h = 100, d = 100);

          resize([ handlePlateD1, handlePlateD2, handlePlateH ])
          translate([ 0, 0, -handlePlateH ])
          cylinder(h = handlePlateH, d = handlePlateD1);
        }
      }

      translate([ 0, -handleMove - handleScrewMove1, -handleScrewSink ])
      screwHole("3.5 x 15 countersunk");

      translate([ 0, -handleMove + handleScrewMove2, -handleScrewSink ])
      screwHole("3.5 x 15 countersunk");
    }
  }
}

module screws() {
  translate([ 0, handleMove, 0 ])
  for (i = [-1, 1])
  rotate([ 0, 180, 0 ])
  translate([ (handlePlateD1 / 2 - (handlePlateD1 - handleD) / 2 / 2) * i * 1.15, 0, -bodyThickness + 2 ])
  screwHole("3.5 x 15 countersunk");
}

module mount() {
  translate([ 0, handleMove, 0 ]) {
    difference() {
      union() {
        color("darkgray")
        resize([ handlePlateD1, handlePlateD2, handlePlateH ])
        translate([ 0, 0, -handlePlateH ])
        cylinder(h = handlePlateH, d = handlePlateD1);

        color("green")
        translate([ 20 / -2, 80 / -2, -handlePlateH ])
        cube([ 20, 80, handlePlateH ]);
      }

      translate([ 0, 50, -handlePlateH - 5 ])
      rotate([ 90, 0, 0 ])
      cylinder(h = 100, d = 16);

      #translate([ 0, -30 * 1, -18 ])
      rotate([ 90, 0, 0 ])
      rotate_extrude(convexity = 10)
      translate([ 20, 0, 0 ])
      circle(d = 7);

      #translate([ 0, -30 * -1, -18 ])
      rotate([ 90, 0, 0 ])
      rotate_extrude(convexity = 10)
      translate([ 20, 0, 0 ])
      circle(d = 7);
    }
  }
}
