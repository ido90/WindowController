#!/bin/bash

# Move/resize active window.
# Recommended along with corresponding keyboard-shortcuts for dynamic windows-control experience!
# Originally written for dynamic control of windows (mainly code viewers and figures) in a large screen (>40inch).

# Tested on Ubuntu 16.04 with resolution 3660x2125.

# Input:
# 
#   $1 = command:
# 
#     FULL MOVE: l = left, r = right, u = up, d = down
#       Note: moving the window by full window's width/height, as long as it doesn't get out of the screen
#       (screen size is hard-coded below).
#       Recommendation: associate with SHIFT-WINKEY-arrows.
# 
#     SLIGHT MOVE: ls = left, rs = right, us = up, ds = down
#       Note: moving the window by hard-coded 10 pixels, as long as it doesn't get out of the screen.
#       Recommendation: associate with ALT-WINKEY-arrows.
# 
#     RESIZE: bx/sx/by/sy = hard-coded 50 pixels bigger/smaller horizontally/vertically
#       Recommendation: associate with CTRL-WINKEY-arrows.
#       Old commented-out version: bx/sx = *2 horizontally-bigger/smaller, by/sy = *2 vertically-bigger/smaller
# 
#   $2 = set "-v" for verbose

# Examples:
# window_controller.sh l # move left
# window_controller.sh bx -v # enlarge horizontally & be verbose

# configuration
WIDTH=3660
HEIGHT=2125
WMIN=200
HMIN=200

# input validation
if [ -z ${1+x} ]; then
    echo "Input missing."
    exit 1
elif [ $1 != "o" ] && [ $1 != "l" ] && [ $1 != "r" ] && [ $1 != "u" ] && [ $1 != "d" ] && \
         [ $1 != "ls" ] && [ $1 != "rs" ] && [ $1 != "us" ] && [ $1 != "ds" ] && \
         [ $1 != "bx" ] && [ $1 != "by" ] && [ $1 != "sx" ] && [ $1 != "sy" ]; then
    echo "Bad input."
    exit 2
fi

# check verbose
if [ -z ${2+x} ] || [ $2 != "-v" ]; then
    verbose=0
else
    verbose=1
fi

# get current window's data
curr_win_data=$(wmctrl -lGp | grep $(xprop -root | grep _NET_ACTIVE_WINDOW | head -1 | awk '{print $5}' | sed 's/,//' | sed 's/^0x/0x0/'))
if [ $verbose == 1 ]; then
    echo $curr_win_data
fi
dd=($curr_win_data)

name=${dd[-1]}
n=${dd[0]}
x=${dd[3]}
y=${dd[4]}
W=${dd[5]}
H=${dd[6]}

# certain applications require specific correction, apparently due to window header size
if [ $name == "Chrome" ]; then
    x=$x
    y=$y
else
    x=$((x-6))
    y=$((y-58))
fi

if [ $verbose == 1 ]; then
    echo name=$name, x=$x, y=$y, W=$W, H=$H
fi

# Set window to current location and size - used to measure the required correction
if [ $1 == "o" ]; then
    wmctrl -r :ACTIVE: -e 0,$x,$y,$W,$H
    
# MOVE
elif [ $1 == "l" ]; then
    if (( $(echo "$((x-W)) >= 0" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,$((x-W)),-1,-1,-1
    else
        wmctrl -r :ACTIVE: -e 0,0,-1,-1,-1
    fi
elif [ $1 == "r" ]; then
    if (( $(echo "$((x+W+W)) <= $WIDTH" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,$((x+W)),-1,-1,-1
    else
        wmctrl -r :ACTIVE: -e 0,$((WIDTH-W)),-1,-1,-1
    fi
elif [ $1 == "u" ]; then
    if (( $(echo "$((y-H)) >= 0" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,-1,$((y-H)),-1,-1
    else
        wmctrl -r :ACTIVE: -e 0,-1,0,-1,-1
    fi
elif [ $1 == "d" ]; then
    if (( $(echo "$((y+H+H)) <= $HEIGHT" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,-1,$((y+H)),-1,-1
    else
        wmctrl -r :ACTIVE: -e 0,-1,$((HEIGHT-H)),-1,-1
    fi
    
# MOVE SLIGHTLY
elif [ $1 == "ls" ]; then
    if (( $(echo "$((x-10)) >= 0" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,$((x-10)),-1,-1,-1
    fi
elif [ $1 == "rs" ]; then
    if (( $(echo "$((x+W+10)) <= $WIDTH" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,$((x+10)),-1,-1,-1
    fi
elif [ $1 == "us" ]; then
    if (( $(echo "$((y-10)) >= 0" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,-1,$((y-10)),-1,-1
    fi
elif [ $1 == "ds" ]; then
    if (( $(echo "$((y+H+10)) <= $HEIGHT" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,-1,$((y+10)),-1,-1
    fi
    
# RESIZE
elif [ $1 == "by" ]; then
    if (( $(echo "$((H+50)) <= $HEIGHT" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,-1,-1,-1,$((H+50))
        #        wmctrl -r :ACTIVE: -e 0,-1,$y,-1,$((H*2))
        #        wmctrl -r :ACTIVE: -e 0,-1,$((y-H)),-1,$((H*2))
        #
        #        wmctrl -r :ACTIVE: -e 0,-1,$((y-H)),-1,-1
        #        wmctrl -r :ACTIVE: -e 0,-1,-1,-1,$((H*2))
    else
        wmctrl -r :ACTIVE: -e 0,-1,-1,-1,$HEIGHT
    fi
elif [ $1 == "bx" ]; then
    if (( $(echo "$((W+50)) <= $WIDTH" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,-1,-1,$((W+50)),-1
    else
        wmctrl -r :ACTIVE: -e 0,-1,-1,$WIDTH,-1
    fi
elif [ $1 == "sy" ]; then
    if (( $(echo "$((H-50)) >= $HMIN" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,-1,-1,-1,$((H-50))
        #        wmctrl -r :ACTIVE: -e 0,-1,$((y+H/2)),-1,$((H/2))
        #        
        #        wmctrl -r :ACTIVE: -e 0,-1,$((y+H/2)),-1,-1
        #        wmctrl -r :ACTIVE: -e 0,-1,-1,-1,$((H/2))
    else
        wmctrl -r :ACTIVE: -e 0,-1,-1,-1,$HMIN
    fi
elif [ $1 == "sx" ]; then
    if (( $(echo "$((W-50)) >= $WMIN" | bc -l) )); then
        wmctrl -r :ACTIVE: -e 0,-1,-1,$((W-50)),-1
    else
        wmctrl -r :ACTIVE: -e 0,-1,-1,$WMIN,-1
    fi
fi
