$fn = $preview ? 50 : 100;

use <../lib/roundedCube.scad>

magic = 0.01;
mainR = 3;
mainT = 4;
watchBodyD = 45.5 + 1;
watchBodyT = 15;
chargingPlateD = 29.5 + .5;
chargingPlateT = 6.8;
chargingCordD = 5;
cradleBottomDeg = 120;
claspRestX = 20;
claspRestY = 33 + 10; // where 10 is the "rest area"
claspRestZ = 6;
claspRestRaise = 10; // this is where the watch is horizontal
backRestZ = 25;
standY = 20;
standZ = 40;
standMoveBack = 10;
standCutoutT = 3;
standCutoutZ = 15;

main();

module main() {
  rotate([ 90, 0, 0 ])
  difference() {
    cradle();
    cutout();
  }

  // // Sanity check position where clasp should rest
  // #translate([ 0, 0, watchBodyD / -2 + magic ])
  // cube([ magic, 40, 10 ]);

  translate([ 0, chargingPlateT, watchBodyD / -2 - claspRestZ + claspRestRaise ])
  roundedCube(claspRestX, claspRestY, claspRestZ, r = mainR, centerX = true, flatFront = true);

  difference() {
    translate([ 0, chargingPlateT + standMoveBack, watchBodyD / -2 + claspRestRaise - standZ ])
    roundedCube(claspRestX, standY, standZ, r = mainR, centerX = true);

    translate([ claspRestX / -2, chargingPlateT + standMoveBack - standCutoutT / 2 + standY / 2, watchBodyD / -2 + claspRestRaise - standZ ])
    cube([ claspRestX, standCutoutT, standCutoutZ ]);
  }

  // Backrest:
  hull() {
    translate([ 0, chargingPlateT, watchBodyD / -2 + claspRestRaise - claspRestZ ])
    roundedCube(claspRestX, standY + standMoveBack, claspRestZ, r = mainR, centerX = true, flatFront = true);

    translate([ 0, chargingPlateT, watchBodyD / -2 + claspRestRaise - claspRestZ + backRestZ ])
    roundedCube(claspRestX, mainT, claspRestZ, r = mainR, centerX = true, flatFront = true);
  }
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
}

module cradle() {
  difference() {
    translate([ 0, 0, -mainT ])
    cylinder(h = watchBodyT + mainT - magic, d = watchBodyD + mainT * 2);

    rotate([ 0, 0, -90 + cradleBottomDeg / 2 ])
    rotate_extrude(angle = 360 - cradleBottomDeg)
    square([ watchBodyD / 2 + mainT + 10, watchBodyT ]);
  }

  hull() {
    translate([ 0, 0, -mainT ])
    cylinder(h = magic, d = watchBodyD + mainT * 2);

    translate([ 0, 0, -chargingPlateT - mainT + magic ])
    cylinder(h = chargingPlateT, d = chargingPlateD + mainT * 2);
  }
}
