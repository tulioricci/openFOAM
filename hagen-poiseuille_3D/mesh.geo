//

frac = 180;
sin = Sin(Pi/frac);
cos = Cos(Pi/frac);

Point(1)  = {0., 0.0, 1.0, 1.0};
Point(2)  = {0., 0.0, 0.0, 1.0};
Point(3)  = {0., 1.0, 0.0, 1.0};

Circle(1) = {1, 2, 3};
Line(2) = {3, 2};
Line(3) = {2, 1};
/*Line(4) = {4, 1};*/

Transfinite Line { 1} = 31 Using Progression 1.0;
Transfinite Line { 2} = 16 Using Progression 1.1;
Transfinite Line {-3} = 16 Using Progression 1.1;

Line Loop(1) = {1,2,3};

Plane Surface(1) = {1};
/*Transfinite Surface{1};*/
Recombine Surface(1);

Extrude {10,0,0} { Surface{ 1}; Layers{201}; Recombine; }

Physical Surface("inlet") = {1};
Physical Surface("outlet") = {20};
Physical Surface("frontAndBack") = {15,19};
Physical Surface("wall") = {11};
Physical Volume("domain") = {1};

Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;

Save "mesh.msh";
