--[[
    This file is part of darktable,
    copyright (c) 2023 Diederik ter Rahe
    copyright (c) 2025 Sven Wesley

    darktable is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    darktable is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with darktable.  If not, see <http://www.gnu.org/licenses/>.
]]
--[[
X-Touch Mini flexible midi mapping with focus on AgX.

The buttons are setup for a workflow left to right, like western reading.
Some modules will still work even though the are not mapped on the board, like Sigmoid and Color zones.

KEY MAPPING
    Layer A:
      [ Exposure] [ Col. Cal ] [   AgX    ] [ AgX Pre 1 ] [ AgX Preset 1 ] [ AgX Pre Smooth ] [ Primaries  ] [ Color Bal RGB ]
      [ Tone EQ ] [ Color EQ ] [  << Tab  ] [  Tab >>   ] [ Diff Sharpen ] [      Crop      ] [Compres Hist] [  Quick Panel  ]
    Layer B:
      [         ] [          ] [          ] [           ] [              ] [                ] [            ] [               ]
      [         ] [          ] [  << Tab  ] [  Tab >>   ] [              ] [                ] [            ] [               ]

TRIM INPUTS
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
FIRST ROW
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

SECOND ROW
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


INSTALLATION
* In Global Preferences -> Shortcuts, import the file x-touch-mapping.cfg
* Easiest way to enable the script is to:
    * Follow the docs for installation of Lua scripts 
    * Enable tools/script_manager in the luarc file
    * Start the script in the script manager

]]

local dt = require "darktable"
local du = require "lib/dtutils"

du.check_min_api_version("9.2.0", "agx-x-touch-mini")

local gettext = dt.gettext.gettext 

local function _(msgid)
    return gettext(msgid)
end

local script_data = {}

script_data.metadata = {
  name = _("agx-x-touch-mini"),
  purpose = _("Control modules with an x-touch midi device"),
  author = "Sven Wesley based on Diederik ter Rahe's example code",
  help = "https://docs.darktable.org/lua/stable/lua.scripts.manual/scripts/examples/agx-x-touch-mini"   --TODO!!!
}

script_data.destroy = nil -- function to destroy the script
script_data.destroy_method = nil -- set to hide for libs since we can't destroy them commpletely yet
script_data.restart = nil -- how to restart the (lib) script after it's been hidden - i.e. make it visible again
script_data.show = nil -- only required for libs since the destroy_method only hides them


local colorZonesColors = { "red", "orange", "yellow", "green", "aqua", "blue", "purple", "magenta" }
local colorEqualColors = { "red", "orange", "yellow", "green", "cyan", "blue", "lavender", "magenta" }
local sigmoidPrimaries = { "red attenuation", "red rotation", "green attenuation", "green rotation", "blue attenuation", "blue rotation", "recover purity" }
local primaries = { "red hue", "red purity", "green hue", "green purity", "blue hue", "blue purity", "tint hue", "tint purity" }
local exposure = { "exposure", "black level correction", "lightness" }
local diffuseAndSharpenA =  { "iterations",
                              "central radius",
                              "radius span",
                              "1st order speed",
                              "2nd order speed",
                              "3rd order speed",
                              "4th order speed",
                              "nothing" }
local diffuseAndSharpenB =  { "1st order anisotropy",
                              "2nd order anisotropy",
                              "3rd order anisotropy",
                              "4th order anisotropy",
                              "sharpness",
                              "edge sensitivity",
                              "edge threshold",
                              "luminance masking threshold" }
local colorBalanceRgb = { "global vibrance",
                          "contrast",
                          "saturation/shadows",
                          "saturation/mid-tones",
                          "saturation/highlights",
                          "brilliance/shadows",
                          "brilliance/mid-tones",
                          "brilliance/highlights" }
local noActiveModule = { "iop/exposure/exposure",
                         "iop/agx/curve/contrast",
                         "iop/agx/curve/toe power",
                         "iop/agx/curve/shoulder power",
                         "iop/agx/look/saturation",
                         "iop/agx/look/preserve hue",
                         "iop/channelmixerrgb/hue",
                         "iop/channelmixerrgb/chroma" }
local sliderOrderedInput = { "1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th", "11th", "12th", "13th", "14th", "15th", "16th" }

-- set up 8 mimic sliders with the same function
for k = 1,8 do
  dt.gui.mimic("slider", "knob "..k,
    function(action, element, effect, size)

      -- only operate in darkroom; return NAN otherwise
      if dt.gui.current_view() ~= dt.gui.views.darkroom then
        return 0/0
      end

      -- Is anyone still using Color Zones?
      if dt.gui.action("iop/colorzones", "focus") ~= 0 then
        which = "iop/colorzones/graph"
        element = colorZonesColors[k]

      elseif dt.gui.action("iop/exposure", "focus") ~= 0 then
        if k < 4 then
          which = "iop/exposure/"..exposure[k]
        else
          which = "iop/focus/sliders"
          element = "9th" -- blind out sliders with an object that doesn't exist
        end
     
      -- Color EQ
      elseif dt.gui.action("iop/colorequal", "focus") ~= 0 then
        which = "iop/colorequal/graph"
        element = colorEqualColors[k]
                
      -- Sigmoid RGB Primaries in focus 
      elseif dt.gui.action("iop/sigmoid", "focus") ~= 0 and k < 8 then
        which = "iop/sigmoid/primaries/"..sigmoidPrimaries[k]

      -- RGB Primaries
      elseif dt.gui.action("iop/primaries", "focus") ~= 0 and k >=1 then
        which = "iop/primaries/"..primaries[k]
      
      -- Tone Equalizer
      elseif dt.gui.action("iop/toneequal", "focus") ~= 0 then
        which ="iop/toneequal/simple/"..(k-9).." EV"

      -- Color Calibration
      elseif dt.gui.action("iop/channelmixerrgb", "focus") ~= 0 then

        if k < 5 then
          effect = "activate"
        end

        -- 5 selects the active tab; pressing it resets to CAT
        if k == 5 then
          which = "iop/channelmixerrgb/page"
          element = "CAT"
          if effect == "up" then 
            effect = "next"
          elseif effect == "down" then
            effect = "previous"
          else
            effect = "activate"
          end
        else
          -- 6, 7 and 8 are for the three color sliders on each tab
          which = "iop/focus/sliders"
          element = sliderOrderedInput[k - 5]
        end

      -- Color Balance RGB
      elseif dt.gui.action("iop/colorbalancergb", "focus") ~= 0 then
        which = "iop/colorbalancergb/"..colorBalanceRgb[k]

      -- Diffuse and Sharpen
      elseif dt.gui.action("iop/diffuse", "focus") ~= 0 then
        if k < 8 then
          which = "iop/diffuse/"..diffuseAndSharpenA[k]
        end
      
      -- AgX
      elseif dt.gui.action("iop/agx", "focus") ~= 0 then
        which = "iop/focus/sliders"
        element = sliderOrderedInput[k]

      -- If NO SELECTION, setup the default list of adjusters
      else
        which = noActiveModule[k]
      end

      -- pass the element/effect/size to the selected slider
      return dt.gui.action(which, element, effect, size)
    end
  )
end

-- B Layer sliders
for k = 9,16 do
  dt.gui.mimic("slider", "knob "..k,
    function(action, element, effect, size)

      -- only operate in darkroom; return NAN otherwise
      if dt.gui.current_view() ~= dt.gui.views.darkroom then
        return 0/0
      end

      -- AgX
      if dt.gui.action("iop/agx", "focus") ~= 0 then
        which = "iop/focus/sliders"
        element = sliderOrderedInput[k]

      -- Diffuse and Sharpen
      elseif dt.gui.action("iop/diffuse", "focus") ~= 0 then
        which = "iop/diffuse/"..diffuseAndSharpenB[k-8]

      -- Set Tone Equalizer as Layer B when no module is active
      else
        which ="iop/toneequal/simple/"..(k-9-8).." EV"  
      end

      -- pass the element/effect/size to the selected slider
      return dt.gui.action(which, element, effect, size)
    end
  )
end

-- Make it possible to switch tabs in modules with multiple pages
local toggleDict = {
  ["iop/agx"]             = {"iop/agx/page", "primaries"},
  ["iop/toneequal"]       = {"iop/toneequal/page", "simple"},
  ["iop/channelmixerrgb"] = {"iop/channelmixerrgb/page", "CAT"},
  ["iop/colorequal"]      = {"iop/colorequal/page", "hue"},
  ["iop/colorbalancergb"] = {"iop/colorbalancergb/page", "master"}
}

local function togglePane(effect, size)
  if dt.gui.current_view() ~= dt.gui.views.darkroom then
    return 0/0
  end

  for key, val in pairs(toggleDict) do
    if dt.gui.action(key, "focus") ~= 0 then
      return dt.gui.action(val[1], val[2], effect, size)
    end
  end
end

dt.gui.mimic("button", "next", function(action, element, effect, size)
  togglePane("next", size)
end)

dt.gui.mimic("button", "prev", function(action, element, effect, size)
  togglePane("previous", size)
end)

local function destroy()
  -- nothing to destroy
end

script_data.destroy = destroy

return script_data
