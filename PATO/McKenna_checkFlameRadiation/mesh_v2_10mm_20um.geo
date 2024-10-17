clF = 0.006400;
clB = 0.001500;
clM = 0.001500;
clS = 0.000850;
cl0 = 0.014400;
cl1 = 0.048000;
cl2 = 0.072000;

radius = 0.5;

frac = 90;
sin = Sin(Pi/frac);
cos = Cos(Pi/frac);

int_radius = 2.38*25.4/2000;
ext_radius = 2.89*25.4/2000;
burner_base_radius = 4.725*25.4/2000;

burner_height = 0.10;
flame_dist = 0.0035;

mat_location = burner_height + 0.010;  //arbitrary value
mat_wide = 0.5*1.25*25.4/1000;
mat_thick = 15.0/32.0*25.4/1000;
insulator = 1.00*25.4/1000 + mat_thick;
insulator_wide = 0.5*1.00*25.4/1000;
mat_holder = 1.75*25.4/1000 + mat_thick;
mat_BL_x = 0.0030;
mat_BL_y = 0.0030;


r4 = mat_wide + mat_BL_x;
Point(2) = {ext_radius*cos, burner_height, ext_radius*sin, 0.000200};
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

Point(20) = {                   0.0, radius,                     0., 0.40*cl2};
Point(22) = {            radius*cos, radius,             radius*sin,      cl2};
Point(24) = {            radius*cos,     0.,             radius*sin,      cl2};
Point(25) = {burner_base_radius*cos,     0., burner_base_radius*sin, 6.66*clB};

aux = 0.5*(burner_base_radius + ext_radius);
Point(26) = {burner_base_radius*cos, burner_height-0.0110, burner_base_radius*sin, clB};
Point(27) = {               aux*cos, burner_height-0.0055,                aux*sin, clB};

offset = 0.0;
Point(28) = { burner_base_radius*cos, burner_height + flame_dist, burner_base_radius*sin, 1.0};
Point(29) = {                aux*cos, burner_height + flame_dist,                aux*sin, 1.0};
Point(30) = {         ext_radius*cos, burner_height + flame_dist,         ext_radius*sin, 1.0};
Point(31) = {         int_radius*cos, burner_height + flame_dist,         int_radius*sin, 1.0};
Point(32) = {                 r4*cos, burner_height + flame_dist,                 r4*sin, 1.0};
Point(33) = {                     0., burner_height + flame_dist,                     0., 1.0};


Point(41) = {r4*cos,                - mat_BL_y + mat_location, r4*sin, 1.0};
Point(43) = {r4*cos,                 mat_thick + mat_location, r4*sin, 1.0};
Point(44) = {r4*cos,                 insulator + mat_location, r4*sin, 1.0};
Point(45) = {r4*cos, 1.0*mat_holder + mat_BL_y + mat_location, r4*sin, 1.0};

Line( 1) = {2, 3};
Line( 2) = {3, 4};
Line( 3) = {3, 31};
Line( 4) = {4, 32};
Line( 5) = {4, 5};
Line( 6) = {5, 33};

Line(10) = {26, 28};
Line(11) = {28, 29};
Line(12) = {29, 30};
Line(13) = {27, 29};
Line(14) = {26, 27};
Line(15) = {27,  2};
Line(16) = { 2, 30};
Line(17) = {30, 31};
Line(18) = {31, 32};
Line(19) = {32, 33};

Line(22) = {33, 10};
Line(23) = {10, 41};
Line(26) = {41, 43};
Line(27) = {43, 44};
Line(28) = {44, 45};
Line(29) = {45, 17};
Line(30) = {17, 20};

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

delta_mat = mat_wide - insulator_wide;
Point(51) = {insulator_wide*cos, mat_location + insulator, insulator_wide*sin, 0.9*clM};
Point(52) = {               0.0, mat_location + insulator,                 0., 1.0*clM};
Point(53) = {               0.0, mat_location + mat_thick,                 0., 0.6*clM};
Point(54) = {insulator_wide*cos, mat_location + mat_thick, insulator_wide*sin, 0.3*clM};
Point(55) = {insulator_wide*cos, mat_location + delta_mat, insulator_wide*sin, 0.3*clM};
Point(56) = {               0.0, mat_location + delta_mat,                 0., 0.3*clM};

Line(61) = {11, 56};
Line(63) = {56, 53};
Line(64) = {54, 13};
Line(65) = {16, 52};
Line(66) = {51, 52};
Line(67) = {52, 53};
Line(68) = {53, 54};
Line(69) = {54, 51};
Line(70) = {54, 55};
Line(71) = {55, 56};
Line(72) = {55, 12};

/*horizontal*/
Transfinite Line {  1} = 19 Using Bump 0.75;
Transfinite Line { 17} = 19 Using Bump 0.75;
Transfinite Line {  2} = 29 Using Progression 1.02;
Transfinite Line { 18} = 29 Using Progression 1.02;

Transfinite Line {- 5} = 37 Using Progression 1.00;
Transfinite Line {-19} = 37 Using Progression 1.00;

Transfinite Line { 23} = 31 Using Progression 1.01;
Transfinite Line {-51} = 31 Using Progression 1.001;
Transfinite Line { 71} = 31 Using Progression 1.015;

Transfinite Line { 22} = 8 Using Progression 1.0;

/*vertical*/
Transfinite Line {  3} = 31 Using Progression 1.10;
Transfinite Line { 16} = 31 Using Progression 1.10;
Transfinite Line {  4} = 31 Using Progression 1.10;
Transfinite Line {  6} = 31 Using Progression 1.10;
Transfinite Line { 13} = 31 Using Progression 1.02;
Transfinite Line { 10} = 31 Using Progression 1.00;

/*burner*/
Transfinite Line {-15} = 21 Using Progression 1.075;
Transfinite Line {-12} = 21 Using Progression 1.075;
Transfinite Line { 14} = 11 Using Progression 1.00;
Transfinite Line { 11} = 11 Using Progression 1.00;

/*material*/
Transfinite Line {-50} = 21 Using Progression 1.100;
Transfinite Line { 52} = 21 Using Progression 1.100;
Transfinite Line { 53} = 21 Using Progression 1.100;
Transfinite Line {-58} = 21 Using Progression 1.100;
Transfinite Line { 59} = 21 Using Progression 1.100;
Transfinite Line {-60} = 21 Using Progression 1.100;

Transfinite Line { 26} = 21 Using Progression 1.000;
Transfinite Line { 54} = 21 Using Progression 1.002;
Transfinite Line { 70} = 21 Using Progression 1.005;

Transfinite Line { 27} = 31 Using Progression 1.02;
Transfinite Line { 55} = 31 Using Progression 1.02;

Transfinite Line {-28} = 21 Using Progression 1.004;
Transfinite Line {-56} = 21 Using Progression 1.02;

Transfinite Line { 57} = 19 Using Progression 1.0;
Transfinite Line {-29} = 19 Using Progression 1.02;

Transfinite Line {-64} = 11 Using Progression 1.066;
Transfinite Line {-72} = 11 Using Progression 1.066;
Transfinite Line { 61} = 11 Using Progression 1.066;

/*#############################################*/

//+
Field[1] = Box;
Field[1].XMax = 0.075;
Field[1].XMin = 0.0;
Field[1].YMax = 0.25;
Field[1].YMin = 0.105;
Field[1].ZMax = -1;
Field[1].ZMin = 1;
Field[1].Thickness = 0.8;
Field[1].VIn = 0.0025;
Field[1].VOut = 0.12;

Field[2] = Box;
Field[2].XMax = 0.12;
Field[2].XMin = 0.0;
Field[2].YMax = 0.375;
Field[2].YMin = 0.1;
Field[2].ZMax = -1;
Field[2].ZMin = 1;
Field[2].Thickness = 0.8;
Field[2].VIn = 0.0050;
Field[2].VOut = 0.12;

Field[3] = Box;
Field[3].XMax = 0.15;
Field[3].XMin = 0.0;
Field[3].YMax = 0.5;
Field[3].YMin = 0.2;
Field[3].ZMax = -1;
Field[3].ZMin = 1;
Field[3].Thickness = 0.8;
Field[3].VIn = 0.0100;
Field[3].VOut = 0.12;

Field[4] = Box;
Field[4].XMax = 0.0375;
Field[4].XMin = 0.0;
Field[4].YMax = 0.18;
Field[4].YMin = 0.10;
Field[4].ZMax = -1;
Field[4].ZMin = 1;
Field[4].Thickness = 0.01;
Field[4].VIn = 0.00125;
Field[4].VOut = 0.12;


Field[5] = Min;
Field[5].FieldsList = {1, 2, 3, 4};
Background Field = 5;

/*Fluid*/
Line Loop(1) = {10:12,17:19,22:23,26:30,41:44};
Plane Surface(1) = {1};
/*Recombine Surface(1);*/

Line Loop(2) = {1,3,-17,-16};
Plane Surface(2) = {2};
Transfinite Surface {2} Alternate;
Recombine Surface(2);

Line Loop(3) = {4,-18,-3, 2};
Plane Surface(3) = {3};
Transfinite Surface {3} Alternate;
Recombine Surface(3);

Line Loop(4) = {-4,5,6,-19};
Plane Surface(4) = {4};
Transfinite Surface {4} Alternate;
Recombine Surface(4);

Line Loop(5) = {15,16,-12,-13};
Plane Surface(5) = {5};
Transfinite Surface {5} Alternate;
Recombine Surface(5);

Line Loop(6) = {14,13,-11,-10};
Plane Surface(6) = {6};
Transfinite Surface {6} Alternate;
Recombine Surface(6);

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

/*Sample*/
Line Loop(16) = {70,71,63,68};
Plane Surface(16) = {16};
/*Recombine Surface(16);*/

Line Loop(17) = {70,72,54,-64};
Plane Surface(17) = {-17};
Transfinite Surface {17} Left;
Recombine Surface(17);

Line Loop(18) = {72,-51,61,-71};
Plane Surface(18) = {18};
Transfinite Surface {18} Right;
Recombine Surface(18);

/*Alumina*/
Line Loop(20) = {66,67,68,69};
Plane Surface(20) = {-20};
/*Recombine Surface(20);*/

/*Graphite*/
Line Loop(21) = {56,57,65,-66,-69,64,55};
Plane Surface(21) = {-21};
/*Recombine Surface(21);*/


Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 1}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 2}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 3}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 4}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 5}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 6}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{11}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{12}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{13}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{14}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{15}; Layers{1}; Recombine; }

Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{16}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{17}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{18}; Layers{1}; Recombine; }

Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{20}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{21}; Layers{1}; Recombine; }


/*#########################*/

/*Point(104) = {int_radius*cos           ,   0.000020 + burner_height, int_radius*sin, 1.0};*/


Physical Surface("outlet") = {136};
Physical Surface("farfield") = {140,144};
Physical Surface("burner") = {148,241,219};
Physical Surface("shield") = {158};
Physical Surface("fuel") = {192,205};
Physical Surface("f_front") = {1:6,11:15};
Physical Surface("f_back") = {149,171,193,210,232,254,271,293,315,337,354};
Physical Surface("s_front") = {16,17,18};
Physical Surface("s_back") = {371,393,410};
Physical Surface("a_front") = {20};
Physical Surface("a_back") = {427};
Physical Surface("g_front") = {21};
Physical Surface("g_back") = {459};
Physical Volume("flow") = {1:11};
Physical Volume("porousMat") = {12:14};
Physical Volume("alumina") = {15};
Physical Volume("graphite") = {16};

Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;

Save "mesh.msh";

