#!/bin/bash

# Groups
pacman -Qqe > pacall.pkbk
pacman -Qqg | cut -f1 -d' ' |sort -u > pacGroups.pkbk
pacman -Qqm > pacLocal.pkbk
pacman -Qqe | grep -v "$(pacman -Qqg | cut -f2 -d' ')" > pacpac.pkbk

echo "$(wc -l pacpac.pkbk) non group packages"
echo "$(wc -l pacLocal.pkbk) local/aur packages"
echo "$(wc -l pacGroups.pkbk) groups"
echo "$(pacman -Qqg | wc -l) group packages"
echo "$(wc -l pacall.pkbk) explicit packages"
