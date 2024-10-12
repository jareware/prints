$fn = $preview ? 50 : 100;

slotCount = 5;
baseD = 25;
baseZ = 4;
spireD = 10;
spireHeight = 50;
spireDistance = 10;

for (i = [0:slotCount]) {
  translate([ i * (spireD + spireDistance), 0, 0 ]) {
    hull() {
      #cylinder(h = baseZ, d = spireD);

      translate([ 0, 0, spireHeight ])
      sphere(d = spireD);
    }
  }
}

// Base
hull() {
  cylinder(h = baseZ, d = baseD);
  translate([ slotCount * (spireD + spireDistance), 0, 0 ])
  cylinder(h = baseZ, d = baseD);
}
