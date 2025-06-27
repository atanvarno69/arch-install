#!/usr/bin/env sh

mkdir -p /etc/skel/.config/kitty

tee /etc/skel/.config/kitty/current-theme.conf >/dev/null <<'EOF'
# vim:ft=kitty

## name:     Catppuccin-Mocha
## author:   Pocco81 (https://github.com/Pocco81)
## license:  MIT
## upstream: https://github.com/catppuccin/kitty/blob/main/mocha.conf
## blurb:    Soothing pastel theme for the high-spirited!

# The basic colors
foreground              #CDD6F4
background              #1E1E2E
selection_foreground    #1E1E2E
selection_background    #F5E0DC

# Cursor colors
cursor                  #F5E0DC
cursor_text_color       #1E1E2E

# URL underline color when hovering with mouse
url_color               #F5E0DC

# Kitty window border colors
active_border_color     #B4BEFE
inactive_border_color   #6C7086
bell_border_color       #F9E2AF

# OS Window titlebar colors
wayland_titlebar_color system
macos_titlebar_color system

# Tab bar colors
active_tab_foreground   #11111B
active_tab_background   #CBA6F7
inactive_tab_foreground #CDD6F4
inactive_tab_background #181825
tab_bar_background      #11111B

# Colors for marks (marked text in the terminal)
mark1_foreground #1E1E2E
mark1_background #B4BEFE
mark2_foreground #1E1E2E
mark2_background #CBA6F7
mark3_foreground #1E1E2E
mark3_background #74C7EC

# The 16 terminal colors

# black
color0 #45475A
color8 #585B70

# red
color1 #F38BA8
color9 #F38BA8

# green
color2  #A6E3A1
color10 #A6E3A1

# yellow
color3  #F9E2AF
color11 #F9E2AF

# blue
color4  #89B4FA
color12 #89B4FA

# magenta
color5  #F5C2E7
color13 #F5C2E7

# cyan
color6  #94E2D5
color14 #94E2D5

# white
color7  #BAC2DE
color15 #A6ADC8
EOF

tee /etc/skel/.config/kitty/kitty.conf >/dev/null <<'EOF'
# Theme
include current-theme.conf

# Font
font_size         12.0
font_family       family='RobotoMono Nerd Font' postscript_name=RobotoMonoNF-Rg
bold_font         family='RobotoMono Nerd Font' style=Bold
italic_font       auto
bold_italic_font  family='RobotoMono Nerd Font' style='Bold Italic'

# Window
enabled_layouts  tall

# Tab bar
tab_bar_edge           top
tab_bar_margin_height  0.0 0.0
tab_bar_style          separator
tab_bar_align          left
tab_bar_min_tabs       1
tab_separator          " │ "

# Shell integration
shell              .
editor             .
shell_integration  no-cursor

# Cursor
cursor_shape            block
cursor_shape_unfocused  hollow
cursor_blink_interval   0

# Bell
enable_audio_bell  no

# Keymaps
clear_all_shortcuts  yes
kitty_mod            ctrl+shift

map  kitty_mod+c           copy_to_clipboard
map  kitty_mod+v           paste_from_clipboard
map  kitty_mod+b           paste_from_selection
map  kitty_mod+p           show_scrollback
map  kitty_mod+enter       new_window_with_cwd
map  kitty_mod+w           close_window
map  kitty_mod+j           next_window
map  kitty_mod+down        next_window
map  kitty_mod+k           previous_window
map  kitty_mod+up          previous_window
map  kitty_mod+#           move_window_to_top
map  kitty_mod+t           new_tab
map  kitty_mod+q           close_tab
map  kitty_mod+l           next_tab
map  kitty_mod+right       next_tab
map  kitty_mod+h           previous_tab
map  kitty_mod+left        previous_tab
map  kitty_mod+1           goto_tab 1
map  kitty_mod+2           goto_tab 2
map  kitty_mod+3           goto_tab 3
map  kitty_mod+4           goto_tab 4
map  kitty_mod+5           goto_tab 5
map  kitty_mod+6           goto_tab 6
map  kitty_mod+7           goto_tab 7
map  kitty_mod+8           goto_tab 8
map  kitty_mod+9           goto_tab 9
map  kitty_mod+0           goto_tab 10
map  kitty_mod+equal       change_font_size all +1.0
map  kitty_mod+kp_add      change_font_size all +1.0
map  kitty_mod+minus       change_font_size all -1.0
map  kitty_mod+kp_subtract change_font_size all -1.0
map  kitty_mod+space       toggle_fullscreen
map  kitty_mod+u           kitten unicode_input
map  kitty_mod+escape      kitty_shell tab
map  kitty_mod+f5          load_config_file
map  kitty_mod+f6          debug_config
EOF
tee -a /etc/skel/.config/zsh/aliases >/dev/null <<'EOF'
[ "${TERM}" = "xterm-kitty" ] && alias icat='kitty +kitten icat'
[ "${TERM}" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
EOF
