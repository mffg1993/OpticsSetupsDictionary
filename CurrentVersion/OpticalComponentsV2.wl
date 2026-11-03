(* ::Package:: *)
(* Standardized, opt-in optical setup primitives. No legacy files are modified. *)

BeginPackage["OpticsSetupsV2`"];
$OpticalAxisHeight::usage = "Default height of the optical axis above Position (0.5).";
OpticalRotationMatrix::usage = "OpticalRotationMatrix[rotation] returns a Z-Y-X rotation matrix. Rotation is yaw or {yaw,pitch,roll}, in radians.";
OpticalTransform::usage = "OpticalTransform[position,rotation] rotates about the optical center and translates to the supplied table-footpoint Position.";
OpticalDirection::usage = "OpticalDirection[rotation] is the rotated +X optical axis.";
PlacedGraphics::usage = "PlacedGraphics[primitives,position,rotation] transforms local Graphics3D primitives.";
OpticalComponent::usage = "OpticalComponent[type,options] creates an element using standardized Position and Rotation options.";
PLATE::usage = "Standardized PLATE component. Accepts legacy positional arguments or string options.";
PRISM::usage = "Standardized PRISM component. Accepts legacy positional arguments or string options.";
PRISM2::usage = "Standardized PRISM2 component. Accepts legacy positional arguments or string options.";
PRISM3::usage = "Standardized PRISM3 component. Accepts legacy positional arguments or string options.";
LaserCyl::usage = "Standardized LaserCyl component. Accepts legacy positional arguments or string options.";
LaserSquare::usage = "Standardized LaserSquare component. Accepts legacy positional arguments or string options.";
M::usage = "Standardized M component. Accepts legacy positional arguments or string options.";
BS::usage = "Standardized BS component. Accepts legacy positional arguments or string options.";
Lens::usage = "Standardized Lens component. Accepts legacy positional arguments or string options.";
AsphericLens::usage = "Standardized AsphericLens component. Accepts legacy positional arguments or string options.";
AsphericLens2::usage = "Standardized AsphericLens2 component. Accepts legacy positional arguments or string options.";
AsphericLens22::usage = "Standardized AsphericLens22 component. Accepts legacy positional arguments or string options.";
QW::usage = "Standardized QW component. Accepts legacy positional arguments or string options.";
HW::usage = "Standardized HW component. Accepts legacy positional arguments or string options.";
PP::usage = "Standardized PP component. Accepts legacy positional arguments or string options.";
Pol::usage = "Standardized Pol component. Accepts legacy positional arguments or string options.";
Iris::usage = "Standardized Iris component. Accepts legacy positional arguments or string options.";
GlassSlide::usage = "Standardized GlassSlide component. Accepts legacy positional arguments or string options.";
Slit::usage = "Standardized Slit component. Accepts legacy positional arguments or string options.";
SLM::usage = "Standardized SLM component. Accepts legacy positional arguments or string options.";
OpticalTable::usage = "Standardized OpticalTable component. Accepts legacy positional arguments or string options.";
XStage::usage = "Standardized XStage component. Accepts legacy positional arguments or string options.";
YStage::usage = "Standardized YStage component. Accepts legacy positional arguments or string options.";
ZStage::usage = "Standardized ZStage component. Accepts legacy positional arguments or string options.";
StageXYSq::usage = "Standardized StageXYSq component. Accepts legacy positional arguments or string options.";
RotStage::usage = "Standardized RotStage component. Accepts legacy positional arguments or string options.";
CCD::usage = "Standardized CCD component. Accepts legacy positional arguments or string options.";
SimpleCCD::usage = "Standardized SimpleCCD component. Accepts legacy positional arguments or string options.";
WFS::usage = "Standardized WFS component. Accepts legacy positional arguments or string options.";
DefM::usage = "Standardized DefM component. Accepts legacy positional arguments or string options.";
Begin["`Private`"];
$OpticalAxisHeight=0.5;
h[]:=$OpticalAxisHeight;
niceBlue=RGBColor[2/5,178/255,1];
babyBlue=RGBColor[102/255,178/255,1];
steel=RGBColor[210/255,210/255,210/255];

OpticalRotationMatrix::invalid="Rotation must be a numeric yaw or a numeric {yaw,pitch,roll}; received `1`.";
OpticalTransform::invalid="Position must be a numeric three-vector; received `1`.";
angles[a_?NumericQ]:={a,0,0};
angles[a:{_?NumericQ,_?NumericQ,_?NumericQ}]:=a;
angles[a_]:=(Message[OpticalRotationMatrix::invalid,a];$Failed);

OpticalRotationMatrix[rot_]:=Module[{a=angles[rot]},
 If[a===$Failed,Return[$Failed]];
 RotationMatrix[a[[1]],{0,0,1}].
  RotationMatrix[a[[2]],{0,1,0}].
  RotationMatrix[a[[3]],{1,0,0}]
];
OpticalTransform[pos_,rot_:0]:=Module[{r,c},
 If[!MatchQ[pos,{_?NumericQ,_?NumericQ,_?NumericQ}],
   Message[OpticalTransform::invalid,pos];Return[$Failed]];
 r=OpticalRotationMatrix[rot];
 If[r===$Failed,Return[$Failed]];
 c={0,0,h[]};
 AffineTransform[{r,pos+c-r.c}]
];
OpticalDirection[rot_:0]:=Module[{r=OpticalRotationMatrix[rot]},
 If[r===$Failed,$Failed,r.{1,0,0}]
];
PlacedGraphics[primitives_,pos_:{0,0,0},rot_:0]:=Module[{t=OpticalTransform[pos,rot]},
 If[t===$Failed,Return[$Failed]];
 Graphics3D[GeometricTransformation[primitives,t],Boxed->False,Lighting->"Neutral"]
];

(* LOCAL REFERENCE: +X optical axis, +Y transverse, +Z vertical.
   Position={x,y,z} is the table-footpoint directly below the optical center.
   Rotation=yaw (about Z), or {yaw,pitch,roll} with Z-Y-X composition.
   All rotations pivot about the optical center at {0,0,$OpticalAxisHeight}. *)
disk[rad_,len_]:=Cylinder[{{-len/2,0,h[]},{len/2,0,h[]}},rad];
block[{dx_,dy_,dz_}]:=Cuboid[{-dx/2,-dy/2,h[]-dz/2},{dx/2,dy/2,h[]+dz/2}];
ring[x_,rad_]:=Tube[Table[{x,rad Cos[t],h[]+rad Sin[t]},{t,0,2 Pi,Pi/32}],0.045];
colorFor[type_]:=Switch[type,
 "LaserCyl"|"LaserSquare",Darker[Cyan,0.6],
 "Mirror"|"PLATE"|"PRISM"|"PRISM2"|"PRISM3",Gray,
 "Beamsplitter"|"Lens"|"AsphericLens"|"AsphericLens2"|"AsphericLens22"|"GlassSlide",babyBlue,
 "QWP",Darker[Green],"HWP",babyBlue,"PhasePlate",Orange,
 "Polarizer",niceBlue,"Iris",Cyan,"Slit",RGBColor[0,0.6,0.6],
 "SLM",Darker[Gray],"CCD"|"SimpleCCD",Darker[niceBlue],
 "WFS",Orange,"DefM",Cyan,"OpticalTable",steel,_,Gray];

Options[OpticalComponent]={
 "Position"->{0,0,0},"Rotation"->0,"Dimensions"->{1,1,1},
 "Radius"->0.5,"Length"->0.2,"Opacity"->0.7,"Color"->Automatic,
 "PolarizationAngle"->0,"Hologram"->None,
 "Curvature"->-0.2,"Conic"->0.2};
OpticalComponent::unknown="Unrecognized optical component type `1`.";

OpticalComponent[type_String,opts:OptionsPattern[]]:=
 Module[{pos,rot,dim,rad,len,op,pol,holo,c,k,col,parts,plot,arrow},
 {pos,rot,dim,rad,len,op,pol,holo,c,k}=
  OptionValue[{"Position","Rotation","Dimensions","Radius","Length",
   "Opacity","PolarizationAngle","Hologram","Curvature","Conic"}];
 col=Replace[OptionValue["Color"],Automatic:>colorFor[type]];
 If[type==="AsphericLens",
   (* The sag direction is the local optical (+X) axis. *)
   plot=ParametricPlot3D[
     {c s^2 (1+Sqrt[1-(1+k)c^2 s^2]),s Cos[t],h[]+s Sin[t]},
     {s,0,rad},{t,0,2 Pi},Mesh->None,PlotPoints->30,
     PlotStyle->Directive[col,Opacity[op]]];
   Return[PlacedGraphics[First[plot],pos,rot]]
 ];
 parts=Switch[type,
  "PLATE"|"Mirror"|"QWP"|"HWP"|"PhasePlate"|"AsphericLens2"|"AsphericLens22",
    {col,Opacity[op],disk[rad,If[type==="AsphericLens22",0.075,len]]},
  "PRISM"|"PRISM2"|"PRISM3",
    {col,Opacity[op],EdgeForm[Thin],block[dim]},
  "LaserCyl",
    {Darker[Gray],Opacity[1],
      Cylinder[{{-0.65,0,h[]},{0.35,0,h[]}},0.37],
      Cylinder[{{0.35,0,h[]},{0.47,0,h[]}},0.28]},
  "LaserSquare",
    {col,Opacity[1],block[{1.1,0.9,0.9}],Darker[Cyan],
      Cylinder[{{0.55,0,h[]},{0.7,0,h[]}},0.36]},
  "Beamsplitter",
    {col,Opacity[0.22],block[{1,1,1}],Gray,Opacity[0.45],
      Polygon[{{-0.5,-0.5,h[]-0.5},{0.5,0.5,h[]-0.5},
        {0.5,0.5,h[]+0.5},{-0.5,-0.5,h[]+0.5}}]},
  "Lens",
    {col,Opacity[op],Ellipsoid[{0,0,h[]},{0.12,rad,rad}]},
  "Polarizer",
    (arrow={0,Cos[pol],Sin[pol]};
     {col,Opacity[0.35],disk[rad,len],
      Darker[niceBlue],Opacity[1],Arrowheads[0.08],
      Arrow[{{0,0,h[]}-0.65 arrow,{0,0,h[]}+0.65 arrow}]}),
  "Iris",
    {Darker[col],Opacity[1],Tube[
       Table[{0,0.3 Cos[t],h[]+0.3 Sin[t]},{t,0,2 Pi,Pi/32}],0.08]},
  "GlassSlide",
    {col,Opacity[op],block[{0.12,1,0.8}]},
  "Slit",
    {col,Opacity[1],
      Cuboid[{-0.1,-0.5,h[]-0.5},{0.1,-0.07,h[]+0.5}],
      Cuboid[{-0.1,0.07,h[]-0.5},{0.1,0.5,h[]+0.5}]},
  "SLM",
    Join[{Darker[Gray],Opacity[1],block[{0.18,1.4,1}],
      Darker[col],Cuboid[{-0.01,-0.65,h[]-0.45},{0.15,0.65,h[]+0.45}]},
     If[holo===None,{},
      With[{im=If[StringQ[holo],Import[holo],holo]},
        {Texture[im],Polygon[
         {{0.16,-0.6,h[]-0.4},{0.16,0.6,h[]-0.4},
          {0.16,0.6,h[]+0.4},{0.16,-0.6,h[]+0.4}},
          VertexTextureCoordinates->{{0,0},{1,0},{1,1},{0,1}}]}]]],
  "XStage"|"YStage"|"ZStage",
    {Gray,Opacity[1],Cuboid[{-1.5,-1.5,-0.4},{1.5,1.5,-0.25}],
     Darker[Gray],Cuboid[{-1,-0.6,-0.2},{1,0.6,-0.05}],
     Lighter[Blue],Arrowheads[0.06],Arrow[
       Switch[type,"XStage",{{-1.3,0.8,0.3},{1.3,0.8,0.3}},
        "YStage",{{0.8,-1.3,0.3},{0.8,1.3,0.3}},
        "ZStage",{{0.8,1,0},{0.8,1,1}}]]},
  "StageXYSq",
    {Gray,Opacity[1],Cuboid[{-1.5,-1.5,-0.3},{1.5,1.5,0.3}],
     Darker[Gray],Cuboid[{-0.9,-0.9,0.3},{0.9,0.9,0.5}],
     Tube[{{0.5,-2,-0.5},{0.5,-0.3,-0.5},{0.5,0,-0.5}},0.12],
     Tube[{{-2,0.5,-0.5},{-0.3,0.5,-0.5},{0,0.5,-0.5}},0.12]},
  "RotStage",
    {Gray,Opacity[1],Cylinder[{{0,0,0},{0,0,0.15}},0.6],
     Darker[Gray],Cylinder[{{0,0,0.15},{0,0,0.25}},0.4]},
  "CCD"|"SimpleCCD"|"WFS"|"DefM",
    {col,Opacity[1],block[{1,1,1}],Darker[Gray],
     Cylinder[{{0.5,0,h[]},{0.65,0,h[]}},0.39],
     ring[0.65,0.36],
     Cylinder[{{0.65,0,h[]},{0.78,0,h[]}},0.27]},
  "OpticalTable",
    {col,Opacity[1],Cuboid[{-dim[[1]]/2,-dim[[2]]/2,-Abs[len]},
       {dim[[1]]/2,dim[[2]]/2,0}]},
  _,Message[OpticalComponent::unknown,type];Return[$Failed]
 ];
 PlacedGraphics[parts,pos,rot]
];

(* Existing positional call names are available in this separate context.
   New string-option calls give every component identical pose controls. *)
Options[PLATE]=Options[OpticalComponent];
PLATE[opts:OptionsPattern[]]:=OpticalComponent["PLATE",opts];
PLATE[p:{_,_,_},yaw_:0]:=OpticalComponent["PLATE","Position"->p,"Rotation"->yaw];
Options[PRISM]=Options[OpticalComponent];
PRISM[opts:OptionsPattern[]]:=OpticalComponent["PRISM",opts];
PRISM[p:{_,_,_},yaw_:0]:=OpticalComponent["PRISM","Position"->p,"Rotation"->yaw];
Options[PRISM2]=Options[OpticalComponent];
PRISM2[opts:OptionsPattern[]]:=OpticalComponent["PRISM2",opts];
PRISM2[p:{_,_,_},yaw_:0]:=OpticalComponent["PRISM2","Position"->p,"Rotation"->yaw];
Options[PRISM3]=Options[OpticalComponent];
PRISM3[opts:OptionsPattern[]]:=OpticalComponent["PRISM3",opts];
PRISM3[p:{_,_,_},yaw_:0]:=OpticalComponent["PRISM3","Position"->p,"Rotation"->yaw];
Options[LaserCyl]=Options[OpticalComponent];
LaserCyl[opts:OptionsPattern[]]:=OpticalComponent["LaserCyl",opts];
LaserCyl[p:{_,_,_},yaw_:0]:=OpticalComponent["LaserCyl","Position"->p,"Rotation"->yaw];
Options[LaserSquare]=Options[OpticalComponent];
LaserSquare[opts:OptionsPattern[]]:=OpticalComponent["LaserSquare",opts];
LaserSquare[p:{_,_,_},yaw_:0]:=OpticalComponent["LaserSquare","Position"->p,"Rotation"->yaw];
Options[M]=Options[OpticalComponent];
M[opts:OptionsPattern[]]:=OpticalComponent["Mirror",opts];
M[p:{_,_,_},yaw_:0]:=OpticalComponent["Mirror","Position"->p,"Rotation"->yaw];
Options[BS]=Options[OpticalComponent];
BS[opts:OptionsPattern[]]:=OpticalComponent["Beamsplitter",opts];
BS[p:{_,_,_},yaw_:0]:=OpticalComponent["Beamsplitter","Position"->p,"Rotation"->yaw];
Options[Lens]=Options[OpticalComponent];
Lens[opts:OptionsPattern[]]:=OpticalComponent["Lens",opts];
Lens[p:{_,_,_},yaw_:0]:=OpticalComponent["Lens","Position"->p,"Rotation"->yaw];
Options[QW]=Options[OpticalComponent];
QW[opts:OptionsPattern[]]:=OpticalComponent["QWP",opts];
QW[p:{_,_,_},yaw_:0]:=OpticalComponent["QWP","Position"->p,"Rotation"->yaw];
Options[HW]=Options[OpticalComponent];
HW[opts:OptionsPattern[]]:=OpticalComponent["HWP",opts];
HW[p:{_,_,_},yaw_:0]:=OpticalComponent["HWP","Position"->p,"Rotation"->yaw];
Options[Iris]=Options[OpticalComponent];
Iris[opts:OptionsPattern[]]:=OpticalComponent["Iris",opts];
Iris[p:{_,_,_},yaw_:0]:=OpticalComponent["Iris","Position"->p,"Rotation"->yaw];
Options[GlassSlide]=Options[OpticalComponent];
GlassSlide[opts:OptionsPattern[]]:=OpticalComponent["GlassSlide",opts];
GlassSlide[p:{_,_,_},yaw_:0]:=OpticalComponent["GlassSlide","Position"->p,"Rotation"->yaw];
Options[Slit]=Options[OpticalComponent];
Slit[opts:OptionsPattern[]]:=OpticalComponent["Slit",opts];
Slit[p:{_,_,_},yaw_:0]:=OpticalComponent["Slit","Position"->p,"Rotation"->yaw];
Options[XStage]=Options[OpticalComponent];
XStage[opts:OptionsPattern[]]:=OpticalComponent["XStage",opts];
XStage[p:{_,_,_},yaw_:0]:=OpticalComponent["XStage","Position"->p,"Rotation"->yaw];
Options[YStage]=Options[OpticalComponent];
YStage[opts:OptionsPattern[]]:=OpticalComponent["YStage",opts];
YStage[p:{_,_,_},yaw_:0]:=OpticalComponent["YStage","Position"->p,"Rotation"->yaw];
Options[ZStage]=Options[OpticalComponent];
ZStage[opts:OptionsPattern[]]:=OpticalComponent["ZStage",opts];
ZStage[p:{_,_,_},yaw_:0]:=OpticalComponent["ZStage","Position"->p,"Rotation"->yaw];
Options[StageXYSq]=Options[OpticalComponent];
StageXYSq[opts:OptionsPattern[]]:=OpticalComponent["StageXYSq",opts];
StageXYSq[p:{_,_,_},yaw_:0]:=OpticalComponent["StageXYSq","Position"->p,"Rotation"->yaw];
Options[RotStage]=Options[OpticalComponent];
RotStage[opts:OptionsPattern[]]:=OpticalComponent["RotStage",opts];
RotStage[p:{_,_,_},yaw_:0]:=OpticalComponent["RotStage","Position"->p,"Rotation"->yaw];
Options[CCD]=Options[OpticalComponent];
CCD[opts:OptionsPattern[]]:=OpticalComponent["CCD",opts];
CCD[p:{_,_,_},yaw_:0]:=OpticalComponent["CCD","Position"->p,"Rotation"->yaw];
Options[SimpleCCD]=Options[OpticalComponent];
SimpleCCD[opts:OptionsPattern[]]:=OpticalComponent["SimpleCCD",opts];
SimpleCCD[p:{_,_,_},yaw_:0]:=OpticalComponent["SimpleCCD","Position"->p,"Rotation"->yaw];
Options[WFS]=Options[OpticalComponent];
WFS[opts:OptionsPattern[]]:=OpticalComponent["WFS",opts];
WFS[p:{_,_,_},yaw_:0]:=OpticalComponent["WFS","Position"->p,"Rotation"->yaw];
Options[DefM]=Options[OpticalComponent];
DefM[opts:OptionsPattern[]]:=OpticalComponent["DefM",opts];
DefM[p:{_,_,_},yaw_:0]:=OpticalComponent["DefM","Position"->p,"Rotation"->yaw];

Options[PP]=Options[OpticalComponent];
PP[opts:OptionsPattern[]]:=OpticalComponent["PhasePlate",opts];
PP[p:{_,_,_},yaw_:0,color_:Orange]:=
 OpticalComponent["PhasePlate","Position"->p,"Rotation"->yaw,"Color"->color];
Options[Pol]=Options[OpticalComponent];
Pol[opts:OptionsPattern[]]:=OpticalComponent["Polarizer",opts];
Pol[p:{_,_,_},alpha_:0,yaw_:0]:=
 OpticalComponent["Polarizer","Position"->p,"Rotation"->yaw,"PolarizationAngle"->alpha];
Options[SLM]=Options[OpticalComponent];
SLM[opts:OptionsPattern[]]:=OpticalComponent["SLM",opts];
SLM[p:{_,_,_},hologram_,yaw_:0]:=
 OpticalComponent["SLM","Position"->p,"Rotation"->yaw,"Hologram"->hologram];
Options[AsphericLens]=Options[OpticalComponent];
AsphericLens[opts:OptionsPattern[]]:=OpticalComponent["AsphericLens",opts];
AsphericLens[p:{_,_,_},c_:-0.2,k_:0.2,op_:0.7]:=
 OpticalComponent["AsphericLens","Position"->p,"Curvature"->c,"Conic"->k,"Opacity"->op];
Options[AsphericLens2]=Options[OpticalComponent];
AsphericLens2[opts:OptionsPattern[]]:=OpticalComponent["AsphericLens2",opts];
AsphericLens2[p:{_,_,_},radius_]:=
 OpticalComponent["AsphericLens2","Position"->p,"Radius"->radius];
Options[AsphericLens22]=Options[OpticalComponent];
AsphericLens22[opts:OptionsPattern[]]:=OpticalComponent["AsphericLens22",opts];
AsphericLens22[p:{_,_,_},radius_]:=
 OpticalComponent["AsphericLens22","Position"->p,"Radius"->radius];
Options[OpticalTable]=Options[OpticalComponent];
OpticalTable[opts:OptionsPattern[]]:=OpticalComponent["OpticalTable",opts];
OpticalTable[size:{_,_},thickness_:-0.2]:=
 OpticalComponent["OpticalTable","Dimensions"->Append[size,0],"Length"->Abs[thickness]];
End[];
EndPackage[];
