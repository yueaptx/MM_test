//+
//block

// Include "block.dat";

/*
// Define the 2D-geometry
Point(<pointNr>) = {<x>, <y>, <z>, <cellSize>};
Line(<lineNr>) = {<startPointNr>, <endPointNr>};
Line Loop(<lineLoopNr>) = {(+/-)<lineNr1>, (+/-)<lineNr2>, ...};
Plane Surface(<surfaceNr>) = {<lineLoopNr>};

// Extrude the surface
surfaceVector[] = Extrude {<x>, <y>, <z>} 
{
Surface{<surfaceNr>};
Layers{1};          // create only one layer of elements in the direction of extrusion
Recombine;          // recombine triangular mesh to quadrangular mesh
};        

// Define physicals for later use as boundaries
Physical Surface("<boundaryName>") = {<surfaceNr>}
Physical Surface("<boundaryName>") = surfaceVector[<integerAsShownAbove>];
Physical Volume("<interiorName>") = surfaceVector[1];
*/

// Define variables for your parametric mesh 
squareSide = 2e-6; //m
layerNum = 8;
meshThickness = squareSide / layerNum; 
gridsize = squareSide / layerNum;
 
// All numbering counterclockwise from bottom-left corner
Point(1) = {-squareSide/2, -squareSide/2, -squareSide/2, gridsize};

Extrude {squareSide,0,0} {Point{1}; Layers{layerNum};}

Extrude {0,squareSide,0} {Line{1}; Layers{layerNum};}

Extrude {0,0,squareSide} {Surface{5}; Layers{layerNum};}
    

/* surfaceVector contains in the following order:
[0] - front surface (opposed to source surface)
[1] - extruded volume
[2] - bottom surface (belonging to 1st line in "Line Loop (6)")
[3] - right surface (belonging to 2nd line in "Line Loop (6)")
[4] - top surface (belonging to 3rd line in "Line Loop (6)")
[5] - left surface (belonging to 4th line in "Line Loop (6)") */

/*
Physical Surface("front") = surfaceVector[0];
Physical Volume("internal") = surfaceVector[1];
Physical Surface("bottom") = surfaceVector[2];
Physical Surface("right") = surfaceVector[3];
Physical Surface("top") = surfaceVector[4];
Physical Surface("left") = surfaceVector[5];
Physical Surface("back") = {6}; // from Plane Surface (6) ...
*/
    
/* On my PC, the file must end with a free line to avoid errors which might come from different control characters in UNIX, Mac and Windows! Just to be save, insert one line below this comment!*/


Physical Surface("bottom") = {5};
Physical Surface("top") = {27};
Physical Surface("front") = {18};
Physical Surface("back") = {26};
Physical Surface("left") = {14};
Physical Surface("right") = {22};
