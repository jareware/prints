$fn = $preview ? 50 : 75;

include <const.scad>
use <clipPinned.scad>
use <../lib/roundedCube.scad>

insertX = 15;
insertY = 27.3;
insertZ = 3.6;
insertR = 4.5;
armZ = 2.7;
armX = 12;
armY = 16;

// #cylinder(h = 1, d = 21.5 + 3.4*2);
// #cylinder(h = 5, d = 21.5);

// Printed as "Skadis IT wall - Power strip"
holderPowerStrip();

module holderPowerStrip() {
  roundedCube(insertX, insertY, insertZ, r = insertR, flatTop = true, flatBottom = true, centerX = true, centerY = true);

  translate([ 0, 0, armZ / 2 + insertZ ])
  cube([ armX, armY, armZ ], center = true);

  translate([ 0, 0, insertZ + armZ ])
  clipPinned();
}
