#!/bin/bash
set -e

echo "=== Applying Window Tiler ==="

# Enable the KWin script
kpackagetool6 --install --type KWin/Script "$HOME/.local/share/kwin/scripts/windowtiler/metadata.json" 2>/dev/null || \
    kpackagetool6 --upgrade --type KWin/Script "$HOME/.local/share/kwin/scripts/windowtiler/metadata.json" 2>/dev/null || true

# Enable via config
mkdir -p "$HOME/.config"
CONFIG_FILE="$HOME/.config/kwinrc"

# Enable the script in KWin scripts config
SCRIPTS_FILE="$HOME/.config/kwinscriptsrc"
if [ ! -f "$SCRIPTS_FILE" ]; then
    echo "[Plugins]" > "$SCRIPTS_FILE"
fi
# Use kwriteconfig to enable
if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file kwinscriptsrc --group "Plugins" --key "windowtiler" "true"
elif command -v kwriteconfig5 &>/dev/null; then
    kwriteconfig5 --file kwinscriptsrc --group "Plugins" --key "windowtiler" "true"
fi

# Set decoration theme
if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file kwinrc --group "org.kde.kdecoration2" --key "library" "org.kde.kwin.aurorae"
    kwriteconfig6 --file kwinrc --group "org.kde.kdecoration2" --key "theme" "WindowTiler"
elif command -v kwriteconfig5 &>/dev/null; then
    kwriteconfig5 --file kwinrc --group "org.kde.kdecoration2" --key "library" "org.kde.kwin.aurorae"
    kwriteconfig5 --file kwinrc --group "org.kde.kdecoration2" --key "theme" "WindowTiler"
fi

# Restart KWin to apply (safe -- replaces without killing session)
echo "Restarting KWin..."
kwin_x11 --replace &
sleep 2
echo "Done! Window Tiler is now active."
echo ""
echo "Keyboard shortcuts:"
echo "  Super + Arrow Keys  -> Tile to half-screen"
echo "  Super + Ctrl + Arrow -> Tile to quadrant"
echo "  Super + C           -> Center window"
echo ""
echo "Mouse snapping: drag a window to any screen edge to snap."
