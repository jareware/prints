$fn = $preview ? 25 : 100;

use <../lib/roundedCube.scad>

magic = 0.01;
mainR = 10;
minorR = 1.5;
deckX = 67 + 2;
deckY = 27;
deckZ = 93.5;
matchboxX = 53 + 2;
matchboxY = 15.5 + 1;
matchboxZ = 16;
deckTopExpose = 0;
wallBottom = 5;
wallTop = 5;
wallSide = 5;
embedBottom = 3.5;
embedBottomX = deckX - 15;
embedBottomY = deckY - 10;
embedBottomZ = 20;
embedLockBump = 1.2;

bottom();
translate([ -15, 0, 30 ]) // i.e. how much to open
top2Left();
translate([ 15, 0, 30 ]) // i.e. how much to open
top2Right();

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
  }

  // Embed for clipping into bottom:
  difference() {
    clip(tolerance = .3);

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
  translate([ 0, 0, wallBottom + deckZ - deckTopExpose - embedBottomZ + magic + tolerance ]) {
    // X:
    roundedCube(deckX + (embedBottom - tolerance) * 2, embedBottomY - tolerance * 2, embedBottomZ - tolerance, r = minorR, flatTop = true, centerX = true, centerY = true);

    // Y:
    roundedCube(embedBottomX - tolerance * 2, deckY + (embedBottom - tolerance) * 2, embedBottomZ - tolerance, r = minorR, flatTop = true, centerX = true, centerY = true);

    // Bump:
    t = max(tolerance, 0);
    for (i = [-1, 1])
    translate([ (deckX / 2 + embedBottom - tolerance - embedLockBump * 1/3) * i, embedBottomY / 2 - minorR - t, embedBottomZ / 2 - tolerance ])
    rotate([ 90, 0, 0 ])
    cylinder(h = embedBottomY - minorR * 2 - t * 2, r = embedLockBump);
  }
}

d1 = 18;
d2 = 17;
wall = 2;

plugD = 7;
plugX = 20;
halvesTol = .25;

module top2Right() {
  plugTol = 0; // the holes are exactly sized

  difference() {
    intersection() {
      top();
      translate([ halvesTol, -50, 50 ])
      cube([100, 100, 100]);
    }

    translate([ 0, 0, wallBottom + deckZ - deckTopExpose ]) {
      // %translate([ matchboxX / -2, 0, d1 / 2 + wall ])
      // rotate([ 0, 90, 0 ])
      // resize([ d1, d2, matchboxX ])
      // cylinder(h = matchboxX, d = 1);

      translate([ 0, 0, wall ])
      roundedCube(matchboxX, d1, d2, r = minorR, centerX = true, centerY = true);

      for (j = [-1, 1])
      hull() {
        for (i = [-1, 1])
        translate([ plugX * i, 14 * j, matchboxZ / 2 + 2 ])
        sphere(d = plugD - plugTol);
      }
    }
  }
}

module top2Left() {
  plugTol = .7; // shrink the plugs by a bit

  difference() {
    intersection() {
      top();
      translate([ -100 - halvesTol, -50, 50 ])
      cube([100, 100, 100]);
    }

    translate([ 0, 0, wallBottom + deckZ - deckTopExpose ]) {
      // translate([ matchboxX / -2, 0, d1 / 2 + wall ])
      // rotate([ 0, 90, 0 ])
      // resize([ d1, d2, matchboxX ])
      // cylinder(h = matchboxX, d = 1);

      translate([ 0, 0, wall ])
      roundedCube(matchboxX, d1, d2, r = minorR, centerX = true, centerY = true);
    }
  }

  translate([ 0, 0, wallBottom + deckZ - deckTopExpose ]) {
    for (j = [-1, 1])
    hull() {
      for (i = [-1, 1])
      translate([ plugX * i, 14 * j, matchboxZ / 2 + 2 ])
      sphere(d = plugD - plugTol);
    }
  }
}
