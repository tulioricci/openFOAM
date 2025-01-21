//

Point(1)  = {-0.5, -0.5, -0.5, 1.0};
Point(2)  = {+0.5, -0.5, -0.5, 1.0};
Point(3)  = {+0.5, +0.5, -0.5, 1.0};
Point(4)  = {-0.5, +0.5, -0.5, 1.0};

Line( 1) = {1, 2};
Line( 2) = {2, 3};
Line( 3) = {3, 4};
Line( 4) = {4, 1};

Transfinite Line { 1,2,3,4} = 2 Using Progression 1.0;

Line Loop(10) = {1,2,3,4};

Plane Surface(1) = {10};
Transfinite Surface{1};
Recombine Surface(1);

Extrude {0, 0, 1.0} {Surface {1}; Layers{1}; Recombine;}

Physical Surface("frontAndBack") = {1,19,23,27,31,32};
Physical Volume("domain") = {1};

Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;

Save "mesh.msh";
