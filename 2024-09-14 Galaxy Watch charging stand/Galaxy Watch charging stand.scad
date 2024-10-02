$fn = $preview ? 50 : 100;

use <../lib/roundedCube.scad>

magic = 0.01;
mainR = 7;
deckX = 40;
deckY = 70;
deckZ = 14;
watchBodyD = 45.5 + 1;
watchBodyT = 15;
watchCutoutY = 12;
watchCutoutZ = 28;
watchChargingPlateD = 29.5 + .5;
watchChargingPlateT = 6.8;
watchChargingCordD = 5;
strapSupportZ = 10;
strapSupportX = 20;
strapSupportRaise = 10;

main();
tail();

module main() {
  difference() {
    union() {
      roundedCube(deckX, watchCutoutY + deckZ, deckZ, r = mainR, centerX = true);
      
      translate([ 0, watchCutoutY, 0 ])
      roundedCube(deckX, deckZ, watchBodyD, r = mainR, centerX = true);
    }

    translate([ 0, watchCutoutY, watchCutoutZ ])
    rotate([ 90, 0, 0 ])
    #watchCutout();
  }
}

module tail() {
  difference() {
    union() {
      hull() {
        translate([ 0, watchCutoutY, 0 ])
        roundedCube(strapSupportX, deckZ, deckZ + strapSupportZ, r = mainR, centerX = true);

        translate([ 0, deckY - deckZ, strapSupportRaise ])
        roundedCube(strapSupportX, deckZ, deckZ + strapSupportZ - strapSupportRaise, r = mainR, centerX = true);
      }
    }

    translate([ 0, 0, 0 ])
    roundedCube(deckX, deckZ + watchCutoutY, watchBodyD, r = mainR, centerX = true);
  }
}

module watchCutout() {
  cylinder(h = watchBodyT, d = watchBodyD);

  translate([ 0, 0, -watchChargingPlateT ])
  cylinder(h = watchChargingPlateT, d = watchChargingPlateD);
  
  hull() {
    translate([ 0, 0, -watchChargingPlateT + watchChargingCordD / 2 ])
    rotate([ 90, 0, 0 ])
    cylinder(h = 50, d = watchChargingCordD);

    translate([ 0, 0, watchBodyT * 2 ]) // x2 just so it's "enough"
    rotate([ 90, 0, 0 ])
    cylinder(h = 50, d = watchChargingCordD);
  }
}
