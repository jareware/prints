$fn = $preview ? 35 : 75;

screwDriverD = 10 + 2;
magic = 0.001;

// Example:
translate([ 0 * 15, 0, 0 ]) screwHole("4.0 x 40 pan head countersunk");
translate([ 1 * 15, 0, 0 ]) screwHole("3.5 x 20 countersunk");
translate([ 2 * 15, 0, 0 ]) screwHole("3.5 x 15 countersunk");

// @see https://cadsetterout.com/resources/wood-screw-head-types/
module screwHole(
  kind,
  screwHeadSpace = 15,
  screwDriverSpace = 100,
  alignedAtHead = true, // as opposed to the tip, or the "sharp end"
) {
  if (kind == "4.0 x 40 pan head countersunk") {
    d = 2.8;
    h = 40;
    head = 8 + 1;

    translate([ 0, 0, alignedAtHead ? -h : 0 ]) {
      cylinder(d = d, h = h + magic);

      translate([ 0, 0, h - 1.5 ])
      cylinder(d1 = d, d2 = 4.4, h = 1.5 + magic); // countersunk cone

      translate([ 0, 0, h ])
      screwHoleAccess(head, screwHeadSpace, screwDriverSpace);
    }
  }

  if (kind == "3.5 x 20 countersunk") {
    d = 2.6;
    h = 16;
    head = 6.85 + 1;

    translate([ 0, 0, alignedAtHead ? -h - 1.5 - 1.8 : 0 ]) {
      cylinder(d = d, h = h + magic);

      translate([ 0, 0, h ])
      cylinder(d1 = d, d2 = 3.4, h = 1.5 + magic); // 1st countersunk cone

      translate([ 0, 0, h + 1.5 ])
      cylinder(d1 = 3.4, d2 = head, h = 1.8 + magic); // 2nd countersunk cone

      translate([ 0, 0, h + 1.5 + 1.8 ])
      screwHoleAccess(head, screwHeadSpace, screwDriverSpace);
    }
  }

  if (kind == "3.5 x 15 countersunk") {
    d = 2.6;
    h = 11;
    head = 6.85 + 1;

    translate([ 0, 0, alignedAtHead ? -h - 1.5 - 1.8 : 0 ]) {
      cylinder(d = d, h = h + magic);

      translate([ 0, 0, h ])
      cylinder(d1 = d, d2 = 3.4, h = 1.5 + magic); // 1st countersunk cone

      translate([ 0, 0, h + 1.5 ])
      cylinder(d1 = 3.4, d2 = head, h = 1.8 + magic); // 2nd countersunk cone

      translate([ 0, 0, h + 1.5 + 1.8 ])
      screwHoleAccess(head, screwHeadSpace, screwDriverSpace);
    }
  }
}

module screwHoleAccess(
  head,
  screwHeadSpace,
  screwDriverSpace,
) {
  transition = 3;

  color("DarkOrange", 0.5)
  cylinder(d = head, h = screwHeadSpace);

  color("DarkKhaki", 0.5)
  translate([ 0, 0, screwHeadSpace - magic ])
  cylinder(d = screwDriverD, h = screwDriverSpace);
}
