$fn = $preview ? 35 : 75;

holeD = 20;
innerD = 34.5;
wallThickness = 3;
height = 50 - innerD / 2;

difference() {
  union() {
    cylinder(h = height, d = innerD + wallThickness * 2);

    translate([ 0, 0, height ])
    sphere(d = innerD + wallThickness * 2);
  }

  cylinder(h = height, d = innerD);

  translate([ 0, 0, height ])
  sphere(d = innerD);

  cylinder(h = height + innerD, d = holeD);
}
