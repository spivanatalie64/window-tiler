#!/bin/bash
# Window Tiler - Set KWin button layout
# Left: Up, Down, Left, Right (directional snaps)
# Right: Close, Minimize, Maximize

# Check if kwriteconfig6 is available
if command -v kwriteconfig6 &>/dev/null; then
    KWC="kwriteconfig6"
elif command -v kwriteconfig5 &>/dev/null; then
    KWC="kwriteconfig5"
else
    echo "Error: kwriteconfig not found. Install kconfig-tools."
    exit 1
fi

# Set the button layout
# Left side (directional tiling buttons):
# We use Custom buttons via the KWin script, but for standard buttons:
# Order for left: [Spacer] to push buttons
# Actually, we'll set this up via the KWin script directly
# The standard layout config only supports standard button types
# Our custom KWin script will add the direction buttons

# Configure KWin to use our custom Aurorae theme
$KWC --file kwinrc --group "org.kde.kdecoration2" --key "library" "org.kde.kwin.aurorae"
$KWC --file kwinrc --group "org.kde.kdecoration2" --key "theme" "WindowTiler"

# Set button order (these go to the right by default)
# Left buttons: M=Menu, S=Spacer
# Right buttons: C=Close, I=Minimize, X=Maximize
$KWC --file kwinrc --group "org.kde.kdecoration2" --key "ButtonsOnLeft" "S"
$KWC --file kwinrc --group "org.kde.kdecoration2" --key "ButtonsOnRight" "XIC"

# The directional tiling buttons (Up/Down/Left/Right) 
# will be provided by our KWin script as keyboard shortcuts
# and as clickable buttons in the decoration via the Aurorae theme

echo "Button layout configured."
echo "Restart KWin: kwin_x11 --replace &"
echo "Or log out and back in."
