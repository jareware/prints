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
    #content();

    // Embed for inserting top:
    translate([ 0, 0, wallBottom + deckZ - deckTopExpose - embedBottomZ + magic ])
    roundedCube(embedBottomX, deckY + embedBottom * 2, embedBottomZ, r = minorR, flatTop = true, centerX = true, centerY = true);
    translate([ 0, 0, wallBottom + deckZ - deckTopExpose - embedBottomZ + magic ])
    roundedCube(deckX + embedBottom * 2, embedBottomY, embedBottomZ, r = minorR, flatTop = true, centerX = true, centerY = true);
  }
}

module top() {
  difference() {
    // Main body:
    translate([ 0, 0, wallBottom + deckZ - deckTopExpose ])
    roundedCube(deckX + wallSide * 2, deckY + wallSide * 2, deckTopExpose + matchboxZ + wallTop, r = mainR, flatBottom = true, centerX = true, centerY = true);

    // Space for content:
    content();

    // TODO: Clips
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
