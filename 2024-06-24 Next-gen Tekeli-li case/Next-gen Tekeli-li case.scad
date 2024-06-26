$fn = $preview ? 25 : 100;

use <../lib/roundedCube.scad>

magic = 0.01;
mainR = 10;
minorR = 1;
deckX = 67;
deckY = 27;
deckZ = 93.5;
matchboxX = 53;
matchboxY = 15.5;
matchboxZ = 37;
deckTopExpose = 12;
wallBottom = 5;
wallTop = 5;
wallSide = 5;
embedBottom = 2.5;
embedBottomX = deckX - 15;
embedBottomY = deckY - 10;
embedBottomZ = 10;

bottom();
translate([ 0, 0, 30 ]) // i.e. how much to open
top();

module bottom() {
  difference() {
    // Main body:
    roundedCube(deckX + wallSide * 2, deckY + wallSide * 2, deckZ + wallBottom - deckTopExpose, r = mainR, flatTop = true, centerX = true, centerY = true);

    // Space for content:
    content();

    // Space for clip from top:
    clip();
  }
}

module top() {
  difference() {
    // Main body:
    translate([ 0, 0, wallBottom + deckZ - deckTopExpose ])
    roundedCube(deckX + wallSide * 2, deckY + wallSide * 2, deckTopExpose + matchboxZ + wallTop, r = mainR, flatBottom = true, centerX = true, centerY = true);

    // Space for content:
    content();
  }

  // Embed for clipping into bottom:
  difference() {
    clip();

    hull() {
      translate([ 0, 0, wallBottom + deckZ - deckTopExpose + magic ])
      cube([ deckX, deckY, magic ], center = true);

      translate([ 0, 0, wallBottom + deckZ - deckTopExpose - embedBottomZ ])
      cube([ deckX + (embedBottom - minorR) * 2, deckY + (embedBottom - minorR) * 2, magic ], center = true);
    }
  }
}

module content() {
  // Space for deck:
  translate([ 0, 0, wallBottom ])
  roundedCube(deckX, deckY, deckZ, r = minorR, centerX = true, centerY = true);

  // Space for matchbox:
  translate([ 0, 0, wallBottom + deckZ - magic ])
  roundedCube(matchboxX, matchboxY, matchboxZ, r = minorR, centerX = true, centerY = true, flatBottom = true);
}

module clip(tolerance = 0) {
  translate([ 0, 0, wallBottom + deckZ - deckTopExpose - embedBottomZ + magic + tolerance ])
  #roundedCube(embedBottomX, deckY + (embedBottom - tolerance) * 2, embedBottomZ - tolerance, r = minorR, flatTop = true, centerX = true, centerY = true);
  translate([ 0, 0, wallBottom + deckZ - deckTopExpose - embedBottomZ + magic + tolerance ])
  #roundedCube(deckX + (embedBottom - tolerance) * 2, embedBottomY, embedBottomZ - tolerance, r = minorR, flatTop = true, centerX = true, centerY = true);
}
