clF = 0.006400;
clB = 0.001500;
clM = 0.001500;
clS = 0.000850;
cl0 = 0.014400;
cl1 = 0.048000;
cl2 = 0.072000;

radius = 1.0;

mesh_type = 0;

frac = 90;
sin = Sin(Pi/frac);
cos = Cos(Pi/frac);

int_radius = 2.38*25.4/2000;
ext_radius = 2.89*25.4/2000;
burner_base_radius = 4.725*25.4/2000;

burner_height = 0.10;
flame_dist = 0.0005;

mat_location = burner_height + 0.010;  //arbitrary value
mat_wide = 0.5*1.25*25.4/1000;
mat_thick = 15.0/32.0*25.4/1000;
insulator = 1.00*25.4/1000 + mat_thick;
insulator_wide = 0.5*1.00*25.4/1000;
mat_holder = 4.0*25.4/1000;
mat_BL_x = 0.0030;
mat_BL_y = 0.0030;


mid_radius = int_radius + 0.001;
r4 = mat_wide + mat_BL_x;
Point(1) = {ext_radius*cos, burner_height, ext_radius*sin, 0.000200};
Point(2) = {mid_radius*cos, burner_height, mid_radius*sin, 0.000200};
Point(3) = {int_radius*cos, burner_height, int_radius*sin, 1.0};
Point(4) = {        r4*cos, burner_height,         r4*sin, 1.0};
Point(5) = {            0., burner_height,             0., 1.0};

delta = (mat_location - mat_BL_y - burner_height - flame_dist);
flame_pos = burner_height + flame_dist;

Point(10) = {         0.0,  mat_location - mat_BL_y,           0.,     1.0};
Point(11) = {         0.0, mat_location            ,           0., 0.7*clS};
Point(12) = {mat_wide*cos, mat_location            , mat_wide*sin,     1.0};
Point(13) = {mat_wide*cos, mat_location + mat_thick, mat_wide*sin,     1.0};
Point(14) = {mat_wide*cos, mat_location + insulator, mat_wide*sin,     1.0};

Point(15) = {mat_wide*cos,            mat_location + 1.*mat_holder, mat_wide*sin, 1.0};
Point(16) = {         0.0,            mat_location + 1.*mat_holder,           0., 0.78*clM};
Point(17) = {         0.0, mat_BL_y + mat_location + 1.*mat_holder,           0., 1.25*clS};

Point(20) = {                   0.0, radius,                     0., 0.25*cl2};
Point(22) = {            radius*cos, radius,             radius*sin,      cl2};
Point(24) = {            radius*cos,     0.,             radius*sin,      cl2};
Point(25) = {burner_base_radius*cos,     0., burner_base_radius*sin, 6.66*clB};

aux = 0.5*(burner_base_radius + ext_radius);
Point(26) = {burner_base_radius*cos, burner_height-0.0110, burner_base_radius*sin, clB*0.33};
Point(27) = {               aux*cos, burner_height-0.0055,                aux*sin, clB};

offset = 0.0;
Point(30) = {         ext_radius*cos, burner_height + flame_dist,         ext_radius*sin, 1.0};
Point(31) = {         int_radius*cos, burner_height + flame_dist,         int_radius*sin, 1.0};
Point(32) = {                 r4*cos, burner_height + flame_dist,                 r4*sin, 1.0};
Point(33) = {                     0., burner_height + flame_dist,                     0., 1.0};
Point(34) = { burner_base_radius*cos,  - mat_BL_y + mat_location, burner_base_radius*sin, 1.0};
Point(35) = {                aux*cos,  - mat_BL_y + mat_location,                aux*sin, 0.0010};
Point(36) = {         ext_radius*cos,  - mat_BL_y + mat_location,         ext_radius*sin, 1.0};
Point(37) = {         mid_radius*cos,  - mat_BL_y + mat_location,         mid_radius*sin, 1.0};
Point(38) = {         int_radius*cos,  - mat_BL_y + mat_location,         int_radius*sin, 1.0};

Point(39) = { burner_base_radius*cos, insulator + mat_location, burner_base_radius*sin, 1.0};

Point(41) = {r4*cos,                - mat_BL_y + mat_location, r4*sin, 1.0};
Point(43) = {r4*cos,                 mat_thick + mat_location, r4*sin, 1.0};
Point(44) = {r4*cos,                 insulator + mat_location, r4*sin, 1.0};
Point(45) = {r4*cos, 1.0*mat_holder + mat_BL_y + mat_location, r4*sin, 1.0};

aux = 0.5*(burner_base_radius + ext_radius);
Point(61) = {     0.0, 0.225,     0.0, 0.0010};
Point(62) = {  r4*cos, 0.225,  r4*sin, 0.0015};
Point(63) = { burner_base_radius*cos, 0.225, burner_base_radius*sin, 0.0015};

Line( 1) = {2, 3};
Line( 2) = {3, 4};
Line( 3) = {3, 31};
Line( 4) = {4, 32};
Line( 5) = {4, 5};
Line( 6) = {5, 33};
Line( 7) = {1, 2};

Line(14) = {26, 27};
Line(15) = {27,  1};
Line(16) = { 1, 30};

Line(22) = {33, 10};
Line(23) = {10, 41};
Line(24) = {41, 32};
Line(26) = {41, 43};
Line(27) = {43, 44};
Line(28) = {44, 45};
Line(29) = {45, 17};
Line(30) = {17, 61};
Line(31) = {61, 20};

Line(41) = {20, 22};
Line(42) = {22, 24};
Line(43) = {24, 25};
Line(44) = {25, 26};

Line(50) = {10, 11};
Line(51) = {11, 12};
Line(52) = {12, 41};
Line(53) = {13, 43};
Line(54) = {12, 13};
Line(55) = {13, 14};
Line(56) = {14, 15};
Line(57) = {15, 16};
Line(58) = {45, 15};
Line(59) = {16, 17};
Line(60) = {44, 14};

Line(68) = {26, 34};
Line(69) = {34, 39};
Line(70) = {39, 63};
Line(71) = {63, 62};
Line(72) = {62, 61};
Line(74) = {34, 35};
Line(75) = {35, 36};
Line(76) = {36, 37};
Line(67) = {37, 38};
Line(77) = {38, 41};
Line(78) = {35, 27};
Line(79) = {36, 30};
Line(80) = {38, 31};

//Line(81) = {39, 43};
Line(81) = {39, 44};

/*burner*/
Transfinite Line {-15} = 21 Using Progression 1.075;
Transfinite Line {-75} = 21 Using Progression 1.075;
Transfinite Line { 14} = 11 Using Progression 1.00;
Transfinite Line { 74} = 11 Using Progression 1.00;

/*horizontal*/
Transfinite Line {  1} = 5 Using Progression 1.00;
Transfinite Line { 67} = 5 Using Progression 1.00;
Transfinite Line {  7} = 17 Using Bump 0.6;
Transfinite Line { 76} = 17 Using Bump 0.6;
Transfinite Line {  2} = 33 Using Progression 1.015;
Transfinite Line { 77} = 33 Using Progression 1.015;

Transfinite Line {  5} = 41 Using Progression 1.002;
Transfinite Line {-23} = 41 Using Progression 1.002;
Transfinite Line {-51} = 41 Using Progression 1.010;

If (mesh_type == 0)
    // 5um
    Transfinite Line {22,-24,-79,-80} = 111 Using Progression 1.035;
    Transfinite Line { 3, 4, 6, 16} = 101 Using Progression 1.0;
    Transfinite Line { 13} = 53 Using Progression 1.02;
    Transfinite Line { 10} = 53 Using Progression 1.00;
    Transfinite Line {-78} = 211 Using Progression 1.017;
    Transfinite Line { 68} = 211 Using Progression 1.011;
    Point(104) = {0.0, 0.000005 + burner_height, int_radius*sin, 1.0};
    Point(105) = {0.0, mat_location - 0.000005 , int_radius*sin, 1.0};
    Transfinite Line {-50,52,53,-58,59,-60} = 49 Using Progression 1.085;
EndIf

//Point(106) = {0.0, 0.001 + burner_height, 0.0*sin, 1.0};

/*material*/
Transfinite Line { 26} = 29 Using Progression 1.012;
Transfinite Line { 54} = 29 Using Progression 1.025;

Transfinite Line { 27} = 31 Using Progression 1.02;
Transfinite Line { 55} = 31 Using Progression 1.02;

Transfinite Line {-28} = 65 Using Progression 1.0008;
Transfinite Line {-56} = 65 Using Progression 1.0025;
Transfinite Line { 57} = 21 Using Progression 1.0;
Transfinite Line {-29} = 21 Using Progression 1.02;
Transfinite Line {-72} = 21 Using Progression 1.02;

Transfinite Line { 30} = 19 Using Progression 1.033;

Transfinite Line { 69} = 59 Using Progression 1.018;
Transfinite Line {-70} = 81 Using Progression 1.0;
Transfinite Line {-71} = 31 Using Progression 1.0;
Transfinite Line {-81} = 83 Using Progression 1.004;

/*#############################################*/

Field[2] = Box;
Field[2].XMax = 0.075;
Field[2].XMin = 0.0;
Field[2].YMax = 0.25;
Field[2].YMin = 0.105;
Field[2].ZMax = -1;
Field[2].ZMin = 1;
Field[2].Thickness = 0.8;
Field[2].VIn = 0.002;
Field[2].VOut = 0.12;

Field[3] = Box;
Field[3].XMax = 0.12;
Field[3].XMin = 0.0;
Field[3].YMax = 0.375;
Field[3].YMin = 0.1;
Field[3].ZMax = -1;
Field[3].ZMin = 1;
Field[3].Thickness = 0.8;
Field[3].VIn = 0.0040;
Field[3].VOut = 0.12;

Field[4] = Box;
Field[4].XMax = 0.15;
Field[4].XMin = 0.0;
Field[4].YMax = 0.5;
Field[4].YMin = 0.1;
Field[4].ZMax = -1;
Field[4].ZMin = 1;
Field[4].Thickness = 0.8;
Field[4].VIn = 0.0080;
Field[4].VOut = 0.12;


Field[5] = Min;
Field[5].FieldsList = {2,3,4};
Background Field = 5;

/*Fluid*/
Line Loop(1) = {68,69,70,71,72,31,41:44};
Plane Surface(1) = {1};

//Line Loop(2) = {26,27,28,29,30,-72,-71,-70,-69,74,75,76,77};
//Line Loop(2) = {27,28,29,30,-72,-71,-70,81};
Line Loop(2) = {28,29,30,-72,-71,-70,81};
Plane Surface(2) = {2};
Recombine Surface(2);

Line Loop(3) = {-4,5,6,22,23,24};
Plane Surface(3) = {3};
Transfinite Surface {3} = {10,41,4,5};
Recombine Surface(3);

Line Loop(4) = {4,-24,-77,80,-3, 2};
Plane Surface(4) = {4};
Transfinite Surface {4} = {41,38,3,4};
Recombine Surface(4);

Line Loop(5) = {1,3,-80,-67,-76,79,-16,7};
Plane Surface(5) = {5};
Transfinite Surface {5} = {38,36,1,3};
Recombine Surface(5);

Line Loop(6) = {15,16,-79,-75,78};
Plane Surface(6) = {6};
Transfinite Surface {6} = {36,35,27,1};
Recombine Surface(6);

Line Loop(7) = {14,-78,-74,-68};
Plane Surface(7) = {7};
Transfinite Surface {7};
Recombine Surface(7);

Line Loop(8) = {-81,27,26,77,67,76,75,74,-69};
Plane Surface(8) = {8};
Transfinite Surface {8} = {44,39,34,41};
Recombine Surface(8);

/*Material BL*/
Line Loop(11) = {51,52,-23,50};
Plane Surface(11) = {11};
Transfinite Surface {11};
Recombine Surface(11);

Line Loop(12) = {-53, -54, 52, 26};
Plane Surface(12) = {-12};
Transfinite Surface {12};
Recombine Surface(12);

Line Loop(13) = {-60,-27, -53, 55};
Plane Surface(13) = {13};
Transfinite Surface {13};
Recombine Surface(13);

Line Loop(14) = {60, 56, -58, -28};
Plane Surface(14) = {14};
Transfinite Surface {14} Right;
Recombine Surface(14);

Line Loop(15) = {59,-29, 58, 57};
Plane Surface(15) = {15};
Transfinite Surface {15};
Recombine Surface(15);

Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 1}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 2}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 3}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 4}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 5}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 6}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 7}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 8}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{11}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{12}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{13}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{14}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{15}; Layers{1}; Recombine; }


Physical Surface("f_front") = {1:8,11:15};
Physical Surface("f_back") = {128,160,184,216,258,285,307,354,371,393,415,437,454};
Physical Surface("outlet") = {115};
Physical Surface("farfield") = {119,123};
Physical Surface("burner") = {127,229,268,294};
Physical Surface("shield") = {257};
Physical Surface("fuel") = {174,215};
Physical Surface("sample") = {362,388,414,428,453};
Physical Volume("flow") = {1:13};

Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;
Save "mesh.msh";
