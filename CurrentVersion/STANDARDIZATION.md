# Optical component conventions — experimental V2

This branch adds an **opt-in** Wolfram Language package, `OpticalComponentsV2.wl`. Existing `OpticalElementDictionary-March2026.m` and `.wl` files, and the notebooks, are left untouched so old figure layouts do not silently change.

## Shared coordinate system

All standardized elements use the same **local reference frame**:

| Item | Convention |
| --- | --- |
| `"Position" -> {x,y,z}` | Reference point on the component's base plane, directly below the default optical center |
| Local optical center | `{0,0,$OpticalAxisHeight}`, where `$OpticalAxisHeight = 0.5` by default |
| Local optical axis | `+X` |
| Local transverse direction | `+Y` |
| Local vertical direction | `+Z` |
| `"Rotation" -> yaw` | Counterclockwise rotation about world/local `+Z` (radians) |
| `"Rotation" -> {yaw,pitch,roll}` | Active rotations in **Z–Y–X** matrix order, about the **optical center** |
| Units | Arbitrary diagram units; angles in radians (`30 Degree` is valid Mathematica input) |

The transformation is

```text
worldPoint = Position + opticalCenter + R . (localPoint - opticalCenter)
R = Rz(yaw) . Ry(pitch) . Rx(roll)
```

It is implemented by `OpticalTransform[position,rotation]`; use `OpticalDirection[rotation]` to get the component's orientation vector.

## Quick start

Run from the repository root in Mathematica:

```wolfram
Get["CurrentVersion/OpticalComponentsV2.wl"];

Show[
  OpticsSetupsV2`LaserCyl[{0, 0, 0}, 0],
  OpticsSetupsV2`BS[{2, 0, 0}, Pi/4],
  OpticsSetupsV2`QW[{3, 0, 0}, 0],
  OpticsSetupsV2`CCD[{5, 0, 0}, Pi]
]
```

Or use the uniform, option-based API:

```wolfram
Show[
  OpticsSetupsV2`OpticalComponent["Lens",
    "Position" -> {0, 0, 0}, "Rotation" -> {30 Degree, 0, 0},
    "Radius" -> 0.7],
  OpticsSetupsV2`OpticalComponent["Slit",
    "Position" -> {2, 0, 0}, "Rotation" -> {0, 20 Degree, 0}]
]
```

Option-style calls also work with the familiar component names, for example:

```wolfram
OpticsSetupsV2`HW["Position" -> {1, 2, 0}, "Rotation" -> {Pi/4, 0, Pi/6}]
```

For SLMs:

```wolfram
OpticsSetupsV2`SLM[{0, 0, 0}, "hologram.png", 45 Degree]
```

The path for a hologram is resolved from the Mathematica working directory, as in the legacy implementation. An `Image` can also be passed through `"Hologram"`.

## Coverage

The V2 package includes circular and rectangular primitives; laser sources; mirror, beamsplitter, lens, aspheric surface, quarter-/half-wave plates, phase plate, polarizer, iris, glass slide and slit; SLM; X/Y/Z/XY and rotation stages; CCD, WFS and deformable-mirror device shapes; and an optical table.

All these use the **same** placement routine, including sub-objects such as front-facing camera rings, SLM displays, aperture frames, stage arrows, and XY-stage handles. Their local geometry is translated and rotated *as a single assembly*.

## Migration notes and important limitations

- **Not pixel-perfect backwards compatibility.** The familiar positional signatures are present, but some old objects had inconsistent centers, dimensions, or axes, and those geometries have intentionally been normalized. Compare an existing notebook's figure visually before replacing the old package.
- The V2 package is in its own OpticsSetupsV2 package context to avoid overriding old Global-context definitions. Call it with its qualified name if both versions are loaded.
- `PRISM2` is now a normal rectangular body with the shared yaw/pitch/roll convention; its previous custom tilt behavior is not retained.
- `"Position"` is **not** the center of the 3D bounding box: it is the base-plane reference point. Changing `$OpticalAxisHeight` changes the default vertical offset for optical elements.
- Plate `"Rotation"` controls the **orientation of its normal**. Waveplates now show a small fast-axis marker; rotate this marker about the optical axis using the third component (roll), e.g. `{0,0,30 Degree}`. `Pol` also has an independent `"PolarizationAngle"`.
- Source/SLM/camera shapes are schematic rather than metrically accurate device models.
- This package has not been rendered/tested in a Wolfram kernel in this environment. Unit tests are provided for execution in Mathematica.

## Tests

From the repository root, evaluate:

```wolfram
TestReport["Tests/StandardizedComponents.wlt"]
```

The tests cover rotation order, optical-center pivoting, translations, consistent output types, and a basic range of components. Visual review remains important because the project produces publication illustrations.
