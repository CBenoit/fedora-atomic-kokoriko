#!/usr/bin/bash
set -euo pipefail

TARGET=61184 # As defined in sysusers.d/00-wireshark.conf.

current_group="$(getent group wireshark | cut -d: -f3 || true)"

[ -z "$current_group" ] && exec groupadd -r -g "$TARGET" wireshark

if [ "$current_group" != "$TARGET" ] && ! getent group "$TARGET" >/dev/null; then
  groupmod -g "$TARGET" wireshark
fi

# Sentinel ensuring the systemd service does not run again.
touch /etc/.wireshark-gid-reconciled-$TARGET

