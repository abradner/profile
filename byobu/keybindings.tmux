bind-key -n C-t new-window -c "#{pane_current_path}" \; rename-window "-"
bind-key -n C-S-q kill-pane

bind-key -n C-S-Left previous-window
bind-key -n C-S-Right next-window
bind-key -n C-PgUp previous-window
bind-key -n C-PgDn next-window

set -g prefix F12
unbind-key -n C-a
unbind-key -n C-q
