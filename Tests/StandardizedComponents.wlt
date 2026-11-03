(* Wolfram Language MUnit tests for the opt-in geometry library. *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "CurrentVersion", "OpticalComponentsV2.wl"}]];

VerificationTest[
  OpticsSetupsV2`OpticalDirection[0],
  {1,0,0},
  TestID -> "default-axis-plus-x"
]
VerificationTest[
  Chop[OpticsSetupsV2`OpticalDirection[Pi/2]],
  {0,1,0},
  TestID -> "yaw-about-z"
]
VerificationTest[
  Chop[OpticsSetupsV2`OpticalDirection[{0,Pi/2,0}]],
  {0,0,-1},
  TestID -> "pitch-about-y"
]
VerificationTest[
  Chop[OpticsSetupsV2`OpticalRotationMatrix[{0,0,Pi/2}].{0,1,0}],
  {0,0,1},
  TestID -> "roll-about-x"
]
VerificationTest[
  Chop[OpticsSetupsV2`OpticalTransform[{2,3,4},{Pi/3,Pi/5,Pi/7}][
    {0,0,OpticsSetupsV2`$OpticalAxisHeight}]],
  {2,3,4+OpticsSetupsV2`$OpticalAxisHeight},
  TestID -> "optical-center-stays-fixed-under-rotation"
]
VerificationTest[
  OpticsSetupsV2`OpticalTransform[{2,3,4},0][{0,0,0}],
  {2,3,4},
  TestID -> "identity-rotation-position-reference"
]
VerificationTest[
  Head[OpticsSetupsV2`Slit[{1,2,0},Pi/2]],
  Graphics3D,
  TestID -> "slit-rotation-is-accepted"
]
VerificationTest[
  Head[OpticsSetupsV2`StageXYSq["Position"->{3,4,0},"Rotation"->Pi/6]],
  Graphics3D,
  TestID -> "xy-stage-pose"
]
VerificationTest[
  And@@(Head[
    OpticsSetupsV2`OpticalComponent[#, "Position"->{0,0,0},"Rotation"->{0,0,0}]
   ]===Graphics3D& /@ {
    "Mirror","Beamsplitter","Lens","QWP","HWP","Polarizer","Iris",
    "Slit","GlassSlide","LaserCyl","CCD","RotStage","PRISM"
   }),
  True,
  TestID -> "cross-component-graphics-output"
]
VerificationTest[
  MatchQ[First[OpticsSetupsV2`CCD[{1,1,0},Pi/3]],_GeometricTransformation],
  True,
  TestID -> "entire-device-transformed-together"
]
