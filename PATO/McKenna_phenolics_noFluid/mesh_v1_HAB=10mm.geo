clF = 0.006400;
clB = 0.001500;
clM = 0.001500;
clS = 0.000850;
cl0 = 0.014400;
cl1 = 0.048000;
cl2 = 0.072000;

frac = 90;
sin = Sin(Pi/frac);
cos = Cos(Pi/frac);


burner_height = 0.10;

mat_location = burner_height + 0.010;  //arbitrary value
mat_wide = 0.5*1.25*25.4/1000;
mat_thick = 15.0/32.0*25.4/1000;
insulator = 1.00*25.4/1000 + mat_thick;
insulator_wide = 0.5*1.00*25.4/1000;
mat_holder = 1.75*25.4/1000 + mat_thick;


Point(11) = {         0.0, mat_location            ,           0., 0.7*clS};
Point(12) = {mat_wide*cos, mat_location            , mat_wide*sin,     1.0};
Point(13) = {mat_wide*cos, mat_location + mat_thick, mat_wide*sin,     1.0};
Point(14) = {mat_wide*cos, mat_location + insulator, mat_wide*sin,     1.0};
Point(15) = {mat_wide*cos,            mat_location + 1.*mat_holder, mat_wide*sin, 1.0};
Point(16) = {         0.0,            mat_location + 1.*mat_holder,           0., 0.78*clM};

delta_mat = mat_wide - insulator_wide;
Point(50) = {insulator_wide*cos, mat_location + mat_holder - delta_mat, insulator_wide*sin, 0.9*clM};
Point(51) = {insulator_wide*cos, mat_location + insulator, insulator_wide*sin, 0.9*clM};
Point(52) = {               0.0, mat_location + insulator,                 0., 1.0*clM};
Point(53) = {               0.0, mat_location + mat_thick,                 0., 0.6*clM};
Point(54) = {insulator_wide*cos, mat_location + mat_thick, insulator_wide*sin, 0.3*clM};
Point(55) = {insulator_wide*cos, mat_location + delta_mat, insulator_wide*sin, 0.3*clM};
Point(56) = {               0.0, mat_location + delta_mat,                 0., 0.3*clM};
Point(57) = {               0.0, mat_location + mat_holder - delta_mat,    0., 0.9*clM};




Line(51) = {11, 12};
Line(54) = {12, 13};
Line(55) = {13, 14};
Line(56) = {14, 15};
Line(57) = {15, 16};

Line( 90) = {51, 50};
Line( 91) = {11, 56};
Line( 93) = {56, 53};
Line( 94) = {54, 13};
Line( 95) = {16, 57};
Line( 96) = {51, 52};
Line( 97) = {52, 53};
Line( 98) = {53, 54};
Line( 99) = {54, 51};
Line(100) = {54, 55};
Line(101) = {55, 56};
Line(102) = {55, 12};
Line(103) = {57, 52};
Line(104) = {57, 50};
Line(105) = {50, 15};




/*material*/
Transfinite Line { 26} = 29 Using Progression 1.012;
Transfinite Line { 54} = 29 Using Progression 1.025;
Transfinite Line {-100} = 29 Using Progression 1.02;

Transfinite Line { 27} = 31 Using Progression 1.02;
Transfinite Line { 55} = 31 Using Progression 1.02;
Transfinite Line { 99} = 31 Using Progression 1.02;

Transfinite Line {-28} = 25 Using Progression 1.012;
Transfinite Line {-56} = 25 Using Progression 1.025;
Transfinite Line {-90} = 25 Using Progression 1.0;

Transfinite Line { 57} = 21 Using Progression 1.0;
Transfinite Line {104} = 21 Using Progression 1.0;
Transfinite Line {-29} = 21 Using Progression 1.02;

Transfinite Line {-72} = 21 Using Progression 1.02;

Transfinite Line { 30} = 51 Using Progression 1.01;

Transfinite Line { 69} = 59 Using Progression 1.018;
Transfinite Line {-70} = 55 Using Progression 1.0;
Transfinite Line {-71} = 31 Using Progression 1.0;
Transfinite Line {-81} = 83 Using Progression 1.004;

Transfinite Line {  91, -94, 95, -102, -105} = 15 Using Progression 1.066;


Transfinite Line {  1} = 5 Using Progression 1.00;
Transfinite Line { 67} = 5 Using Progression 1.00;
Transfinite Line {  7} = 17 Using Bump 0.6;
Transfinite Line { 76} = 17 Using Bump 0.6;
Transfinite Line {  2} = 33 Using Progression 1.015;
Transfinite Line { 77} = 33 Using Progression 1.015;

Transfinite Line {  5} = 41 Using Progression 1.002;
Transfinite Line {-23} = 41 Using Progression 1.002;
Transfinite Line {-51} = 41 Using Progression 1.010;
Transfinite Line {101} = 41 Using Progression 1.015;


/*Sample*/
Line Loop(1) = {100,101,93,98};
Plane Surface(1) = {1};

Line Loop(2) = {100,102,54,-94};
Plane Surface(2) = {-2};
Transfinite Surface {2} Left;
Recombine Surface(2);

Line Loop(3) = {102,-51,91,-101};
Plane Surface(3) = {3};
Transfinite Surface {3} Right;
Recombine Surface(3);

/*Alumina*/
Line Loop(4) = {96,97,98,99};
Plane Surface(4) = {-4};

/*Graphite*/
Line Loop(5) = {-94,99,90,105,-56,-55};
Plane Surface(5) = {5};
Transfinite Surface {5} = {50,15,13,54};
Recombine Surface(5);

Line Loop(6) = {104, 95, 57, 105};
Plane Surface(6) = {-6};
Transfinite Surface {6};
Recombine Surface(6);

Line Loop(7) = {96, -103, 104, -90};
Plane Surface(7) = {7};


Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{1}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{2}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{3}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{4}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{5}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{6}; Layers{1}; Recombine; }
Extrude {{0,1,0}, {0,0,0}, 2*Pi/frac} { Surface{7}; Layers{1}; Recombine; }


Physical Surface("s_front") = {1:3};
Physical Surface("s_back") = {122, 144, 161};
Physical Surface("porousMat_to_flow") = {135,156};
Physical Surface("a_front") = {4};
Physical Surface("a_back") = {178};
Physical Surface("g_front") = {5:7};
Physical Surface("g_back") = {210,227,244};
Physical Surface("graphite_to_flow") = {205,209,219};
Physical Volume("porousMat") = {1:3};
Physical Volume("alumina") = {4};
Physical Volume("graphite") = {5:7};

Mesh 3;
//order = 1;
//SetOrder order;
//Mesh.MshFileVersion = 2.2;
//Save "mesh.msh";
