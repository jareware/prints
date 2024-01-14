$fn = $preview ? 35 : 75;

include <const.scad>
use <mountPlate.scad>
use <../lib/roundedCube.scad>

mainWidth = 20;
mainHeight = 10;
mountPlateWidth = 30;
mountPlateHeight = 25;
mountPlateThickness = 3;

// Plate distance sanity check:
if ($preview) #cube([ 50, 10, PLATE_DISTANCE ]);

// Printed as "Skadis IT wall - Door fastener"
doorFastener();

module doorFastener() {
  roundedCube(mainWidth, mainHeight, PLATE_DISTANCE, r = ROUNDING, flatTop = true, flatBottom = true, centerX = true, centerY = true);

  // Bottom:
  translate([ 0, 0, mountPlateThickness ])
  rotate([ 180, 0, 0 ])
  mountPlate(
    width = mountPlateWidth,
    height = mountPlateHeight,
    thickness = mountPlateThickness,
    offsetX = mountPlateWidth / 2 - 3.5, // these magic values work for centering a single clip
    offsetY = (mountPlateHeight - 15) / 2, // ^ ditto
    clipRowsCols = [[true]]
  );

  // Top:
  translate([ 0, 0, PLATE_DISTANCE - mountPlateThickness ])
  mountPlate(
    width = mountPlateWidth,
    height = mountPlateHeight,
    thickness = mountPlateThickness,
    offsetX = mountPlateWidth / 2 - 3.5, // these magic values work for centering a single clip
    offsetY = (mountPlateHeight - 15) / 2, // ^ ditto
    clipRowsCols = [[true]]
  );
}
