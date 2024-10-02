$fn = $preview ? 50 : 100;

use <../lib/roundedCube.scad>
use <../lib/screwHole.scad>

magic = 0.001;
mainR = 3;
mainT = 4;
watchBodyD = 45.5 + 1;
watchBodyT = 15;
chargingPlateD = 29.5 + .5;
chargingPlateT = 6.8;
chargingPlatePushoutD = 4;
chargingCordD = 5;
cradleBottomDeg = 80;
cradleBottomRound = 1.75; // can't exceed mainT/2
cradleBottomY = watchBodyT * .75;
standR = 10;
standX = 30;
standY = 15;
standZ = 70;
slitZ = 25;
slitY = 3;
claspRestX = standR * 2;
claspRestY = 33 + 5; // where 5 is the "rest area"
claspRestZ = 0;

main();

module main() {
  rotate([ 90, 0, 0 ])
  difference() {
    union() {
      cradle();

      rotate([ -90, 0, 0 ])
      stand();
    }
    
    translate([ 0, 0, -magic ])
    cutout();
      
    for (x = [ -1, 1 ])
    translate([ x * 3.5 * 2, 0, -chargingPlateT - 15 ])
    screwHole("3.5 x 15 countersunk");
  }

  // // Sanity check position where clasp should rest
  // #translate([ 0, 0, watchBodyD / -2 + magic ])
  // cube([ magic, 40, 10 ]);
}

module cutout() {
  cylinder(h = watchBodyT, d = watchBodyD);

  translate([ 0, 0, -chargingPlateT + magic ])
  cylinder(h = chargingPlateT, d = chargingPlateD);
  
  hull() {
    translate([ 0, 0, -chargingPlateT + chargingCordD / 2 + magic ])
    rotate([ 90, 0, 0 ])
    cylinder(h = 50, d = chargingCordD);

    translate([ 0, 0, watchBodyT * 2 ]) // x2 just so it's "enough"
    rotate([ 90, 0, 0 ])
    cylinder(h = 50, d = chargingCordD);
  }

  translate([ 0, chargingPlateD / 2 - chargingPlatePushoutD / 2, -50 ])
  cylinder(h = 50, d = chargingPlatePushoutD);
}

module cradle() {
  translate([ 0, 0, -mainT ])
  cylinder(h = mainT, d = watchBodyD + mainT * 2);

  // Local helpers:
  pieZ = cradleBottomY;
  pieR = watchBodyD / 2 + mainT;
  minkowski() {
    difference() {
      rotate([ 0, 0, cradleBottomDeg / -2 - 90 ])
      rotate_extrude(angle = cradleBottomDeg)
      square([ pieR - cradleBottomRound, pieZ - cradleBottomRound ]);

      cylinder(h = watchBodyT, d = watchBodyD + cradleBottomRound * 2);
    }

    sphere(r = cradleBottomRound);
  }

  hull() {
    translate([ 0, 0, -mainT ])
    cylinder(h = magic, d = watchBodyD + mainT * 2);

    translate([ 0, 0, -chargingPlateT - mainT + magic ])
    cylinder(h = chargingPlateT, d = chargingPlateD + mainT * 2);
  }
}

module stand() {
  difference() {
    translate([ 0, chargingPlateT + mainT, -standZ + standR ])
    roundedCube(standX, standY, standZ, r = standR, centerX = true, flatFront = true);

    translate([ standX / -2, chargingPlateT + mainT + standY / 2 - slitY / 2, -standZ + standR ])
    cube([ standX, slitY, slitZ ]);
  }
  
  translate([ 0, chargingPlateT + mainT, watchBodyD / -2 + claspRestZ ])
  roundedCube(claspRestX, claspRestY, standR, r = standR, centerX = true, flatFront = true, flatTop = true);
}
