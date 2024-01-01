$fn = $preview ? 15 : 35;

use <../lib/roundedCube.scad>

magic = 0.001;
knobX = 7;
knobY = 5.4;
knobZ = 10;
knobR = $preview ? 0 : 1.5;
knobDist = 67 - knobX; // i.e. between centers
mainX = knobX + 5;
mainY = knobY + 5;
mainZ = 285 / 3;
mainR = $preview ? 0 : 2;
holeTolerance = .35;
shiftY = 15;
shiftZ = 6;
shiftSpokeTilt = 22;
shiftSpokeTweak = -.5;
topCutoutXY = 3;
topCutoutZ = 20;

for (x = [ 0, knobDist ]) {
  translate([ x, 0, 0 ]) {
    difference() {
      union() {
        // Main body bottom 3rd:
        roundedCube(mainX, mainY, mainZ / 3, r = mainR);

        // Lower spoke:
        if (x == 0) roundedCube(knobDist + mainR, mainY, mainX, r = mainR, flatRight = true);
      }

      // Bottom knob recepticle:
      translate([ mainX / 2 - (knobX + holeTolerance) / 2, mainY / 2 - (knobY + holeTolerance) / 2, -magic ])
      roundedCube((knobX + holeTolerance), (knobY + holeTolerance), (knobZ + holeTolerance), r = knobR, flatBottom = true, flatTop = true);
    }

    // Middle shifty bit:
    hull() {
      translate([ 0, 0, mainZ * 1/3 - shiftZ ])
      roundedCube(mainX, mainY, shiftZ, r = mainR);

      translate([ 0, shiftY, mainZ * 2/3 ])
      roundedCube(mainX, mainY, shiftZ, r = mainR);
    }

    // Middle spoke:
    if (x == 0) {
      translate([ 0, shiftY / 2 + shiftSpokeTweak, mainZ / 2 ])
      rotate([ -shiftSpokeTilt, 0, 0 ])
      roundedCube(knobDist + mainX, mainY, mainX, r = mainR);
    }

    difference() {
      // Main body top 3rd:
      translate([ 0, shiftY, mainZ * 2/3 ])
      roundedCube(mainX, mainY, mainZ / 3, r = mainR);

      // Top cutouts:
      translate([ x == 0 ? -topCutoutXY : mainX - topCutoutXY, shiftY - topCutoutXY, mainZ + knobZ - topCutoutZ ])
      roundedCube(topCutoutXY * 2, topCutoutXY * 2, topCutoutZ, r = mainR);
    }

    // Special edition top knob for topmost copy:
    translate([ mainX / 2 - knobX / 2, mainY / 2 - knobY / 2 + shiftY, mainZ ])
    roundedCube(knobX, knobY, knobZ - 1, r = knobR, flatBottom = true);
    // Widened base:
    translate([ mainX / 2 - knobX / 2 + (mainX - knobX) / -2, mainY / 2 - knobY / 2 + shiftY, mainZ - 3 ])
    roundedCube(knobX + (mainX - knobX), knobY, 3 * 2, r = knobR, flatBottom = true);
  }
}
