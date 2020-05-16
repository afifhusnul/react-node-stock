#!/bin/bash

# -d says not to attach to the session yet. top runs in the first
# window
tmux new-session -d /home/$USER/www/stock/scripts/start-nodestock.sh
# In the most recently created session, split the (only) window
# and run htop in the new pane
tmux split-window -v /home/$USER/www/stock/scripts/start-reactstock.sh
# Split the new pane and run perl
tmux split-pane -v
# Make all three panes the same size (currently, the first pane
# is 50% of the window, and the two new panes are 25% each).
tmux select-layout even-vertical
# Now attach to the window
tmux attach-session

