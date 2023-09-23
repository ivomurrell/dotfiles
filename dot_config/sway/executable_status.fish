#!/bin/env fish

set battery_cap (cat /sys/class/power_supply/macsmc-battery/capacity)
set date (date +'%a %d %T')

echo "$battery_cap% / $date"
