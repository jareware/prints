$fn = $preview ? 50 : 100;

use <../lib/roundedCube.scad>

mainThickness = 5;
mainR = mainThickness * .65;
railY = 15;
railZ = 22;
railTopClearance = 14;
hookRaise = 5;
hookExtend = 25;
hookGrooveR = 6;
hookGrooveY = 3;
hookGrooveZ = -1;

difference() {
  union() {
    roundedCube(railTopClearance, railY + mainThickness * 2, railZ + mainThickness, r = mainR);
   
    hull() {
      translate([ 0, 0, hookRaise ]) 
      roundedCube(railTopClearance, railY + mainThickness * 2, railZ + mainThickness - hookRaise, r = mainR);

      translate([ 0, -hookExtend, railZ - mainR * 2 + mainThickness ])
      roundedCube(railTopClearance, hookExtend, mainR * 2, r = mainR);
    }
  }

  translate([ 0, mainThickness, 0 ])
  #cube([ railTopClearance, railY, railZ ]);

  translate([ 0, -hookExtend + hookGrooveR + mainR + hookGrooveY, railZ + mainThickness + hookGrooveZ ])
  rotate([ 0, 90, 0 ])
  #cylinder(h = railTopClearance, r = hookGrooveR);
}

