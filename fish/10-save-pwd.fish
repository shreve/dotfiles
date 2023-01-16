function save-path --on-event fish_prompt
    if ! test $fish_private_mode
        pwd > ~/.cache/pwd
    end
end

if status --is-interactive
    cd (cat ~/.cache/pwd)
end
