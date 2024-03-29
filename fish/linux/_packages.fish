#!/usr/bin/env fish

function update
    yay -Syy
    upgradable-count-save
    upgradable-report
    yay -Qu
end

function upgrade
    yay -Syyu --noconfirm --removemake --nodiffmenu --nocleanmenu
    upgradable-count-save
    yay -Scc --noconfirm
end

function cleanse
    yay -Qddt | nth 1 | xargs yay -R --noconfirm
end

function upgradable-report
    set -l count (echo -n 0 && cat ~/.cache/upgradable-packages)
    if test "$count" -gt 0
        echo -es "\n" (set_color yellow) $count " packages upgradable" (set_color normal)
    else
        echo -es "\n" (set_color green) "All packages up to date" (set_color normal)
    end
end

function upgradable-count-save
    yay -Pn > ~/.cache/upgradable-packages
end

function pickapack
    yay -Q | sort -R | head -1 | nth 1 | xargs yay -Qi
end

function big-boys
    pacman -Qi | egrep '^(Name|Installed)' | cut -f2 -d':' | awk '{ if (NR%2==1) { name=$0 } else { print $1$2 "\t" name } }' | sort -rh
end
