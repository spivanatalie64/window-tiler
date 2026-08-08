# Window Tiler

Custom window decorations + KWin tiling script for KDE Plasma.

## Features

- **Right side buttons**: Close, Minimize, Maximize
- **Left side buttons**: Snap Up, Snap Down, Snap Left, Snap Right
- **Window snapping**: Drag windows to edges/corners to tile (quarter/half)
- **Keyboard shortcuts**: Super + arrows for tiling

## Installation

```
chmod +x install.sh && ./install.sh
```

Then in System Settings → Window Management → Window Decorations → Aurorae, select **WindowTiler**.

Restart KWin: `kwin_x11 --replace &` or log out and back in.
