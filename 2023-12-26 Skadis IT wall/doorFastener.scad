$fn = $preview ? 35 : 75;

include <const.scad>
use <mountPlate.scad>
use <hinge.scad>
use <clipPinned.scad>
use <../lib/roundedCube.scad>

mainWidth = 7; // matches hingeArmThick for aesthetics
mainHeight = 30; // ^ ditto for hingeArmWidth
mainHeightTaper = 20;
mainHeightTaperAt = 12;
mainHeightTaperTo = mainHeightTaperAt + 15;
mountPlateWidth = 20;
mountPlateHeight = 35;
mountPlateTopWidth = 12;
mountPlateTopHeight = 30;
mountPlateThickness = 3;

// Plate distance sanity check:
if ($preview) #cube([ 50, 10, PLATE_DISTANCE ]);

// Printed as "Skadis IT wall - Door fastener T"
doorFastener(bottom = false);

module doorFastener(top = true, bottom = true) {
  difference() {
    union() {
      // Bottom:
      if (bottom)
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

      translate([ 0, 0, mountPlateThickness ])
      if (top) {
        // Top:
        translate([ 0, 0, (PLATE_DISTANCE - mountPlateThickness) ])
        clipPinned();

        // Tapered part:
        translate([ 0, 0, (PLATE_DISTANCE - mountPlateThickness) / 2 ])
        cube([ mainWidth, mainHeightTaper, (PLATE_DISTANCE - mountPlateThickness) ], center = true);

        // Full width part:
        hull() {
          translate([ 0, 0, mainHeightTaperAt / 2 ])
          cube([ mainWidth, mainHeight, mainHeightTaperAt ], center = true);

          translate([ 0, 0, mainHeightTaperTo / 2 ])
          cube([ mainWidth, mainHeightTaper, mainHeightTaperTo ], center = true);
        }
      }
    }

    // Screw holes:
    rotate([ 0, -90, 0 ])
    #screwHoles();
  }
}
