# Window Controller

Move and resize active window programmatically.

Recommended along with corresponding keyboard-shortcuts for dynamic windows-control experience.

Originally written for dynamic control of windows (mainly code viewers and figures) in a large screen (>40inch).

Tested on Ubuntu 16.04 with resolution 3660x2125.

## Input
* $1 - command:

  - FULL MOVE: l = left, r = right, u = up, d = down.
      
      Note: moving the window by full window's width/height, as long as it doesn't get out of the hard-coded screen size.
      
      Recommendation: associate with SHIFT-WINKEY-arrows.

  - SLIGHT MOVE: ls = left, rs = right, us = up, ds = down.
      
      Note: moving the window by hard-coded 10 pixels, as long as it doesn't get out of the screen.
      
      Recommendation: associate with ALT-WINKEY-arrows.

  - RESIZE: bx/sx/by/sy = make bigger/smaller horizontally/vertically.
  
      Note: resizing by hard-coded 50 pixels, as long as it doesn't get bigger than the screen
      or smaller than hard-coded 200x200 pixels.
      
      Note: resizing is from the bottom-right unless reaching end of screen (then expanding to top/left as needed).
  
      Recommendation: associate with CTRL-WINKEY-arrows.
      
      Old commented-out version: bx/sx = *2 horizontally-bigger/smaller, by/sy = *2 vertically-bigger/smaller.

* $2 - set "-v" for verbose.

## Examples
* window_controller.sh l # move left
* window_controller.sh bx -v # enlarge horizontally & be verbose
