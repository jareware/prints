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
tolerance = .4;
holderHeight = 40;
holderSize = 32;
holderBottomThickness = plateThickness + borderThickness;

!filamentSampleTag([
  "Vanilla White",
  "Prusament PLA",
  "Man:2024-07-27",
]);

translate([ 0, 0, -holderBottomThickness - tolerance ])
filamentSampleTagHolder();

module filamentSampleTag(textLines) {
  difference() {
    // Base plate
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

module filamentSampleTagHolder() {
  holePosition = [ plateWidth / 2 - borderSize - textPaddingLeft - holeDiameter / 2, plateHeight / 2 - borderSize - textPaddingBottom - holeDiameter / 2, 0 ];

  // Pole
  translate(holePosition)
  hull() {
    cylinder(h = magic, d = holeDiameter - tolerance * 2);

    translate([ 0, 0, holderHeight ])
    sphere(d = holeDiameter - tolerance * 2);
  }

  // Outer holder
  difference() {
    translate(holePosition)
    roundedCube(holderSize, holderSize, holderHeight, plateRounding * 1.25, flatBottom = true, centerX = true, centerY = true);

    // Remove space: Base plate
    translate([ 0, 0, holderBottomThickness ])
    roundedCube(plateWidth + tolerance * 2, plateHeight + tolerance * 2, 100, plateRounding, flatTop = true, flatBottom = true, centerX = true, centerY = true);
  }

  // Bottom plate
  roundedCube(plateWidth, plateHeight, holderBottomThickness, plateRounding, flatTop = true, flatBottom = true, centerX = true, centerY = true);
}
