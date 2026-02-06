#!/bin/bash

SESSION="nvim_Config"

tmux kill-session -t $SESSION 2>/dev/null

# [Editor] window (shell first, then start nvim)
tmux new-session -d -s $SESSION -n "[Editor]" -c "$(pwd)"
tmux send-keys -t $SESSION:[Editor] "nvim" C-m

# shell window
# tmux new-window -t $SESSION -n "shell" -c "$(pwd)/src"

# optional windows
tmux new-window -t $SESSION -n "[Test]" -c "$(pwd)"

tmux select-window -t $SESSION:[Editor]
tmux attach-session -t $SESSION






