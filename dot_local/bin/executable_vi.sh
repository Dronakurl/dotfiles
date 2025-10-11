#!/bin/sh
# Wrapper script for nvim with automatic updates via bob

_vi_should_skip_bob() {
    # Returns 0 (success) if bob should be skipped
    if ! command -v cargo >/dev/null 2>&1; then
        return 0
    fi
    if command -v nvim 2>/dev/null | grep -q "brew"; then
        return 0
    fi
    return 1
}

_vi_needs_update() {
    timestamp_file=~/.local/state/lastnvimupdate

    if [ ! -f "$timestamp_file" ]; then
        echo "Timestamp file not found, creating one with a date long ago..."
        mkdir -p ~/.local/state
        date -d "3 weeks ago" +%s >"$timestamp_file"
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

_vi_ensure_bob() {
    if ! command -v bob >/dev/null 2>&1; then
        echo "bob could not be found, installing..."
        cargo install bob-nvim
    else
        echo "bob is already installed."
    fi
}

_vi_update_bob() {
    if ! cargo install bob-nvim; then
        echo "Failed to install bob-nvim"
        return 1
    fi
    if ! echo "y" | bob use nightly; then
        echo "cannot update nvim with bob"
        return 1
    fi
    return 0
}

_vi_update_plugins() {
    nvim_path="$1"
    if ! "$nvim_path" --headless "+Lazy! sync" +qa; then
        echo "cannot update plugins with nvim"
        return 1
    fi
    return 0
}

_vi_update_timestamp() {
    timestamp_file=~/.local/state/lastnvimupdate
    date +%s >"$timestamp_file"
}

# Main logic
use_bob=true
nvim_path="$HOME/.local/share/bob/nvim-bin/nvim"

# Determine which nvim to use
if _vi_should_skip_bob; then
    use_bob=false
    nvim_path="nvim"
    echo "Using system nvim: $(command -v nvim)"
else
    echo "Using bob's nvim: $nvim_path"
fi

# Ensure bob is installed if we're using it
if [ "$use_bob" = "true" ]; then
    _vi_ensure_bob
fi

# Check if update is needed
if _vi_needs_update; then
    # Update bob if we're using it
    if [ "$use_bob" = "true" ]; then
        _vi_update_bob || exit 1
    fi

    # Update plugins
    _vi_update_plugins "$nvim_path" || exit 1

    # Update timestamp
    _vi_update_timestamp
fi

# Run nvim
exec "$nvim_path" "$@"
