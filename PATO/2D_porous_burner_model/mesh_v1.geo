//

width = 50e-6;

Point( 1)  = {-0.0060,   +width, -width, 1.0};
Point( 2)  = {-0.0060,   -width, -width, 1.0};
Point( 3)  = {-0.0040,   -width, -width, 1.0};
Point( 4)  = {    0.0,   -width, -width, 1.0};
Point( 5)  = {    0.0, -2*width, -width, 1.0};
Point( 6)  = {+0.0100, -2*width, -width, 1.0};
Point( 7)  = {+0.0100,  2*width, -width, 1.0};
Point( 8)  = {    0.0,  2*width, -width, 1.0};
Point( 9)  = {    0.0,    width, -width, 1.0};
Point(10)  = {-0.0040,    width, -width, 1.0};

Point(11)  = {-0.0060,    2*width, -width, 1.0};
Point(12)  = {-0.0060,   -2*width, -width, 1.0};
Point(13)  = {-0.0040,   -2*width, -width, 1.0};
Point(14)  = {-0.0040,    2*width, -width, 1.0};


Line( 1) = { 1, 2};
Line( 2) = { 2, 3};
Line( 3) = { 3, 4};
Line( 4) = { 4, 5};
Line( 5) = { 5, 6};
Line( 6) = { 6, 7};
Line( 7) = { 7, 8};
Line( 8) = { 8, 9};
Line( 9) = { 9,10};
Line(10) = {10, 1};
Line(11) = { 9, 4};
Line(12) = {10, 3};

Line(21) = { 1,11};
Line(22) = { 2,12};
Line(23) = { 3,13};
Line(24) = {10,14};
Line(25) = {11,14};
Line(26) = {14, 8};
Line(27) = { 5,13};
Line(28) = {13,12};

Transfinite Line {-3,  9, -26, 27} = 145 Using Progression 1.02;
Transfinite Line { 5, -7} = 189 Using Progression 1.02;
Transfinite Line { 2, 10, 25, 28} = 24 Using Progression 1.0;
Transfinite Line {1, 11, 12} = 26 Using Bump 0.5;
Transfinite Line {4, -8, 21, 22, 23, 24} = 13 Using Progression 1.08;
Transfinite Line {6} = 50 Using Progression 1.0;

Point(20)  = { 10e-6,  width, -width, 1.0};
Point(21)  = {-10e-6,  width, -width, 1.0};

Line Loop(10) = {1,2,-12,10};
Plane Surface(1) = {10};
Transfinite Surface{1};
Recombine Surface(1);

Line Loop(11) = {12,3,-11,9};
Plane Surface(2) = {11};
Transfinite Surface{2};
Recombine Surface(2);

Line Loop(12) = {4,5,6,7,8,11};
Plane Surface(3) = {12};
Transfinite Surface{3} = {5,6,7,8};
Recombine Surface(3);

Line Loop(13) = {21, 25, 26, 8, 9, 10};
Plane Surface(4) = {13};
Transfinite Surface{4} = {1, 11, 8, 9};
Recombine Surface(4);

Line Loop(14) = {2, 3, 4, 27, 28, -22};
Plane Surface(5) = {14};
Transfinite Surface{5} = {12, 2, 4, 5};
Recombine Surface(5);

Extrude {0, 0, 2*width} {Surface {1}; Layers{1}; Recombine;}
Extrude {0, 0, 2*width} {Surface {2}; Layers{1}; Recombine;}
Extrude {0, 0, 2*width} {Surface {3}; Layers{1}; Recombine;}
Extrude {0, 0, 2*width} {Surface {4}; Layers{1}; Recombine;}
Extrude {0, 0, 2*width} {Surface {5}; Layers{1}; Recombine;}

Physical Surface("inlet") = {37};
Physical Surface("outlet") = {91};
Physical Surface("f_frontAndBack") = {1,2,3,50,72,104};
Physical Surface("f_side") = {87,95};
Physical Surface("s_bottom") = {115,167};
Physical Surface("s_side") = {119,123,159,163};
Physical Surface("s_frontAndBack") = {4,5,136,168};
Physical Volume("fluid") = {1,2,3};
Physical Volume("solid") = {4,5};

Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;

Save "mesh.msh";
