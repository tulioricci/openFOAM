//

frac = 90;
sin = Sin(Pi/frac);
cos = Cos(Pi/frac);

Point(1)  = {0.0,     0.0, 0., 1.0};
Point(2)  = {10.,     0.0, 0., 1.0};
Point(3)  = {10., 0.5*cos, -0.5*sin, 1.0};
Point(4)  = {0.0, 0.5*cos, -0.5*sin, 1.0};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};


Transfinite Line { 1} = 81 Using Progression 1.03;
Transfinite Line {-2} = 21 Using Progression 1.05;
Transfinite Line {-3} = 81 Using Progression 1.03;
Transfinite Line { 4} = 21 Using Progression 1.05;

Line Loop(1) = {1,2,3,4};

Plane Surface(1) = {1};
Transfinite Surface{1};
Recombine Surface(1);

Extrude {{1,0,0}, {0,0,0}, 2*Pi/frac} { Surface{ 1}; Layers{1}; Recombine; }

Physical Surface("inlet") = {20};
Physical Surface("outlet") = {13};
Physical Surface("front") = {1};
Physical Surface("back") = {21};
Physical Surface("wall") = {17};
Physical Volume("domain") = {1};

Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;

Save "mesh.msh";
