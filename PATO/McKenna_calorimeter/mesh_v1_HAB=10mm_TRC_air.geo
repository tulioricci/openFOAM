clF = 0.006400;
clB = 0.001500;
clM = 0.001500;
clS = 0.000850;
cl0 = 0.014400;
cl1 = 0.048000;
cl2 = 0.072000;

radius = 1.0;

mesh_type = 2;

frac = 90;
sin = Sin(Pi/frac);
cos = Cos(Pi/frac);

int_radius = 2.38*25.4/2000;
ext_radius = 2.89*25.4/2000;
burner_base_radius = 4.725*25.4/2000;

burner_height = 0.10;
flame_dist = 0.001;

mat_location = burner_height + 0.010;  //arbitrary value
mat_wide = 0.5*1.25*25.4/1000;
mat_thick = 15/32*25.4/1000;
insulator_1 = 2.0*25.4/1000;
insulator_2 = 3.0*25.4/1000;
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

Point( 9) = {         0.0, mat_location - mat_BL_y   ,           0.,     clS};
Point(10) = {         0.0, mat_location              ,           0., 0.7*clS};
x3 = 0.3*25.4/2000;
Point(11) = {      x3*cos, mat_location              ,       x3*sin, 0.7*clS};
Point(12) = {mat_wide*cos, mat_location              , mat_wide*sin,     1.0};
Point(13) = {mat_wide*cos, mat_location + mat_thick  , mat_wide*sin,     1.0};
Point(14) = {mat_wide*cos, mat_location + insulator_1, mat_wide*sin,     1.0};

Point(15) = {mat_wide*cos,            mat_location + 1.*mat_holder, mat_wide*sin, 1.};
Point(16) = {         0.0,            mat_location + 1.*mat_holder, 0., clM};
Point(17) = {         0.0, mat_BL_y + mat_location + 1.*mat_holder, 0., 2.0*clS};

Point(20) = {                   0.0, radius,                     0., 0.25*cl2};
Point(22) = {            radius*cos, radius,             radius*sin,      cl2};
Point(24) = {            radius*cos,     0.,             radius*sin,      cl2};
Point(25) = {burner_base_radius*cos,     0., burner_base_radius*sin, 6.66*clB};

aux = 0.5*(burner_base_radius + ext_radius);
Point(26) = {burner_base_radius*cos, burner_height-0.0110, burner_base_radius*sin, clB*0.33};
Point(27) = {               aux*cos, burner_height-0.0055,                aux*sin, clB};

offset = 0.0;
Point(30) = {         ext_radius*cos, burner_height + flame_dist,         ext_radius*sin, 1.0};
Point(33) = {                     0., burner_height + flame_dist,                     0., 1.0};
Point(34) = { burner_base_radius*cos,  - mat_BL_y + mat_location, burner_base_radius*sin, 1.0};
Point(35) = {                aux*cos,  - mat_BL_y + mat_location,                aux*sin, 0.0010};
Point(36) = {         ext_radius*cos,  - mat_BL_y + mat_location,         ext_radius*sin, 1.0};
Point(37) = {         mid_radius*cos,  - mat_BL_y + mat_location,         mid_radius*sin, 1.0};
Point(38) = {         int_radius*cos,  - mat_BL_y + mat_location,         int_radius*sin, 1.0};

Point(39) = { burner_base_radius*cos, insulator_1 + mat_location, burner_base_radius*sin, 1.0};

Point(41) = {r4*cos,                - mat_BL_y + mat_location, r4*sin, 1.0};
Point(43) = {r4*cos,                 mat_thick + mat_location, r4*sin, 1.0};
Point(44) = {r4*cos,                 insulator_1 + mat_location, r4*sin, 1.0};
Point(45) = {r4*cos, 1.0*mat_holder + mat_BL_y + mat_location, r4*sin, 1.0};

x0 = 0.0;
y3 = 0.063*25.4/1000;
Point(50) = {  x0*cos, mat_location + y3, x0*sin, clM/2.0};

x1 = 0.0;
y1 = 0.4*25.4/1000;
Point(51) = {  x1*cos, mat_location + y1, x1*sin, clM/2.0};

x2 = 0.3*25.4/2000;
y2 = 0.4*25.4/1000;
Point(52) = {  x2*cos, mat_location + y2, x2*sin, clM/2.0};

x3 = 0.3*25.4/2000;
y3 = 0.063*25.4/1000;
Point(53) = {  x3*cos, mat_location + y3, x3*sin, clM/2.0};

x4 = 0.35*25.4/2000;
y4 = 0.063*25.4/1000;
Point(54) = {  x4*cos, mat_location + y4, x4*sin, clM/2.0};

x5 = 0.35*25.4/2000;
Point(55) = {  x1*cos, mat_location + insulator_2, x1*sin, 2*clM/2.0};

x7 = 0.35*25.4/2000;
Point(57) = {  x7*cos, mat_location + insulator_1, x7*sin, 2*clM/2.0};

x8 = 0.5*25.4/2000;
Point(58) = {  x8*cos, mat_location + insulator_1, x8*sin, 2*clM/2.0};

x9 = 0.5*25.4/2000;
Point(59) = {  x9*cos, mat_location + insulator_2, x9*sin, 2*clM/2.0};

Point(60) = {  x4*cos, mat_location + y2, x4*sin, clM/2.0};

aux = 0.5*(burner_base_radius + ext_radius);
Point(61) = {                    0.0, 0.25,     0.0, 0.0010};
Point(62) = {                 r4*cos, 0.25,  r4*sin, 0.0015};
Point(63) = { burner_base_radius*cos, 0.25, burner_base_radius*sin, 0.0015};

d = 0.0002;
Point(70) = {  x1*cos, mat_location + y1 + d, x1*sin, clM/2.0};
Point(71) = {  (x2+d)*cos, mat_location + y2 + d, (x2+d)*sin, clM/2.0};
Point(72) = {  (x3+d)*cos, mat_location + y3 + d, (x3+d)*sin, clM/2.0};
Point(73) = {  (x4-d)*cos, mat_location + y4 + d, (x4-d)*sin, clM/2.0};
Point(74) = {  (x4-d)*cos, mat_location + y2 + d, (x4-d)*sin, clM/2.0};
Point(75) = {  (x7-d)*cos, mat_location + insulator_1 + d, (x7-d)*sin, 2*clM/2.0};
Point(76) = {  (x8-d)*cos, mat_location + insulator_1 + d, (x8-d)*sin, 2*clM/2.0};
Point(77) = {  (x9-d)*cos, mat_location + insulator_2 - d, (x9-d)*sin, 2*clM/2.0};
Point(78) = {  x1*cos, mat_location + insulator_2 - d, x1*sin, 2*clM/2.0};

Line( 1) = {2, 3};
Line( 2) = {3, 4};
Line( 5) = {4, 5};
Line( 6) = {5, 33};
Line( 7) = {1, 2};

Line(14) = {26, 27};
Line(15) = {27,  1};
Line(16) = { 1, 30};

Line(22) = {33,  9};
Line(23) = { 9, 41};
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

Line(49) = { 9, 10};
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

Line(60) = {10, 50};
Line(61) = {50, 51};
Line(62) = {51, 52};
Line(63) = {52, 53};
Line(64) = {53, 54};
//Line(65) = {54, 57};
Line(65) = {54, 60};
Line(66) = {60, 57};
Line(67) = {55, 16};
//Line(68) = {55, 51};
Line(69) = {57, 58};
Line(70) = {58, 59};
Line(71) = {59, 55};
Line(75) = {53, 11};
Line(76) = {11, 53};

Line(88) = {26, 34};
Line(89) = {34, 39};
Line(90) = {39, 63};
Line(91) = {63, 62};
Line(92) = {62, 61};
Line(94) = {34, 35};
Line(95) = {35, 36};
Line(96) = {36, 37};
Line(87) = {37, 38};
Line(97) = {38, 41};
Line(99) = {36, 30};

Line(98) = {39, 44};

Line(100) = {70, 71};
Line(101) = {71, 72};
Line(102) = {72, 73};
Line(103) = {73, 74};
Line(104) = {74, 75};
Line(105) = {75, 76};
Line(106) = {76, 77};
Line(107) = {77, 78};
Line(110) = {51, 70};
Line(111) = {52, 71};
Line(112) = {53, 72};
Line(113) = {54, 73};
Line(114) = {60, 74};
Line(115) = {57, 75};
Line(116) = {58, 76};
Line(117) = {59, 77};
Line(118) = {55, 78};
Line(119) = {78, 70};
Line(120) = {71, 74};

// burner
Transfinite Line {-15} = 21 Using Progression 1.075;
Transfinite Line {-95} = 21 Using Progression 1.075;
Transfinite Line { 14} = 11 Using Progression 1.00;
Transfinite Line { 94} = 11 Using Progression 1.00;

// horizontal
Transfinite Line {  1} = 5 Using Progression 1.00;
Transfinite Line { 87} = 5 Using Progression 1.00;
Transfinite Line {  7} = 17 Using Bump 0.6;
Transfinite Line { 96} = 17 Using Bump 0.6;
Transfinite Line {  2} = 33 Using Progression 1.015;
Transfinite Line { 97} = 33 Using Progression 1.015;

Transfinite Line {  5} = 41 Using Progression 1.002;
Transfinite Line {-23} = 41 Using Progression 1.002;
Transfinite Line {-51} = 41 Using Progression 1.010;


If (mesh_type == 2)
    //10 um
    Transfinite Line {22,-99} = 53 Using Progression 1.04;
    Transfinite Line { 6, 16} = 51 Using Progression 1.025;
    Transfinite Line { 13} = 51 Using Progression 1.02;
    Transfinite Line { 10} = 51 Using Progression 1.00;
    Transfinite Line {-98} = 103 Using Progression 1.018;
    Transfinite Line { 88} = 103 Using Progression 1.005;
    Transfinite Line {-49,-50,52,53,-58,59} = 41 Using Progression 1.085;
    Point(104) = {0.0, 0.000010 + burner_height, int_radius*sin, 1.0};
    Point(105) = {0.0, mat_location - 0.000010 , int_radius*sin, 1.0};
EndIf


// material
Transfinite Line { 26} = 29 Using Progression 1.012;
Transfinite Line { 54} = 29 Using Progression 1.025;

Transfinite Line { 27} = 41 Using Progression 1.02;
Transfinite Line { 55} = 41 Using Progression 1.02;

Transfinite Line { 57} = 21 Using Progression 1.0;
Transfinite Line {-29} = 21 Using Progression 1.02;

Transfinite Line {-28} = 51 Using Progression 1.009;
Transfinite Line {-56} = 51 Using Progression 1.012;
Transfinite Line {-90} = 35 Using Progression 1.0;

Transfinite Line { 23} = 41 Using Progression 1.003;
Transfinite Line { 50} = 10 Using Progression 1.00;
Transfinite Line { 62, 100} = 10 Using Progression 1.00;
Transfinite Line {-51} = 32 Using Progression 1.01;

Transfinite Line { 30} = 51 Using Progression 1.01;

Transfinite Line { 89} = 69 Using Progression 1.018;
Transfinite Line {-90} = 55 Using Progression 1.0;
Transfinite Line {-91} = 31 Using Progression 1.0;
Transfinite Line {-92} = 21 Using Progression 1.02;
Transfinite Line {-98} = 83 Using Progression 1.004;

Transfinite Line { 60} =  6 Using Progression 1.05;
Transfinite Line {-75} =  6 Using Progression 1.05;
Transfinite Line { 61} = 20 Using Progression 1.027;
Transfinite Line {-63,-101} = 20 Using Progression 1.027;
Transfinite Line { 64, 102, 120} = 3 Using Progression 1.0;
Transfinite Line { 65, 103} = 20 Using Progression 1.027;
Transfinite Line { 66, 104} = 71 Using Progression 1.01;
Transfinite Line { 69, 105} = 3 Using Progression 1.0;
Transfinite Line { 70, 106} = 31 Using Progression 1.0;
Transfinite Line { 71, 107} = 7 Using Progression 1.0;
Transfinite Line { 67} = 26 Using Progression 1.01;

Transfinite Line { 110} = 5 Using Progression 1.05;
Transfinite Line { 118} = 5 Using Progression 1.05;
Transfinite Line {-119} = 81 Using Progression 1.01;

Field[4] = Box;
Field[4].XMax = 0.04;
Field[4].XMin = 0.016;
Field[4].YMax = 0.16;
Field[4].YMin = 0.10;
Field[4].ZMax = -1;
Field[4].ZMin = 1;
Field[4].Thickness = 0.01;
Field[4].VIn = 0.0008;
Field[4].VOut = 0.12;

Field[5] = Box;
Field[5].XMax = 0.06;
Field[5].XMin = 0.016;
Field[5].YMax = 0.25;
Field[5].YMin = 0.10;
Field[5].ZMax = -1;
Field[5].ZMin = 1;
Field[5].Thickness = 0.1;
Field[5].VIn = 0.0012;
Field[5].VOut = 0.12;

Field[1] = Box;
Field[1].XMax = 0.08;
Field[1].XMin = 0.0;
Field[1].YMax = 0.30;
Field[1].YMin = 0.105;
Field[1].ZMax = -1;
Field[1].ZMin = 1;
Field[1].Thickness = 0.8;
Field[1].VIn = 0.0018;
Field[1].VOut = 0.12;

Field[2] = Box;
Field[2].XMax = 0.12;
Field[2].XMin = 0.0;
Field[2].YMax = 0.375;
Field[2].YMin = 0.1;
Field[2].ZMax = -1;
Field[2].ZMin = 1;
Field[2].Thickness = 0.8;
Field[2].VIn = 0.004;
Field[2].VOut = 0.12;

Field[3] = Box;
Field[3].XMax = 0.16;
Field[3].XMin = 0.0;
Field[3].YMax = 0.5;
Field[3].YMin = 0.2;
Field[3].ZMax = -1;
Field[3].ZMin = 1;
Field[3].Thickness = 0.8;
Field[3].VIn = 0.008;
Field[3].VOut = 0.12;


Field[6] = Min;
Field[6].FieldsList = {1, 2, 3, 4, 5};
Background Field = 6;


// Fluid
Line Loop(1) = {88,89,90,91,92,31,41:44};
Plane Surface(1) = {1};

Line Loop(2) = {28,29,30,-92,-91,-90,98};
Plane Surface(2) = {2};

Line Loop(3) = {-98,27,26,97,87,96,95,94,-89};
Plane Surface(3) = {3};
Transfinite Surface {3} = {44,39,34,41};
Recombine Surface(3);

Line Loop(4) = {15,16,-99,-95, -94, -88, 14};
Plane Surface(4) = {4};
Transfinite Surface {4} = {36,34,26,1};
Recombine Surface(4);

Line Loop(5) = {1, 2, 5, 6, 22, 23, -97, -87, -96, 99,-16,7};
Plane Surface(5) = {5};
Transfinite Surface {5} = {9,36,1,5};
Recombine Surface(5);

// Material BL
Line Loop(6) = {59,-29, 58, 57};
Plane Surface(6) = {6};
Transfinite Surface {6};
Recombine Surface(6);

Line Loop(7) = {-53, -54, 52, 26};
Plane Surface(7) = {-7};
Transfinite Surface {7};
Recombine Surface(7);

Line Loop(8) = {56, -58, -28, -27, -53, 55};
Plane Surface(8) = {8};
Transfinite Surface {8} = {15,45,43,13};
Recombine Surface(8);

Line Loop(9) = {49,50,51,52,-23};
Plane Surface(9) = {9};
Transfinite Surface {9} = {10,12,41,9};
Recombine Surface(9);

// Calorimeter
Line Loop(10) = {-50, 60, 61, 62, 63, 75};
Plane Surface(10) = {10};
Transfinite Surface {10} = {10,51,52,11};
Recombine Surface(10);

Line Loop(11) = {-75,64,65,66,69,70,71,67,-57,-56,-55,-54,-51};
Plane Surface(11) = {11};

Line Loop(12) = {100,120,104,105,106,107,119};
Plane Surface(12) = {-12};

Line Loop(13) = {62,63,64,65,66,69,70,71,118,-107,-106,-105,-104,-103,-102,-101,-100,-110};
Plane Surface(13) = {13};
Transfinite Surface {13} = {55,78,70,51};
Recombine Surface(13);

Line Loop(14) = {101,102,103,-120};
Plane Surface(14) = {-14};
Transfinite Surface {14};
Recombine Surface(14);

Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 1}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 2}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 3}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 4}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 5}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 6}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 7}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 8}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 9}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{10}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{11}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{12}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{13}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{14}; Layers{1}; Recombine; }


Physical Surface("f_front") = {1:9,12:14};
Physical Surface("outlet") = {154};
Physical Surface("farfield") = {158,162};
Physical Surface("burner") = {166,258,282,300};
Physical Surface("f_back") = {167,199,246,283,337,354,376,408,430,548,630,652};
Physical Surface("fuel") = {304,307};
Physical Surface("shield") = {336};
Physical Surface("s_front") = {10};
Physical Surface("s_back") = {454};
//Physical Surface("s_adiabatic") = {};
Physical Surface("h_front") = {11};
Physical Surface("h_back") = {516};
//Physical Surface("h_adiabatic") = {};
Physical Volume("flow") = {1:9,12:14};
Physical Volume("slug") = {10};
Physical Volume("holder") = {11};

Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;
Save "mesh.msh";
