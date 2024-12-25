$fn = $preview ? 50 : 100;

use <../lib/roundedCube.scad>;

magic = 0.01;
plateWidth = 80;
plateHeight = 40;
plateThickness = 2;
plateRounding = 5;
borderThickness = 1.25;
borderHeight = 1;
textDepth = 1;
textSize = 4;
textPaddingLeft = 4;
textPaddingBottom = 4;
textLineSpacing = 3;
holeDiameter = 10;

filamentSampleTag(["Prusament PLA", "Galaxy Black"]);

module flatPlateWithRoundedCorners(x, y, z, r) {
  roundedCube(
    x = x,
    y = y,
    z = z,
    r = r,
    flatTop = true,
    flatBottom = true,
    centerX = true,
    centerY = true
  );
}

module filamentSampleTag(textLines) {
  difference() {
    roundedCube(plateWidth, plateHeight, plateThickness + borderThickness, plateRounding, flatTop = true, flatBottom = true, centerX = true, centerY = true);

    // Border
    translate([ 0, 0, plateThickness + magic ])
    roundedCube(plateWidth - borderThickness * 2, plateHeight - borderThickness * 2, borderThickness, plateRounding, flatTop = true, flatBottom = true, centerX = true, centerY = true);

    // Text
    for (i = [0 : len(textLines) - 1]) {
      translate([ -plateWidth / 2 + borderThickness + textPaddingLeft, -plateHeight / 2 + borderThickness + textPaddingBottom + (len(textLines) - 1 - i) * (textSize + textLineSpacing), plateThickness - textDepth ])
      linear_extrude(height = textDepth * 2)
      text(textLines[i], size = textSize, valign = "baseline", halign = "left", font = "Liberation Mono:style=Bold");
    }

    // Hole
    translate([ -plateWidth / 2 + borderThickness + textPaddingLeft + holeDiameter / 2, plateHeight / 2 - borderThickness - textPaddingBottom - holeDiameter / 2, -magic ])
    cylinder(h = plateThickness + borderThickness + magic, d = holeDiameter);
  }
}
