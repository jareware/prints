$fn = $preview ? 35 : 75;

difference() {
  union() {
    cylinder(h = 21, d = 6.5);

    translate([ 0, 0, 21 ])
    sphere(d = 6.5);
  }

  cylinder(h = 21, d = 4.75);
}
