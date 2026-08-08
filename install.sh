#!/bin/bash
set -e

echo "=== Window Tiler Installer ==="

# --- Install KWin Script ---
echo "[1/3] Installing KWin Script..."
KSCRIPT_DIR="$HOME/.local/share/kwin/scripts/windowtiler"
mkdir -p "$KSCRIPT_DIR"
cp -r kwin-script/* "$KSCRIPT_DIR/"
kpackagetool6 --install --type KWin/Script "$KSCRIPT_DIR/metadata.json" 2>/dev/null || \
    kpackagetool6 --upgrade --type KWin/Script "$KSCRIPT_DIR/metadata.json" 2>/dev/null || true
echo "  KWin script installed to $KSCRIPT_DIR"

# --- Install Aurorae Theme ---
echo "[2/3] Installing Aurorae Decoration Theme..."
THEME_DIR="$HOME/.local/share/aurorae/themes/WindowTiler"
mkdir -p "$THEME_DIR"
cp -r aurorae-theme/WindowTiler/* "$THEME_DIR/"
echo "  Theme installed to $THEME_DIR"

# --- Configure KWin ---
echo "[3/3] Configuring KWin..."
if command -v kwriteconfig6 &>/dev/null; then
    KWC="kwriteconfig6"
elif command -v kwriteconfig5 &>/dev/null; then
    KWC="kwriteconfig5"
else
    echo "  WARNING: kwriteconfig not found. Install kconfig-tools and configure manually."
    echo "  Run: kwin_x11 --replace &"
    exit 0
fi

$KWC --file kwinrc --group "org.kde.kdecoration2" --key "library" "org.kde.kwin.aurorae"
$KWC --file kwinrc --group "org.kde.kdecoration2" --key "theme" "WindowTiler"
$KWC --file kwinrc --group "org.kde.kdecoration2" --key "ButtonsOnLeft" ""
$KWC --file kwinrc --group "org.kde.kdecoration2" --key "ButtonsOnRight" ""

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Now you need to:"
echo "  1. Enable the KWin script:"
echo "     System Settings > Window Management > KWin Scripts > check 'Window Tiler'"
echo "  2. Select the decoration theme:"
echo "     System Settings > Window Management > Window Decorations > Aurorae > WindowTiler"
echo "  3. Restart KWin:"
echo "     kwin_x11 --replace &"
echo ""
echo "Or just run: ./apply.sh"
