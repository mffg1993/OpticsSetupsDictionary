# OpticsSetupsDictionary — Optics Figure Library for the Wolfram Language

Publication-ready optics diagrams built in the Wolfram Language (Mathematica): lenses, mirrors, beamsplitters, waveplates, apertures, gratings, detectors, and beam glyphs you can parametrize and assemble into full experimental setups.

[MIT License](LICENSE) · Wolfram Language · Works with notebooks and scripts

---

## Why
I found myself redrawing the same optics blocks for papers, slides, and lab notes. This library turns those into reusable, parametric components so figures are consistent, editable, and export cleanly (PDF/SVG).

## Features
- Parametric **components**: lenses, mirrors, BS cubes/plates, waveplates, apertures, detectors
- **Beams & polarization** glyphs (rays, Gaussian beams, polarization markers)
- **Composable**: assemble complete setups with positions/sizes/labels
- **Export-ready**: vector output (PDF/SVG) with readable fonts/line weights
- **WL-native**: simple Graphics primitives; works in notebooks & scripts

## File structure

- OpticalSetups.m — package with the graphics components

- OpticalSetUps.nb — examples & quick tests

- OpticalSetUps.pdf — static preview of components

## LICENSE — MIT

##Export

Use Export["figure.pdf", graphics] or Export["figure.svg", graphics] for publication-ready vectors.

## Roadmap

Add Jones/Mueller markers for polarization elements

Dimension helpers & snap-to-grid utilities

A paclet for one-line install (PacletInstall["OptiFig"])

## Contributing

Issues and PRs welcome—component requests, new glyphs, or docs fixes.

## Citing

If this library helps your work, please cite:

Ferrer, M. OpticsSetupsDictionary, Wolfram Language library for optics figures. MIT License. GitHub: https://github.com/mffg1993/OpticsSetupsDictionary

License

MIT © Manuel Ferrer
