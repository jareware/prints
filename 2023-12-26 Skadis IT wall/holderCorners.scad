$fn = $preview ? 50 : 75;

include <const.scad>
use <clipPinned.scad>
use <../lib/roundedCube.scad>

clipX = 5;
clipY = 15;
clipDistanceX = 40;
clipDistanceY = 20 * 2; // because only every other row works for us here
clipPlateExtra = 1;
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
  clipHideX = 0,
  clipHideY = 0,
) {
  // Sanity check content:
  %cube([ contentX, contentY, contentZ ]);

  // // Sanity check clip distance:
  // if ($preview) {
  //   translate([ clipOffsetX, clipOffsetY, -10 ])
  //   #cube([ clipDistanceX * 4, 1, 10 ]);
  //   translate([ clipOffsetX, clipOffsetY, -10 ])
  //   #cube([ 1, clipDistanceY * 2, 10 ]);
  // }

  holderCornerAssembly(
    "BL",
    contentZ,
    cornerCoverage,
    bandWidth,
    clipHideX,
    clipHideY
  );

  translate([ contentX, 0, 0 ])
  holderCornerAssembly(
    "BR",
    contentZ,
    cornerCoverage,
    bandWidth,
    clipHideX,
    clipHideY
  );

  translate([ 0, contentY, 0 ])
  holderCornerAssembly(
    "TL",
    contentZ,
    cornerCoverage,
    bandWidth,
    clipHideX,
    clipHideY
  );

  translate([ contentX, contentY, 0 ])
  holderCornerAssembly(
    "TR",
    contentZ,
    cornerCoverage,
    bandWidth,
    clipHideX,
    clipHideY
  );
}

module holderCornerAssembly(
  which = "",
  contentZ,
  cornerCoverage,
  bandWidth,
  clipHideX,
  clipHideY,
) {
  contentX = cornerCoverage;
  contentY = cornerCoverage;
  clipDistX = floor((contentX - clipHideX) / clipDistanceX) * clipDistanceX;
  clipDistY = floor((contentY - clipHideY) / clipDistanceY) * clipDistanceY;
  clipOffsetX = (contentX - clipDistX) / 2;
  clipOffsetY = (contentY - clipDistY) / 2;

  difference() {
    mirror(which == "TR" ? [ 1, 0, 0 ] : [ 0, 0, 0 ])
    mirror(which == "BL" ? [ 0, 0, 0 ] : which == "BR" ? [ 1, 0, 0 ] : [ 0, 1, 0 ])
    union() {
      holderCorner(contentX, contentY, contentZ, cornerCoverage, bandWidth);

      translate([ clipOffsetX, clipOffsetY, -thickness ])
      rotate([ 0, 180, 0 ])
      clipPinned();

      hull() {
        intersection() {
          translate([ -thickness, -thickness, -thickness ])
          cube([ cornerCoverage, cornerCoverage, thickness ]);

          holderCorner(contentX, contentY, contentZ, cornerCoverage, bandWidth);
        }

        translate([ clipOffsetX, clipOffsetY, -thickness ])
        cylinder(d = clipY + clipPlateExtra * 2, h = thickness);
      }
    }

    translate([
      cornerCoverage / (which == "TL" || which == "BL" ? 3 : -3),
      cornerCoverage / (which == "TL" || which == "TR" ? -3 : 3),
      -1
    ])
    linear_extrude(1)
    text(which, halign="center", valign="center");
  }
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
      roundedCube(cornerCoverage, cornerCoverage, contentZ + thickness * 2, r = rounding, flatRight = true, flatBack = true, flatBottom = true);

      translate([ -thickness, -thickness, -thickness ])
      cylinder(r = cornerCoverage, h = contentZ + thickness * 2);
    }

    cube([ contentX, contentY, contentZ ]);

    translate([ -thickness, -thickness, 0 ])
    cylinder(r = cornerCoverage - bandWidth, h = contentZ + thickness * 2);
  }
}
