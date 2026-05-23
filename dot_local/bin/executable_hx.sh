#!/bin/sh
# Wrapper script for helix with automatic updates from source

_hx_needs_update() {
    timestamp_file=~/.local/state/lasthxupdate

    if [ ! -f "$timestamp_file" ]; then
        echo "Timestamp file not found, creating one with a date long ago..."
        mkdir -p ~/.local/state
        date -d "1 week ago" +%s >"$timestamp_file"
        return 0
    fi

    last_update=$(cat "$timestamp_file")
    one_week_ago=$(date -d "1 week ago" +%s)

    if [ "$last_update" -gt "$one_week_ago" ]; then
        echo "Last update was less than 1 week ago, skipping..."
        return 1
    fi
    return 0
}

_hx_update() {
    hx_dir="$HOME/gallery/helix"

    # Check if the directory exists
    if [ ! -d "$hx_dir" ]; then
        echo "Helix source directory not found at $hx_dir"
        return 1
    fi

    # Save current directory
    current_dir=$(pwd)

    # Change to helix directory and pull
    cd "$hx_dir" || return 1
    echo "Pulling latest changes from helix repository..."
    if ! git pull; then
        echo "Failed to git pull in helix directory"
        cd "$current_dir" || exit 1
        return 1
    fi

    # Rebuild helix with optimized settings
    echo "Rebuilding helix..."
    if ! cargo install \
         --profile opt \
         --config 'build.rustflags="-C target-cpu=native"' \
         --path helix-term \
         --locked; then
        echo "Failed to rebuild helix"
        cd "$current_dir" || exit 1
        return 1
    fi

    # Return to original directory
    cd "$current_dir" || exit 1
    return 0
}

_hx_update_timestamp() {
    timestamp_file=~/.local/state/lasthxupdate
    date +%s >"$timestamp_file"
}

# Main logic

# Check if update is needed
if _hx_needs_update; then
    _hx_update || exit 1
    _hx_update_timestamp
fi

# Run helix
exec hx "$@"
