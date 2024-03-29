// Example:
roundedCube(
  x = 30,
  y = 20,
  z = 10,
  r = 3,
  flatBottom = true,
  centerX = true,
  centerY = true
);

module roundedCube(
  x,
  y,
  z,
  r = 0,
  flatTop = false,
  flatBottom = false,
  flatLeft = false,
  flatRight = false,
  flatFront = false,
  flatBack = false,
  centerX = false,
  centerY = false,
  centerZ = false
) {
  // Calculate [ x, y, z ] compensations based on requested flattenings:
  rX = r * (flatLeft && flatRight ? 0 : (flatLeft || flatRight ? 1 : 2));
  rY = r * (flatFront && flatBack ? 0 : (flatFront || flatBack ? 1 : 2));
  rZ = r * (flatTop && flatBottom ? 0 : (flatTop || flatBottom ? 1 : 2));

  // Do some sanity checks:
  assert(x - rX >= 0, "roundedCube() is too small along its x-axis");
  assert(y - rY >= 0, "roundedCube() is too small along its y-axis");
  assert(z - rZ >= 0, "roundedCube() is too small along its z-axis");

  translate([ centerX ? x / -2 : 0, centerY ? y / -2 : 0, centerZ ? z / -2 : 0 ])
  if (r == 0) {
    // If there's no rounding, it's just a regular cube:
    cube([ x, y, z ]);
  } else {
    difference() {
      // Main rounded cube:
      translate([
        flatLeft ? 0 : r,
        flatFront ? 0 : r,
        flatBottom ? 0 : r
      ])
      hull() {
        for (i = [ 0, z - rZ ]) {
          translate([ 0, 0, i ]) sphere(r = r);
          translate([ x - rX, 0, i ]) sphere(r = r);
          translate([ 0, y - rY, i ]) sphere(r = r);
          translate([ x - rX, y - rY, i ]) sphere(r = r);
        }
      }

      // Optional cutouts:
      if (flatTop) {
        translate([ x / -2, y / -2, z ])
        cube([ x * 2, y * 2, r ]);
      }
      if (flatBottom) {
        translate([ x / -2, y / -2, -r ])
        cube([ x * 2, y * 2, r ]);
      }
      if (flatLeft) {
        translate([ -r, y / -2, z / -2 ])
        cube([ r, y * 2, z * 2 ]);
      }
      if (flatRight) {
        translate([ x, y / -2, z / -2 ])
        cube([ r, y * 2, z * 2 ]);
      }
      if (flatFront) {
        translate([ x / -2, -r, z / -2 ])
        cube([ x * 2, r, z * 2 ]);
      }
      if (flatBack) {
        translate([ x / -2, y, z / -2 ])
        cube([ x * 2, r, z * 2 ]);
      }
    }
  }
}
