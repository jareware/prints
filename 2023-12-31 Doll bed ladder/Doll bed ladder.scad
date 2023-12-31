$fn = $preview ? 15 : 35;

use <../lib/roundedCube.scad>

knobX = 7.2;
knobY = 5.6;
knobZ = 5;
knobR = 1.5;
knobDist = 67 - knobX * 2;
mainX = knobX * 1.5;
mainY = knobY * 1.5;
// mainZ = 285 / 3;
mainZ = 25;
mainR = 2;
holeTolerance = .5;

difference() {
  roundedCube(mainX, mainY, mainZ, r = mainR);

  translate([ mainX / 2 - (knobX + holeTolerance) / 2, mainY / 2 - (knobY + holeTolerance) / 2, 0 ])
  roundedCube((knobX + holeTolerance), (knobY + holeTolerance), (knobZ + holeTolerance), r = knobR, flatBottom = true, flatTop = true);
}

translate([ mainX / 2 - knobX / 2, mainY / 2 - knobY / 2, mainZ ])
roundedCube(knobX, knobY, knobZ, r = knobR, flatBottom = true);
