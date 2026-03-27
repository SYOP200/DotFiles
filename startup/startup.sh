#!/bin/bash
# SYOP200 startup script for fish shell
set -e
# run cmatrix for 2 seconds, then terminate it and continue
cmatrix &
PID=$!
sleep 1
if kill -0 "$PID" 2>/dev/null; then
	kill "$PID" 2>/dev/null || true
fi
wait "$PID" 2>/dev/null || true
ansi --cyan "  ________  ________  ________  ________  ________ "
ansi --cyan " /        \/    /   \/        \/        \/        \ "
ansi --cyan "/        _/         /        _/         /         / "
ansi --cyan "/-        /\__      /-        /         /       __/ "
ansi --cyan "\_______//   \_____/\________/\________/\______/    " 

stat -l | ansi --yellow