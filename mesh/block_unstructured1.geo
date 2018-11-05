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
L = 2e-6; //m
N = 8;
h = L / N; 
 
Point (1) = {-L/2, -L/2, -L/2, h};
Point (2) = {L/2, -L/2, -L/2, h};
Point (3) = {L/2, L/2, -L/2, h};
Point (4) = {-L/2, L/2, -L/2, h};
Point (5) = {-L/2, -L/2, L/2, h};
Point (6) = {L/2, -L/2, L/2, h};
Point (7) = {L/2, L/2, L/2, h};
Point (8) = {-L/2, L/2, L/2, h};
Line (1)  = {1, 2};
Line (2)  = {2, 3};
Line (3)  = {3, 4};
Line (4)  = {4, 1};
Line (5)  = {5, 6};
Line (6)  = {6, 7};
Line (7)  = {7, 8};
Line (8)  = {8, 5};
Line (9)  = {1, 5};
Line (10) = {2, 6};
Line (11) = {3, 7};
Line (12) = {4, 8};

Line Loop(13) = {3, 12, -7, -11};
Plane Surface(4) = {13};
Line Loop(15) = {4, 9, -8, -12};
Plane Surface(1) = {15};
Line Loop(17) = {5, -10, -1, 9};
Plane Surface(3) = {17};
Line Loop(19) = {3, 4, 1, 2};
Plane Surface(5) = {19};
Line Loop(21) = {11, -6, -10, 2};
Plane Surface(2) = {21};
Line Loop(23) = {7, 8, 5, 6};
Plane Surface(6) = {23};
Surface Loop(25) = {4, 5, 1, 3, 6, 2};
Volume(1) = {25};

Physical Line(1) = {1};
Physical Line(2) = {2};
Physical Line(3) = {3};
Physical Line(4) = {4};
Physical Line(5) = {5};
Physical Line(6) = {6};
Physical Line(7) = {7};
Physical Line(8) = {8};
Physical Line(9) = {9};
Physical Line(10) = {10};
Physical Line(11) = {11};
Physical Line(12) = {12};
Physical Surface("back") = {1};
Physical Surface("right") = {4};
Physical Surface("bottom") = {5};
Physical Surface("front") = {2};
Physical Surface("top") = {6};
Physical Surface("left") = {3};
Physical Volume(1) = {1}

/* On my PC, the file must end with a free line to avoid errors which might come from different control characters in UNIX, Mac and Windows! Just to be save, insert one line below this comment!*/


