# OpticsSetupsDictionary — Optics Figure Library for the Wolfram Language

<p align="left">
  <a href="https://github.com/mffg1993/OpticsSetupsDictionary/blob/main/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/mffg1993/OpticsSetupsDictionary">
  </a>
  <img alt="Last commit" src="https://img.shields.io/github/last-commit/mffg1993/OpticsSetupsDictionary">
  <img alt="Wolfram Language" src="https://img.shields.io/badge/Wolfram%20Language-library-red">
  <img alt="Mathematica" src="https://img.shields.io/badge/Made%20with-Mathematica-red">
  <!-- Optional placeholders you can enable later -->
  <!-- <a href="https://github.com/mffg1993/OpticsSetupsDictionary/actions/workflows/ci.yml">
    <img alt="CI" src="https://img.shields.io/github/actions/workflow/status/mffg1993/OpticsSetupsDictionary/ci.yml?branch=main">
  </a> -->
  <!-- <a href="https://doi.org/10.xxxx/zenodo.xxxxx">
    <img alt="DOI" src="https://zenodo.org/badge/DOI/10.xxxx/zenodo.xxxxx.svg">
  </a> -->
</p>


Publication-ready optics diagrams built in the Wolfram Language (Mathematica): lenses, mirrors, beamsplitters, waveplates, apertures, gratings, detectors, and beam glyphs you can parametrize and assemble into full experimental setups.


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

## License

This project is licensed under the MIT license 

## Contributing

Issues and PRs welcome—component requests, new glyphs, or docs fixes.

## Citing

If this library helps your work, please cite:

Ferrer, M. OpticsSetupsDictionary, Wolfram Language library for optics figures. MIT License. GitHub: https://github.com/mffg1993/OpticsSetupsDictionary

