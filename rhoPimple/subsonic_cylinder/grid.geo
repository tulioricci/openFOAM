//

lcar0 = 0.050;
lcar1 = 0.200;
lcar2 = 2.500;


Point(1)  = {-50.0, -50.0, -0.01, lcar2};
Point(2)  = { 100.0, -50.0, -0.01, lcar2};
Point(3)  = { 100.0,  50.0, -0.01, lcar2};
Point(4)  = {-50.0,  50.0, -0.01, lcar2};

Point( 5)  = {-0.6, 0.0, -0.01, lcar0};
Point( 6)  = {-0.5, 0.0, -0.01, lcar0};
Point( 7)  = { 0.0, 0.5, -0.01, lcar0};
Point( 8)  = { 0.0, 0.6, -0.01, lcar0};
Point( 9)  = { 0.5, 0.0, -0.01, lcar0};
Point(10)  = { 0.6, 0.0, -0.01, lcar0};
Point(11)  = { 0.0,-0.5, -0.01, lcar0};
Point(12)  = { 0.0,-0.6, -0.01, lcar0};
Point(13)  = { 0.0, 0.0, -0.01, lcar0};

//Define bounding box edges
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

Circle(5) = { 6,13, 7};
Circle(6) = { 7,13, 9};
Circle(7) = { 9,13,11};
Circle(8) = {11,13, 6};

Circle( 9) = { 5,13, 8};
Circle(10) = { 8,13,10};
Circle(11) = {10,13,12};
Circle(12) = {12,13, 5};

Line(13) = { 6, 5};
Line(14) = { 7, 8};
Line(15) = { 9,10};
Line(16) = {11,12};

Transfinite Line { 5:12} = 31 Using Progression 1.0;
Transfinite Line {13:16} = 11 Using Progression 1.0;


Line Loop(21) = {5,14, -9,-13};
Line Loop(22) = {6,15,-10,-14};
Line Loop(23) = {7,16,-11,-15};
Line Loop(24) = {8,13,-12,-16};
Line Loop(25) = {1,2,3,4,9,10,11,12};



Field[1] = Box;
Field[1].XMax = 10.0;
Field[1].XMin = 0.0;
Field[1].YMax = -1.0;
Field[1].YMin = +1.0;
Field[1].ZMax = -0.1;
Field[1].ZMin = 0.1;
Field[1].Thickness = 1;
Field[1].VIn = 0.1;
Field[1].VOut = 10;

Field[2] = Box;
Field[2].XMax = 20.0;
Field[2].XMin = -2.0;
Field[2].YMax = -2.0;
Field[2].YMin = +2.0;
Field[2].ZMax = -1;
Field[2].ZMin = 1;
Field[2].Thickness = 1;
Field[2].VIn = 0.2;
Field[2].VOut = 10;

Field[3] = Box;
Field[3].XMax = 30.0;
Field[3].XMin = -4.0;
Field[3].YMax = -4.0;
Field[3].YMin = +4.0;
Field[3].ZMax = -1;
Field[3].ZMin = 1;
Field[3].Thickness = 5;
Field[3].VIn = 0.4;
Field[3].VOut = 10;

Field[4] = Min;
Field[4].FieldsList = {1, 2, 3};
Background Field = 4;



Plane Surface(1) = {-21};
Transfinite Surface{1} Alternate;
Recombine Surface (1);

Plane Surface(2) = {-22};
Transfinite Surface{2} Alternate;
Recombine Surface (2);

Plane Surface(3) = {-23};
Transfinite Surface{3} Alternate;
Recombine Surface (3);

Plane Surface(4) = {-24};
Transfinite Surface{4} Alternate;
Recombine Surface (4);

Plane Surface(5) = {-25};



Extrude {0, 0, 0.02} {Surface {1}; Layers{1}; Recombine;}
Extrude {0, 0, 0.02} {Surface {2}; Layers{1}; Recombine;}
Extrude {0, 0, 0.02} {Surface {3}; Layers{1}; Recombine;}
Extrude {0, 0, 0.02} {Surface {4}; Layers{1}; Recombine;}
Extrude {0, 0, 0.02} {Surface {5}; Layers{1}; Recombine;}



Physical Surface("inlet") = {142};
Physical Surface("outlet") = {146, 150, 154};
Physical Surface("front") = {1, 2, 3, 4, 5};
Physical Surface("back") = {47, 69, 91, 113, 155};
Physical Surface("wall") = {46,68,90,112};
Physical Volume("domain") = {1,2,3,4,5};



Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;

Save "mesh.msh";
