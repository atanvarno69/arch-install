#!/bin/sh

mkdir /etc/skel/.config/starship

tee -a /etc/skel/.config/zsh/prompt >/dev/null <<'EOF'
eval "$(starship init zsh)"
EOF

tee -a /etc/skel/.config/zsh/zshenv >/dev/null <<'EOF'
[ -z "${STARSHIP_CONFIG}" ] && export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/starship.toml"
EOF

tee -a /etc/skel/.config/starship >/dev/null <<'EOF'
palette = "catppuccin"
add_newline = false
format = "$directory$git_branch$character"
right_format = "$git_metrics$git_status$git_commit$status"
continuation_prompt = " […](blue)[](text) "

[directory]
truncation_length = 10
truncate_to_repo = true
format = "[$read_only]($read_only_style)[ $path ]($style)"
style = "text"
read_only = " "
read_only_style = "red"
home_symbol = "~"
truncation_symbol = ""
before_repo_root_style = ""
repo_root_style = "blue"
repo_root_format = "[$read_only]($read_only_style)[$before_root_path]($before_repo_root_style)[  $repo_root]($repo_root_style)[$path ]($style)"

[git_branch]
format = "[$symbol $branch ]($style)"
always_show_remote = true
symbol = ""
style = "green"

[character]
success_symbol = '[\$](green bold)'
error_symbol = '[\$](red bold)'
vimcmd_symbol = "[](green)"

[git_metrics]
disabled = false
added_style = "green"
deleted_style = "red"
only_nonzero_diffs = true
format = "([ $added ]($added_style))([ $deleted ]($deleted_style))"

[git_status]
format = "([$conflicted](red))([$stashed](purple))([$deleted](red))([$renamed](blue))([$modified](yellow))([$staged](blue))([$untracked](purple))([$diverged](red))([$ahead](blue))([$behind](yellow))([$up_to_date](green))"
conflicted = " $count "
stashed = " $count "
deleted = " $count "
renamed = " $count "
modified = " $count "
staged = " $count "
untracked = " $count "
diverged = " $ahead_count  $behind_count "
ahead = " $count "
behind = " $count "
up_to_date = "  "

[git_commit]
only_detached = false
tag_disabled = false
format = "([$tag ]($style))[ $hash ]($style)"
style = "yellow"
tag_symbol = "󰓼 "
tag_max_candidates = 20

[status]
disabled = false
format = "[ $status ]($style) "
style = "bold fg:base bg:red"

# palette tables should be last in the config
[palettes.catppuccin]
rosewater = "#f5e0dc"
flamingo = "#f2cdcd"
pink = "#f5c2e7"
mauve = "#cba6f7"
red = "#f38ba8"
maroon = "#eba0ac"
peach = "#fab387"
yellow = "#f9e2af"
green = "#a6e3a1"
teal = "#94e2d5"
sky = "#89dceb"
sapphire = "#74c7ec"
blue = "#89b4fa"
lavender = "#b4befe"
text = "#cdd6f4"
subtext1 = "#bac2de"
subtext0 = "#a6adc8"
overlay2 = "#9399b2"
overlay1 = "#7f849c"
overlay0 = "#6c7086"
surface2 = "#585b70"
surface1 = "#45475a"
surface0 = "#313244"
base = "#1e1e2e"
mantle = "#181825"
crust = "#11111b"
EOF

