$fn = $preview ? 35 : 75;

screwDriverD = 10 + 2;

// Example:
translate([ 0 * 15, 0, 0 ]) screwHole("4.0 x 40 pan head countersunk");
translate([ 1 * 15, 0, 0 ]) screwHole("3.5 x 20 countersunk");
translate([ 2 * 15, 0, 0 ]) screwHole("3.5 x 15 countersunk");

// @see https://cadsetterout.com/resources/wood-screw-head-types/
module screwHole(
  kind,
  screwHeadSpace = 15,
  screwDriverSpace = 100,
) {
  if (kind == "4.0 x 40 pan head countersunk") {
    d = 2.8;
    h = 40;
    head = 8 + 1;

    cylinder(d = d, h = h);

    translate([ 0, 0, h - 1.5 ])
    cylinder(d1 = d, d2 = 4.4, h = 1.5); // countersunk cone

    translate([ 0, 0, h ])
    screwHoleAccess(head, screwHeadSpace, screwDriverSpace);
  }

  if (kind == "3.5 x 20 countersunk") {
    d = 2.6;
    h = 16;
    head = 6.85 + 1;

    cylinder(d = d, h = h);

    translate([ 0, 0, h ])
    cylinder(d1 = d, d2 = 3.4, h = 1.5); // 1st countersunk cone

    translate([ 0, 0, h + 1.5 ])
    cylinder(d1 = 3.4, d2 = head, h = 1.8); // 2nd countersunk cone

    translate([ 0, 0, h + 1.5 + 1.8 ])
    screwHoleAccess(head, screwHeadSpace, screwDriverSpace);
  }

  if (kind == "3.5 x 15 countersunk") {
    d = 2.6;
    h = 11;
    head = 6.85 + 1;

    cylinder(d = d, h = h);

    translate([ 0, 0, h ])
    cylinder(d1 = d, d2 = 3.4, h = 1.5); // 1st countersunk cone

    translate([ 0, 0, h + 1.5 ])
    cylinder(d1 = 3.4, d2 = head, h = 1.8); // 2nd countersunk cone

    translate([ 0, 0, h + 1.5 + 1.8 ])
    screwHoleAccess(head, screwHeadSpace, screwDriverSpace);
  }
}

module screwHoleAccess(
  head,
  screwHeadSpace,
  screwDriverSpace,
) {
  transition = 3;
  cylinder(d = head, h = screwHeadSpace);
  translate([ 0, 0, screwHeadSpace - transition ])
  cylinder(d1 = head, d2 = screwDriverD, h = transition); // this is purely for aesthetics
  translate([ 0, 0, screwHeadSpace ])
  cylinder(d = screwDriverD, h = screwDriverSpace);
}
