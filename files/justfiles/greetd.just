# Auto-login the current user (or a provided username) into niri.
greetd-autologin-on user='':
    #!/usr/bin/env bash
    set -euo pipefail

    CFG=/etc/greetd/config.toml
    [[ -f "$CFG" ]] || { echo "ERROR: $CFG is missing."; exit 1; }

    USERNAME="{{user}}"
    [[ -n "$USERNAME" ]] || USERNAME="${SUDO_USER:-$USER}"

    # Remove our previous block if present, then append a fresh one.
    sudo sed -i '/# UJUST BEGIN AUTOLOGIN/,/# UJUST END AUTOLOGIN/d' "$CFG"

    # Build the autologin block
    {
        echo '# UJUST BEGIN AUTOLOGIN'
        echo "[initial_session]"
        echo 'command = "niri-session"'
        echo "user = \"${USERNAME}\""
        echo '# UJUST END AUTOLOGIN'
    } | sudo tee -a "$CFG" >/dev/null

    echo "Autologin configured for ${USERNAME}."
    echo "It will apply on next start."

# Remove only the block we added.
greetd-autologin-off:
    #!/usr/bin/env bash
    set -euo pipefail

    CFG=/etc/greetd/config.toml
    [[ -f "$CFG" ]] || { echo "No $CFG; nothing to do."; exit 0; }

    sudo sed -i '/# UJUST BEGIN AUTOLOGIN/,/# UJUST END AUTOLOGIN/d' "$CFG"

    echo "Autologin disabled. Takes effect next start."
