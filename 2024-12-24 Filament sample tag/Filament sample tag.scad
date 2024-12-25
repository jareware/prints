$fn = $preview ? 50 : 100;

use <../lib/roundedCube.scad>;

magic = 0.01;
plateWidth = 80;
plateHeight = 40;
plateThickness = 1.5;
plateRounding = 5;
borderSize = 1.25;
borderThickness = 1;
textThickness = 1;
textSize = 4;
textPaddingLeft = 4;
textPaddingBottom = 4;
textLineSpacing = 3;
holeDiameter = 10;

filamentSampleTag([
  "Galaxy Black",
  "Prusament PLA",
  "Man:2024-09-23",
]);

module filamentSampleTag(textLines) {
  difference() {
    roundedCube(plateWidth, plateHeight, plateThickness + borderThickness, plateRounding, flatTop = true, flatBottom = true, centerX = true, centerY = true);

    // Border
    translate([ 0, 0, plateThickness + magic ])
    roundedCube(plateWidth - borderSize * 2, plateHeight - borderSize * 2, borderThickness, plateRounding * .85, flatTop = true, flatBottom = true, centerX = true, centerY = true);

    // Hole
    translate([ plateWidth / 2 - borderSize - textPaddingLeft - holeDiameter / 2, plateHeight / 2 - borderSize - textPaddingBottom - holeDiameter / 2, -magic ])
    cylinder(h = plateThickness + magic * 3, d = holeDiameter);
  }

  // Text
  color("blue")
  for (i = [0 : len(textLines) - 1]) {
    translate([
      -plateWidth / 2 + borderSize + textPaddingLeft,
      -plateHeight / 2 + borderSize + textPaddingBottom + (len(textLines) - 1 - i) * (textSize + textLineSpacing),
      plateThickness
    ])
    linear_extrude(height = textThickness)
    text(textLines[i], size = textSize, valign = "baseline", halign = "left", font = "Liberation Mono:style=Bold");
  }
}
