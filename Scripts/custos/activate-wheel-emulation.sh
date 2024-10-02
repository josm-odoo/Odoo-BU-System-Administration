#!/bin/bash

# Script to allow middle mouse scrolling similar to windows.

xinput --set-prop 'Name of Mouse here' 'libinput Scroll Method Enabled' 0, 0, 1
xinput --set-prop 'Name of Mouse here' 'libinput Button Scrolling Button' 2

