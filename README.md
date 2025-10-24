
# AgX Based Midi Mapping for Darktable

Use a Behringer X-touch mini for faster editing in Darktable.

---
title: agx-x-touch-mini
id: x-touch
weight: 120
draft: false
author: "people"
---

## Name

xga-x-touch-mini.lua - use an X-Touch Mini controller with Darktable and AgX as the main tone mapper

## Description

The buttons are setup for a workflow left to right, like western reading.
Some modules will still work even though the are not mapped on the board, like Sigmoid and Color zones.

## KEY MAPPING
    Layer A:
      [ Exposure] [ Col. Cal ] [   AgX    ] [ AgX Pre 1 ] [ AgX Preset 1 ] [ AgX Pre Smooth ] [ Primaries  ] [ Color Bal RGB ]
      [ Tone EQ ] [ Color EQ ] [  << Tab  ] [  Tab >>   ] [ Diff Sharpen ] [      Crop      ] [Compres Hist] [  Quick Panel  ]
    Layer B:
      [         ] [          ] [          ] [           ] [              ] [                ] [            ] [               ]
      [         ] [          ] [  << Tab  ] [  Tab >>   ] [              ] [                ] [            ] [               ]

## TRIM INPUTS
When NO module is opened, the eight trims are mapped to work for quick editing.
    Layer A:
        Trim 1: Exposure - exposure
        Trim 2: AgX - curve contrast
        Trim 3: AgX - curve/toe power
        Trim 4: AgX - curve/shoulder power
        Trim 5: AgX - look/saturation
        Trim 6: AgX - look/preserve hue
        Trim 7: Color Calibration - hue
        Trim 8: Color Calibration - chroma
    Layer B:
        Tone Equalizer -8 to +0

When any of the mapped modules are active the trims are adjusting that specific module:

### FIRST ROW
Exposure:
    Layer A:
        Trim 1: Exposure
        Trim 2: Black Level Correction
        Trim 3: Lightness
Color Calibration
    Jump Tabs with [<<] and [>>] OR trim 5
    Layer A: 
        Trim 5: Jump between tabs, push resets to CAT -- This is a really nice feature kept from Diederik's code
        Trim 6: Slider 1 in active tab
        Trim 7: Slider 2 in active tab
        Trim 8: Slider 3 in active tab
AgX
    Jump Tabs with [<<] and [>>]
    Settings Layer A:
        Trim 1: White relative exposure
        Trim 2: Black relative exposure
        Trim 3: Dynamic range scaling
        Trim 4: Pivot input
        Trim 5: Pivot target
        Trim 6: Contrast
        Trim 7: Toe power
        Trim 8: Shoulder power
    Settings Layer B:
        Trim 1: Toe start
        Trim 2: Shoulder
        Trim 3: Curve y gamma
        Trim 4: Slope
        Trim 5: Lift
        Trim 6: Brightness
        Trim 7: Saturation
        Trim 8: Preserve hue
    Primaries Layer A:
        Red attenuation to Master rotation reversal (top eight sliders)
    Primaries Layer B:
        Red purity boost to Blue reverse rotation (bottom six sliders)
AgX 
    Preset 1 (set to your favourite in key mapping)
AgX 
    Preset 2 (set to your favourite in key mapping)
AgX 
    Preset 3 (set to your favourite in key mapping)
Primaries
    Layer A:
      Trim 1: Red hue
      Trim 2: Red purity
      ...and so on
Color Balance RGB
    Layer A:
        hue shift
        global vibrance
        contrast
        linear chhrglobal chroma
        shadows

    Layer B:
        Bottom eight sliders 

### SECOND ROW
Tone Equalizer
    Layer A:
        EV adjustment -8
        EV adjustment -7
        EV adjustment -6
        EV adjustment -5
        EV adjustment -4
        EV adjustment -3
        EV adjustment -2
        EV adjustment -1
        EV adjustment +0
Color Equalizer
    Jump Tabs with [<<] and [>>]
    Layer A:
        Curve adjustment 1
        Curve adjustment 2
        Curve adjustment 3
        Curve adjustment 4
        Curve adjustment 5
        Curve adjustment 6
        Curve adjustment 7
        Curve adjustment 8
[<<]
    Works in both layers
[>>]
    Works in both layers
Diffuse and Sharpen
    Layer A:
        Trim 1: iterations
        Trim 2: central radius
        Trim 3: radius span
        Trim 4: 1st order speed
        Trim 5: 2nd order speed
        Trim 6: 3rd order speed
        Trim 7: 4th order speed
        Trim 8: --
    Layer B:
        Trim 1: 1st order anisotropy
        Trim 2: 2nd order anisotropy
        Trim 3: 3rd order anisotropy
        Trim 4: 4th order anisotropy
        Trim 5: sharpness
        Trim 6: edge sensitivity
        Trim 7: edge threshold
        Trim 8: luminance masking threshold
Crop - No extra input configured
Compress History - Compresses the history instantly
Quick Access Panel - View the Quick Panel. Note that if any module is still open, it will still be the running module.

In Layer B the only buttons in use are [<<] and [>>].


## Usage

* require the lua script from your luarc file or start it from script_manager
* restart darktable if using the luarc file
* Import the `agx-x-touch-key-mapping.cfg` file in Darktable -> Preferences -> Shortcuts

OR, import the `agx-x-touch-key-mapping.cfg` file and use the Lua script manager to add the this script

## Additional Software Required


## Limitations


## Author

Sven Wesley, heavily inspired by Diederik ter Rahe

## Change Log
