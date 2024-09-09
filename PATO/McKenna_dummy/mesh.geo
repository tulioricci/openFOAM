//
cl_fl = 0.0005;
cl_ff = 0.033;
cl_w = 0.0005;

frac = 90;
sin = Sin(Pi/frac);
cos = Cos(Pi/frac);

burner_height = 0.10;
mat_location = burner_height + 0.015;  //arbitrary value

int_radius = 2.38*25.4/2000;
ext_radius = 2.89*25.4/2000;
burner_base_radius = 4.725*25.4/2000;

Point(1)  = {                     0., burner_height        ,                     0., 1.0};
Point(2)  = {         ext_radius*cos, burner_height        ,         ext_radius*sin, 1.0};
Point(3)  = {                     0., burner_height + 0.005,                     0., 2*cl_w};
Point(4)  = {         ext_radius*cos, burner_height + 0.005,         ext_radius*sin, 1.0};
Point(5)  = { burner_base_radius*cos, burner_height + 0.005, burner_base_radius*sin, 1.0};
Point(6)  = { burner_base_radius*cos, burner_height - 0.011, burner_base_radius*sin, 3*cl_fl};
Point(7)  = {         int_radius*cos, burner_height        ,         int_radius*sin, 1.0};
Point(8)  = {         int_radius*cos, burner_height + 0.005,         int_radius*sin, 1.0};

Point(9)  = { burner_base_radius*cos,         0.00, burner_base_radius*sin, 0.2*cl_ff};

Point(10) = {  +1.5*cos,  0.0, 1.5*sin, 2*cl_ff};
Point(11) = {  +1.5*cos, +1.5, 1.5*sin, 3*cl_ff};
Point(12) = {        0., +1.5,      0., 3*cl_ff};

Point(24) = {           0., +0.115,           0., 1};
Point(23) = { 0.015875*cos, +0.115, 0.015875*sin, 1};
Point(22) = { 0.015875*cos, +0.125, 0.015875*sin, 1};
Point(21) = { 0.015875*cos, +0.215, 0.015875*sin, 1};
Point(20) = {           0., +0.215,           0., 1};

mat_BL = 0.003;
Point(25) = {                      0.,  - mat_BL + 0.115,                      0., 2*cl_w};
Point(26) = { (0.015875 + mat_BL)*cos,  - mat_BL + 0.115, (0.015875 + mat_BL)*sin, 1};
Point(27) = { (0.015875 + mat_BL)*cos,           + 0.125, (0.015875 + mat_BL)*sin, 0.5*cl_w};
Point(28) = { (0.015875 + mat_BL)*cos,  + mat_BL + 0.215, (0.015875 + mat_BL)*sin, 0.5*cl_w};
Point(29) = {                      0.,  + mat_BL + 0.215,                      0., 2*cl_w};

Line( 1) = {1, 7};
Line( 2) = {2, 7};
Line( 3) = {2, 4};
Line( 4) = {4, 8};
Line( 5) = {8, 3};

Line( 6) = {3, 1};
Line( 7) = {7, 8};

Line( 8) = {2, 6};
Line( 9) = {5, 6};
Line(10) = {5, 4};


/*Transfinite Line {-1} = 36 Using Bump 0.6;*/
/*Transfinite Line { 5} = 36 Using Bump 0.6;*/
/*Transfinite Line {-2} =  9 Using Bump 0.6;*/
/*Transfinite Line { 4} =  9 Using Bump 0.6;*/

Transfinite Line {-1} = 75 Using Progression 1.01;
Transfinite Line { 5} = 75 Using Progression 1.01;
Transfinite Line {-2} = 19 Using Bump 0.6;
Transfinite Line { 4} = 19 Using Bump 0.6;

/*Transfinite Line {-6} = 23 Using Progression 1.06;*/
/*Transfinite Line { 7} = 23 Using Progression 1.06;*/
/*Transfinite Line { 3} = 23 Using Progression 1.06;*/
/*Transfinite Line { 9} = 23 Using Progression 1.00;*/
Transfinite Line {-6} = 57 Using Progression 1.066;
Transfinite Line { 7} = 57 Using Progression 1.066;
Transfinite Line { 3} = 57 Using Progression 1.066;
Transfinite Line { 9} = 57 Using Progression 1.006;

Transfinite Line {-10} = 41 Using Progression 1.04;
Transfinite Line {  8} = 41 Using Progression 1.04;

Line(20) = { 6,  9};
Line(21) = { 9, 10};
Line(22) = {10, 11};
Line(23) = {11, 12};

Line(24) = {12, 29};
Line(25) = {20, 21};
Line(26) = {21, 22};
Line(27) = {22, 23};
Line(28) = {23, 24};
Line(29) = {24, 25};
Line(30) = {25,  3};
Line(31) = {24, 20};

Line(32) = {25, 26};
Line(33) = {26, 23};
Line(34) = {22, 27};
Line(35) = {27, 26};
Line(36) = {28, 21};
Line(37) = {28, 27};
Line(38) = {29, 28};
Line(39) = {29, 20};

Transfinite Line { 29} = 11 Using Progression 1.1;
Transfinite Line {-33} = 11 Using Progression 1.1;
Transfinite Line { 34} = 11 Using Progression 1.1;
Transfinite Line {-36} = 11 Using Progression 1.1;
Transfinite Line {-39} = 11 Using Progression 1.1;

Transfinite Line {-30} = 17 Using Progression 1.025;

Transfinite Line { 31} = 91 Using Progression 1.01;

Transfinite Line { 28} = 41 Using Progression 1.012;
Transfinite Line {-32} = 41 Using Progression 1.003;

Transfinite Line {-27} = 17 Using Progression 1.04;
Transfinite Line {-35} = 17 Using Progression 1.015;

Transfinite Line {-26} = 91 Using Progression 1.002;
Transfinite Line {-37} = 91 Using Progression 1.002;

Transfinite Line {-25} = 13 Using Progression 1.04;
Transfinite Line {-38} = 13 Using Progression 1.02;

Line Loop(11) = {-5,-4,-10,9,20:24,38,37,35,-32,30};
Plane Surface(1) = {11};
Recombine Surface(1);

Line Loop(12) = {1,7,5,6};
Plane Surface(2) = {12};
Transfinite Surface{2};
Recombine Surface(2);

Line Loop(13) = {-2,3,4,-7};
Plane Surface(3) = {13};
Transfinite Surface{3};
Recombine Surface(3);

Line Loop(14) = {8,-9,10,-3};
Plane Surface(4) = {14};
Transfinite Surface{4};
Recombine Surface(4);

Line Loop(15) = {28,29,32,33};
Plane Surface(5) = {15};
Transfinite Surface{5};
Recombine Surface(5);

Line Loop(16) = {27,-33,-35,-34};
Plane Surface(6) = {16};
Transfinite Surface{6};
Recombine Surface(6);

Line Loop(17) = {37,-34,-26,-36};
Plane Surface(7) = {17};
Transfinite Surface{7};
Recombine Surface(7);

Line Loop(18) = {38,36,-25,-39};
Plane Surface(8) = {18};
Transfinite Surface{8};
Recombine Surface(8);

Line Loop(20) = {25,26,27,28,31};
Plane Surface(10) = {20};
Recombine Surface(10);

Point(104) = {int_radius*cos,   0.000010 + burner_height, int_radius*sin, 1.0};
Point(107) = {            0.,  -0.000200 + mat_location ,             0., 1.0};

/*Mesh 2;*/

Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 1}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 2}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 3}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 4}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 5}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 6}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 7}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{ 8}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{10}; Layers{1}; Recombine; }


Physical Surface("fuel") = {109};
Physical Surface("shield") = {127};
Physical Surface("burner") = {73,149};
Physical Surface("outlet") = {77,81,84};
Physical Surface("f_front") = {1,2,3,4,5,6,7,8};
Physical Surface("f_back") = {101,118,140,162,179,201,223,240};
Physical Surface("s_front") = {10};
Physical Surface("s_back") = {262};
Physical Volume("flow") = {1:8};
Physical Volume("porousMat") = {9};

Mesh 3;
order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;

Save "mesh.msh";
