#!/bin/sh
# Helix editor wrapper that activates Python virtual environment if present

if [ -z "$VIRTUAL_ENV" ]; then
    if [ -d ".venv" ]; then
        # Activate the virtual environment
        . .venv/bin/activate
    else
        echo "No virtual environment found."
    fi
else
    echo "Already in a virtual environment."
fi

exec hx "$@"
