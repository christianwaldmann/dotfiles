#!/bin/env bash

SESSION="work"
APP_DIR="~/repos"
DB_DIR="~/tmp"

tmux has-session -t $SESSION 2> /dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s $SESSION -n app

    # 1. window
    tmux split-window -h -t $SESSION:1

    tmux select-pane -t $SESSION:1.0
    tmux split-window -v -t $SESSION:1.0
    tmux split-window -v -t $SESSION:1.0
    tmux split-window -v -t $SESSION:1.0
    tmux split-window -v -t $SESSION:1.0
    tmux split-window -v -t $SESSION:1.0

    tmux select-layout -t $SESSION_NAME:1 main-vertical

    tmux send-keys -t $SESSION:1.0 "cd $APP_DIR && clear && echo 1" C-m
    tmux send-keys -t $SESSION:1.1 "cd $APP_DIR && clear && echo 2" C-m
    tmux send-keys -t $SESSION:1.2 "cd $APP_DIR && clear && echo 3" C-m
    tmux send-keys -t $SESSION:1.3 "cd $APP_DIR && clear && echo 4" C-m
    tmux send-keys -t $SESSION:1.4 "cd $APP_DIR && clear && echo 5" C-m
    tmux send-keys -t $SESSION:1.5 "cd $APP_DIR && clear && echo 6" C-m

    tmux select-pane -t $SESSION:1.0

    # 2. window
    tmux new-window -t $SESSION:2 -n db
    tmux send-keys -t $SESSION:2 "cd $DB_DIR && clear && echo docker run ..." C-m

    # 3. window
    tmux new-window -t $SESSION:3 -n psql
    tmux send-keys -t $SESSION:3 "cd $DB_DIR && clear && echo psql ..." C-m

    # Focus first window
    tmux select-window -t $SESSION:1
fi

tmux attach -t $SESSION

