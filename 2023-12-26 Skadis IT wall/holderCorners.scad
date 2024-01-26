$fn = $preview ? 50 : 75;

include <const.scad>
use <clipPinned.scad>
use <../lib/roundedCube.scad>

clipX = 5;
clipY = 15;
clipDistanceX = 40;
clipDistanceY = 20 * 2; // because only every other row works for us here
thickness = 3;
rounding = 3;

// holderCorners(204, 158, 18.5); // TP-Link WiFi AP
// holderCorners(158, 102, 29.5 /* with pads */, clipPlateX = 14, clipPlateY = 28); // NetGear switch
holderCorners(110, 57.5, 39, cornerCoverage = 10, clipPlateY = 23.5); // TP-Link WiFi AP power

module holderCorners(
  contentX,
  contentY,
  contentZ,
  cornerCoverage = 18,
  clipHideX = 0,
  clipHideY = 0,
  clipPlateX = clipX + 5,
  clipPlateY = clipY + 5,
  printLayout = true,
  printPackX = 8,
  printPackY = 1,
  printInterleave = true,
) {
  if (printLayout) {
    rotate([ 90, 0, 0 ])
    holderCornerAssembly("BL", contentX, contentY, contentZ, cornerCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    rotate([ 90, 0, 0 ])
    translate([ -printPackX, 0, 0 ])
    holderCornerAssembly("BR", contentX, contentY, contentZ, cornerCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    translate(printInterleave ? [ clipX + 1, -15, 0 ] : [ 0, 0, 0 ])
    translate([ 0, 35 + printPackY, 0 ])
    rotate([ -90, 0, 0 ])
    holderCornerAssembly("TL", contentX, contentY, contentZ, cornerCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    translate(printInterleave ? [ clipX + 1, -15, 0 ] : [ 0, 0, 0 ])
    translate([ -printPackX, 35 + printPackY, 0 ])
    rotate([ -90, 0, 0 ])
    holderCornerAssembly("TR", contentX, contentY, contentZ, cornerCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);
  } else {
    // Sanity check content:
    if ($preview) %cube([ contentX, contentY, contentZ ]);

    // Sanity check against grid:
    if ($preview) {
      for (x = [0:10])
      for (y = [0:10])
      translate([
        clipX / -2 + clipDistanceX * (x - 3) + 2,
        clipY / -2 + clipDistanceY * (y - 3) - 21,
        -20
      ])
      #cube([ clipX, clipY, MAGIC ]);
    }

    holderCornerAssembly("BL", contentX, contentY, contentZ, cornerCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    translate([ contentX, 0, 0 ])
    holderCornerAssembly("BR", contentX, contentY, contentZ, cornerCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    translate([ 0, contentY, 0 ])
    holderCornerAssembly("TL", contentX, contentY, contentZ, cornerCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    translate([ contentX, contentY, 0 ])
    holderCornerAssembly("TR", contentX, contentY, contentZ, cornerCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);
  }
}

module holderCornerAssembly(
  which = "",
  contentX,
  contentY,
  contentZ,
  cornerCoverage,
  clipHideX,
  clipHideY,
  clipPlateX,
  clipPlateY,
) {
  clipDistX = floor((contentX - clipHideX) / clipDistanceX) * clipDistanceX;
  clipDistY = floor((contentY - clipHideY) / clipDistanceY) * clipDistanceY;
  clipOffsetX = (contentX - clipDistX) / 2;
  clipOffsetY = (contentY - clipDistY) / 2;

  difference() {
    mirror(which == "TR" ? [ 1, 0, 0 ] : [ 0, 0, 0 ])
    mirror(which == "BL" ? [ 0, 0, 0 ] : which == "BR" ? [ 1, 0, 0 ] : [ 0, 1, 0 ])
    union() {
      holderCornerAngled(contentX, contentY, contentZ, cornerCoverage);

      translate([ clipOffsetX, clipOffsetY, -thickness ])
      rotate([ 0, 180, 0 ])
      clipPinned();

      hull() {
        intersection() {
          translate([ 0, 0, -thickness ])
          cube([ cornerCoverage - thickness, cornerCoverage - thickness, thickness ]);

          holderCornerAngled(contentX, contentY, contentZ, cornerCoverage);
        }

        translate([ clipOffsetX, clipOffsetY, -thickness ])
        roundedCube(clipPlateX, clipPlateY, thickness, r = rounding, flatTop = true, flatBottom = true, centerX = true, centerY = true);
      }
    }

    translate([
      clipOffsetX * (which == "TL" || which == "BL" ? 1 : -1) * .75,
      clipOffsetY * (which == "TL" || which == "TR" ? -1 : 1) * .5,
      -.35
    ])
    scale([ .4, .4, 1 ])
    linear_extrude(1)
    text(which, halign="center", valign="center");

    // TEMP: Only for TP-Link WiFi AP power
    if (which == "BR")
    rotate([ 0, 90, 0 ])
    translate([ -23.7, 20, -30 ])
    cylinder(h = 50, d = 40);
  }
}

module holderCornerCurved(
  contentX,
  contentY,
  contentZ,
  cornerCoverage,
  bandWidth = 5,
) {
  difference() {
    intersection() {
      translate([ -thickness, -thickness, -thickness ])
      roundedCube(cornerCoverage, cornerCoverage, contentZ + thickness * 2, r = rounding, flatRight = true, flatBack = true, flatBottom = true);

      translate([ -thickness, -thickness, -thickness ])
      cylinder(r = cornerCoverage, h = contentZ + thickness * 2);
    }

    // Remove space for content:
    cube([ contentX, contentY, contentZ ]);

    translate([ -thickness, -thickness, 0 ])
    cylinder(r = cornerCoverage - bandWidth, h = contentZ + thickness * 2);
  }
}

module holderCornerAngled(
  contentX,
  contentY,
  contentZ,
  cornerCoverage,
) {
  difference() {
    translate([ -thickness, -thickness, -thickness ])
    roundedCube(cornerCoverage, cornerCoverage, contentZ + thickness * 2, r = rounding, flatRight = true, flatBack = true, flatBottom = true);

    // Remove space for content:
    cube([ cornerCoverage, cornerCoverage, contentZ ]);

    // Remove angled bit:
    translate([ cornerCoverage - thickness, 0, 0 ])
    rotate([ 0, 0, 45 ])
    cube([ cornerCoverage * 2, cornerCoverage * 2, contentZ * 2 ]);
  }
}
