
Point(1) = {-1.0, -0.5, -0.5, 1.0};
Point(2) = {-1.0, +0.5, -0.5, 1.0};
Point(3) = { 0.0, +0.5, -0.5, 1.0};
Point(4) = { 0.0, -0.5, -0.5, 1.0};

Point(5) = { 1.0, +0.5, -0.5, 1.0};
Point(6) = { 1.0, -0.5, -0.5, 1.0};

Line( 1) = {1, 2};
Line( 2) = {2, 3};
Line( 3) = {3, 4};
Line( 4) = {4, 1};
Line( 5) = {3, 5};
Line( 6) = {5, 6};
Line( 7) = {6, 4};
/*Line( 5) = {4, 5};*/
/*Line( 6) = {5, 33};*/



Transfinite Line {1:7} = 3 Using Progression 1.0;


Line Loop(1) = {1:4};
Plane Surface(1) = {1};
Transfinite Surface {1};
Recombine Surface(1);

Line Loop(2) = {-3,5,6,7};
Plane Surface(2) = {2};
Transfinite Surface {2};
Recombine Surface(2);


Extrude {0,0,1} { Surface{ 1}; Layers{2}; Recombine; }
Extrude {0,0,1} { Surface{ 2}; Layers{2}; Recombine; }

Physical Surface("f_side") = {16};
Physical Surface("f_frontAndBack") = {1,20,28,29};
Physical Surface("s_side") = {46};
Physical Surface("s_frontAndBack") = {2,42,50,51};
Physical Volume("flow") = {1};
Physical Volume("porousMat") = {2};

Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;

Save "mesh.msh";

