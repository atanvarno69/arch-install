#!/bin/sh

skel=/etc/skel

for dir in .config .cache .local/bin .local/opt .local/share/applications .local/state; do
    mkdir -p "${skel}/${dir}"
done
