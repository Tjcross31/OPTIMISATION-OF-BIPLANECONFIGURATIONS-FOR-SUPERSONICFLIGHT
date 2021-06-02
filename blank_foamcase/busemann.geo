// Busemann AIRFOIL MESH -  5%thick
// based on https://github.com/tbellosta/CFD2020/tree/master/DIAMOND

//========================= DOMAIN AND AIRFOIL

R = 3; 		//domain radius
c = 1; 		//chord - could add a lower adjustment
tu = 0.05;	//thickness of upper airfoil
tl = 0.05;	//thickness of lower airfoil

//========================= MESH FINENESSES

meshfarfield = 2.5;	//external mesh size, do not decrease!

// if no transfinite lines 

meshouteruf = 0.1;       //body mesh size
meshouterur = 0.1;       //body mesh size
meshinneru = 0.1;       //body mesh size

meshinnerl = 0.1;       //body mesh size
meshouterlf = 0.1;       //body mesh size
meshouterlr = 0.1;       //body mesh size

//========================= VARIABLE SPACING

//H=0.505; // STANDARD DESIGN CASE
//overall mesh separation - changed from 0.5

H = 0.675;

meshfactor = 0.1;//0.1 with farf 2;	//mesh scaling factor

hl = H/2-tl;//

//========================= OPTIMIZ. GEO VARIABLES

stag = -0.1*c;		//chords, Upper wing stagger (to left)
scale = 1;		//upper airfoil scale / size
//hu = H/2-(scale*tu);
maxthicc = 0.5*c;	//chords maximium thickness position

//========================= POINTS

//farfield
Point(1) = {0, 0, 0, meshfarfield};	//Centerpoint
Point(2) = {R, 0, 0, meshfarfield};
Point(3) = {0, R, 0, meshfarfield};
Point(4) = {-R, 0, 0, meshfarfield};
Point(5) = {0, -R, 0, meshfarfield};

//upper airfoil
Point(6) = {((-c/2)*scale)-stag, H/2, 0, meshouteruf};
Point(7) = {(((-c/2)+maxthicc)*scale)-stag, (H/2)-(scale*tu) , 0, meshinneru};
Point(8) = {((c/2)*scale)-stag, H/2, 0, meshouterur};

//lower airfoil
Point(9) = {-c/2, -H/2, 0, meshouterlf};
Point(10) = {(-c/2)+maxthicc, -hl, 0, meshinnerl};
Point(11) = {c/2, -H/2, 0, meshouterlr};

//========================== LINES

// farfield
Circle(1) = {2, 1, 3};
Circle(2) = {3, 1, 4};
Circle(3) = {4, 1, 5};
Circle(4) = {5, 1, 2};

innerres = Round ((1631.2*(H*H*H*H))-(3482.9*(H*H*H))+(2823.2*(H*H))-(1092.7*H)+229.5);
inner_r = 0.8;

// upper airfoil
Line(5) = {6,7}; //upper front
Transfinite Line {5} = innerres Using Bump inner_r;
Line(6) = {7,8}; //upper rear
Transfinite Line {6} = innerres Using Bump inner_r;

Line(7) = {8,6}; //upper outer
Transfinite Line {7} = 50 Using Bump 0.5;

// lower airfoil
Line(8) = {9,10}; //lower front
Transfinite Line {8} = innerres Using Bump inner_r;
Line(9) = {10,11}; //lower rear
Transfinite Line {9} = innerres Using Bump inner_r;

Line(10) = {11,9}; //lower outer
Transfinite Line {10} = 50 Using Bump 0.5;

//=========================== LOOPS

//farfield
Line Loop(1) = {1,2,3,4};
//airfoil
Line Loop(2) = {5,6,7};
//airfoil
Line Loop(3) = {8,9,10};

//=========================== SURFACES

Plane Surface(1) = {1,2,3};

//=========================== PHYICAL STUFFS

//Physical Surface("Volume") = {1};
Physical Volume("internal") = {1};	//added
Physical Line("FARFIELD") = {1,2,3,4};
Physical Line("UPPER AIRFOIL") = {5,6,7};
Physical Line("LOWER AIRFOIL") = {8,9,10};

//=========================== EXTRUDE

  Extrude {0, 0, 1} {
   Surface{1};
   Layers{1};
   Recombine;
  }

//=========================== LABEL

Physical Surface("upperairfoil") = {41, 49, 45};
Physical Surface("lowerairfoil") = {53, 61, 57};

Physical Surface("front") = {62};
Physical Surface("back") = {1};

Physical Surface("inlet") = {29, 33};
Physical Surface("outlet") = {25, 37};


//=========================== MESH //obselete

Mesh.Algorithm = 2;	//(1: MeshAdapt, 2: Automatic, 3: Initial mesh only, 5: Delaunay, 6: Frontal-Delaunay, 7: BAMG, 8: Frontal-Delaunay for Quads, 9: Packing of Parallelograms)
Mesh.Algorithm3D = 1;	//(1: Delaunay, 3: Initial mesh only, 4: Frontal, 7: MMG3D, 9: R-tree, 10: HXT)

Mesh.CharacteristicLengthFactor = meshfactor; //sets the meshfactor
Mesh 1;
Mesh 2;
Mesh 3;

  Printf("Mesh Size Factor = %g",
	 Mesh.CharacteristicLengthFactor[0]);

  Printf("Prism (cell) count = %g",
	 Mesh.NbPrisms[0]);		// Cell Count

//   Save "t1.msh";

// - In the GUI: open 'File->Export', enter your 'filename.msh' and then pick
//   the version in the dropdown menu.
// - On the command line: use the '-format' option (e.g. 'gsh file.geo -format
