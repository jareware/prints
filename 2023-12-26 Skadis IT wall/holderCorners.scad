$fn = $preview ? 50 : 75;

include <const.scad>
use <clipPinned.scad>
use <../lib/roundedCube.scad>

clipX = 5;
clipY = 15;
clipDistanceX = 40;
clipDistanceY = 20 * 2; // because only every other row works for us here
clipCenterBy = 10;
thickness = 3;
rounding = 3;

// Printed as "..."
holderCorners(158 + 0, 100 + 0, 29);

module holderCorners(
  contentX,
  contentY,
  contentZ,
  cornerCoverage = 20,
  bandWidth = 5,
  clipHideX = 10,
  clipHideY = 10,
) {
  clipDistX = round((contentX - clipHideX) / clipDistanceX) * clipDistanceX;
  clipDistY = round((contentY - clipHideY) / clipDistanceY) * clipDistanceY;
  clipOffsetX = (contentX - clipDistX) / 2;
  clipOffsetY = (contentY - clipDistY) / 2;

  // Sanity check content:
  %cube([ contentX, contentY, contentZ ]);

  // Sanity check clip distance:
  translate([ clipOffsetX, clipOffsetY, -thickness ])
  #cube([ clipDistanceX * 3, 1, 10 ]);
  translate([ clipOffsetX, clipOffsetY, -thickness ])
  #cube([ 1, clipDistanceY * 2, 10 ]);

  // Bottom left:

  holderCorner(contentX, contentY, contentZ, cornerCoverage, bandWidth);

  translate([ clipOffsetX, clipOffsetY, -thickness ])
  rotate([ 0, 180, 0 ])
  clipPinned();

  // Bottom right:

  translate([ contentX, 0, 0 ])
  rotate([ 0, 0, 90 ])
  holderCorner(contentX, contentY, contentZ, cornerCoverage, bandWidth);

  translate([ clipOffsetX + clipDistX, clipOffsetY, -thickness ])
  rotate([ 0, 180, 0 ])
  clipPinned();

  // Top left:

  translate([ 0, contentY, 0 ])
  rotate([ 0, 0, -90 ])
  holderCorner(contentX, contentY, contentZ, cornerCoverage, bandWidth);

  translate([ clipOffsetX, clipOffsetY + clipDistY, -thickness ])
  rotate([ 0, 180, 0 ])
  clipPinned();

  // Top right:

  translate([ contentX, contentY, 0 ])
  rotate([ 0, 0, 180 ])
  holderCorner(contentX, contentY, contentZ, cornerCoverage, bandWidth);

  translate([ clipOffsetX + clipDistX, clipOffsetY + clipDistY, -thickness ])
  rotate([ 0, 180, 0 ])
  clipPinned();
}

module holderCorner(
  contentX,
  contentY,
  contentZ,
  cornerCoverage,
  bandWidth,
) {
  difference() {
    intersection() {
      translate([ -thickness, -thickness, -thickness ])
      roundedCube(cornerCoverage, cornerCoverage, contentZ + thickness * 2, r = rounding, flatRight = true, flatBack = true);

      translate([ -thickness, -thickness, -thickness ])
      cylinder(r = cornerCoverage, h = contentZ + thickness * 2);
    }

    cube([ contentX, contentY, contentZ ]);

    translate([ -thickness, -thickness, -thickness ])
    cylinder(r = cornerCoverage - bandWidth, h = contentZ + thickness * 2);
  }
}
