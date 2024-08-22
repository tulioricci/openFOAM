//

Point(1)  = {-0.2, -0.001, 0.001, 1.0};
Point(3)  = {+0.2, -0.001, 0.001, 1.0};
Point(4)  = {+0.2, +0.001, 0.001, 1.0};
Point(6)  = {-0.2, +0.001, 0.001, 1.0};
Point(9)  = {-0.005, +0.001, 0.001, 1.0};
Point(10)  = {-0.005, -0.001, 0.001, 1.0};
Point(11)  = {+0.005, -0.001, 0.001, 1.0};
Point(13)  = {+0.005, +0.001, 0.001, 1.0};

Line(1) = {1, 10};
Line(2) = {10, 11};
Line(3) = {11, 3};
Line(4) = {3, 4};
Line(5) = {4, 13};
Line(6) = {13, 9};
Line(7) = {9, 6};
Line(8) = {6, 1};
Line(9) = {13, 11};
Line(10) = {9, 10};


Transfinite Line {-2} = 51 Using Progression 1.0;
Transfinite Line { 6} =  51 Using Progression 1.0;

Transfinite Line {-1} = 81 Using Progression 1.05;
Transfinite Line { 3} =  81 Using Progression 1.05;
Transfinite Line {-5} = 81 Using Progression 1.05;
Transfinite Line { 7} =  81 Using Progression 1.05;

Transfinite Line {-4} = 11 Using Progression 1.0;
Transfinite Line { 8} =  11 Using Progression 1.0;
Transfinite Line { 9} =  11 Using Progression 1.0;
Transfinite Line {10} = 11 Using Progression 1.0;


Line Loop(10) = {1,2,3,4,5,6,7,8};

Plane Surface(1) = {10};
Transfinite Surface{1} = {1,3,4,6};
Recombine Surface(1);


Extrude {0, 0, 0.002} {Surface {1}; Layers{1}; Recombine;}

Physical Surface("inlet") = {51};
Physical Surface("outlet") = {35};
Physical Surface("frontAndBack") = {23,27,31,39,43, 47};
Physical Surface("wall") = {1, 52};
Physical Volume("domain") = {1};

Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;

Save "mesh.msh";
