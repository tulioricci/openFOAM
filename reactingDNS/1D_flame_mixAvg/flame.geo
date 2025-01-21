//

Point(1)  = {-0.200, -0.01, -0.01, 1.0};
Point(2)  = {-0.001, -0.01, -0.01, 1.0};
Point(3)  = {+0.001, -0.01, -0.01, 1.0};
Point(4)  = {+0.200, -0.01, -0.01, 1.0};
Point(5)  = {+0.200, +0.01, -0.01, 1.0};
Point(6)  = {+0.001, +0.01, -0.01, 1.0};
Point(7)  = {-0.001, +0.01, -0.01, 1.0};
Point(8)  = {-0.200, +0.01, -0.01, 1.0};

Line( 1) = {1, 2};
Line( 2) = {2, 3};
Line( 3) = {3, 4};
Line( 4) = {4, 5};
Line( 5) = {5, 6};
Line( 6) = {6, 7};
Line( 7) = {7, 8};
Line( 8) = {8, 1};
Line( 9) = {7, 2};
Line(10) = {3, 6};

Transfinite Line {-1,3,-5,7} = 222 Using Progression 1.033;
Transfinite Line { 2, 6} = 401 Using Progression 1.0;
Transfinite Line { 4, 8} =  2 Using Progression 1.0;

Point( 9)  = {-0.000020, -0.01, 0.01, 1.0};
Point(10)  = {-0.000010, -0.01, 0.01, 1.0};
Point(11)  = { 0.000000, -0.01, 0.01, 1.0};
Point(12)  = {-0.001010, -0.01, 0.01, 1.0};

Line Loop(10) = {1,2,3,4,5,6,7,8};

Plane Surface(1) = {10};
Transfinite Surface{1} = {1,4,5,8};
Recombine Surface(1);


Extrude {0, 0, 0.02} {Surface {1}; Layers{1}; Recombine;}

Physical Surface("inlet") = {51};
Physical Surface("outlet") = {35};
Physical Surface("frontAndBack") = {1,23,27,31,39,43,47,52};
Physical Volume("domain") = {1};

Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;

Save "mesh.msh";
