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
holderCorners(102, 158, 29.5 /* with pads */, printPackX2 = 4 /* slicer weirdness */); // NetGear switch
// holderCorners(110, 57.5, 39, cornerCoverage = 10, clipPlateY = 23.5); // TP-Link WiFi AP power
// holderCorners(60, 97, 16, cornerCoverage = 5.5, extraTopCoverage = 3.5); // TI LAUNCHXL-CC26X2R1 Zigbee controller
// holderCorners(57, 85.5, 4, cornerCoverage = 2.5, extraTopCoverage = 5, clipHideY = 10, clipPlateY = 17, clipPlateX = 7); // Raspberry Pi 4
// holderCorners(112, 116, 51, cornerCoverage = 14); // Intel NUC

module holderCorners(
  contentX,
  contentY,
  contentZ,
  cornerCoverage = 18,
  extraTopCoverage = 0,
  clipHideX = 0,
  clipHideY = 0,
  clipPlateX = 10,
  clipPlateY = 20,
  printLayout = true,
  printPackX1 = 8,
  printPackX2 = 1,
  printPackY = 1,
  printInterleave = true,
) {
  if (printLayout) {
    rotate([ 90, 0, 0 ])
    holderCornerAssembly("BL", contentX, contentY, contentZ, cornerCoverage, extraTopCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    rotate([ 90, 0, 0 ])
    translate([ -printPackX1, 0, 0 ])
    holderCornerAssembly("BR", contentX, contentY, contentZ, cornerCoverage, extraTopCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    translate(printInterleave ? [ clipX + printPackX2, -15, 0 ] : [ 0, 0, 0 ])
    translate([ 0, 35 + printPackY, 0 ])
    rotate([ -90, 0, 0 ])
    holderCornerAssembly("TL", contentX, contentY, contentZ, cornerCoverage, extraTopCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    translate(printInterleave ? [ clipX + printPackX2, -15, 0 ] : [ 0, 0, 0 ])
    translate([ -printPackX1, 35 + printPackY, 0 ])
    rotate([ -90, 0, 0 ])
    holderCornerAssembly("TR", contentX, contentY, contentZ, cornerCoverage, extraTopCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);
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

    holderCornerAssembly("BL", contentX, contentY, contentZ, cornerCoverage, extraTopCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    translate([ contentX, 0, 0 ])
    holderCornerAssembly("BR", contentX, contentY, contentZ, cornerCoverage, extraTopCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    translate([ 0, contentY, 0 ])
    holderCornerAssembly("TL", contentX, contentY, contentZ, cornerCoverage, extraTopCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);

    translate([ contentX, contentY, 0 ])
    holderCornerAssembly("TR", contentX, contentY, contentZ, cornerCoverage, extraTopCoverage, clipHideX, clipHideY, clipPlateX, clipPlateY);
  }
}

module holderCornerAssembly(
  which = "",
  contentX,
  contentY,
  contentZ,
  cornerCoverage,
  extraTopCoverage,
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
      holderCornerAngled(contentX, contentY, contentZ, cornerCoverage, extraTopCoverage);

      translate([ clipOffsetX, clipOffsetY, -thickness ])
      rotate([ 0, 180, 0 ])
      clipPinned();

      hull() {
        intersection() {
          translate([ 0, 0, -thickness ])
          cube([ cornerCoverage, cornerCoverage, thickness ]);

          holderCornerAngled(contentX, contentY, contentZ, cornerCoverage, extraTopCoverage);
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
  extraTopCoverage,
) {
  difference() {
    translate([ -thickness, -thickness, -thickness ])
    roundedCube(cornerCoverage + thickness, cornerCoverage + thickness, contentZ + thickness * 2, r = rounding, flatRight = true, flatBack = true, flatBottom = true);

    // Remove space for content:
    cube([ cornerCoverage, cornerCoverage, contentZ ]);

    // Remove angled bit:
    translate([ cornerCoverage, extraTopCoverage, extraTopCoverage ])
    rotate([ 0, 0, 45 ])
    cube([ cornerCoverage * 2, cornerCoverage * 2, contentZ * 2 ]);
  }
}
