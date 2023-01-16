if status --is-interactive
  # direnv -- directory-based environments
  eval (direnv hook fish)

  # ASDF -- language manager
  source (brew --prefix asdf)/libexec/asdf.fish

  # Starship -- pretty prompt
  starship init fish | source

  # Atuin -- universal history
  set -x ATUIN_NOBIND true
  atuin init fish | source
  bind \cr _atuin_search
  bind -M insert \cr _atuin_search
end
