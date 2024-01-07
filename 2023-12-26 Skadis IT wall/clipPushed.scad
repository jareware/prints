$fn = $preview ? 25 : 75;

magic = 0.01;
clipX = 5;
clipY = 15;
clipH = 5.3; // i.e. IKEA plate thickness
clipToothR = .85;
clipToothH = 1.5;
clipSplit1 = 2.2;
clipSplit2 = 3.5;
clipZRound = 1.65;
clipTopExtra1 = 1;
clipTopExtra2 = 3;

// Sample:
translate([ -5, -10, -4 ])
cube([ 10, 20, 4 ]);
clipPushed();

module clipPushed() {
  color("Chocolate") // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#color
  difference() {
    union() {
      clipPushedLayer(clipH, 0); // main body
      hull() { // top extra
        translate([ 0, 0, clipH ]) clipPushedLayer(clipTopExtra1);
        translate([ 0, 0, clipH + clipTopExtra1 ]) clipPushedLayer(clipTopExtra2, -clipToothR);
      }
      hull() { // root
        translate([ 0, 0, 0 ]) clipPushedLayer(magic);
        translate([ 0, 0, clipZRound ]) clipPushedLayer(magic, 0);
      }
      hull() { // opposite
        translate([ 0, 0, clipH - clipZRound ]) clipPushedLayer(magic, 0);
        translate([ 0, 0, clipH ]) clipPushedLayer(magic);
      }
    }
    hull() { // split space
      translate([ clipSplit1 / -2, clipY / -2, 0 ])
      cube([ clipSplit1, clipY, magic ]);
      translate([ clipSplit2 / -2, clipY / -2, clipH + clipTopExtra1 + clipTopExtra2 ])
      cube([ clipSplit2, clipY, magic ]);
    }
  }
}

module clipPushedLayer(layerH = clipH, extraX = clipToothR) {
  hull() {
    translate([ 0, (clipY - clipX) / 2 - extraX, 0 ])
    cylinder(d = clipX + extraX * 2, h = layerH);
    translate([ 0, (clipY - clipX) / -2 + extraX, 0 ])
    cylinder(d = clipX + extraX * 2, h = layerH);
  }
}
