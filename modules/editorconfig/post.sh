tee /etc/skel/.editorconfig >/dev/null <<'EOF'
root = true

[*]
charset                  = utf-8
end_of_line              = lf
indent_size              = 4
indent_style             = space
insert_final_newline     = true
trim_trailing_whitespace = true

[Makefile]
indent_style = tab
EOF
