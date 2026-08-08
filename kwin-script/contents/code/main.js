// Window Tiler KWin Script
// Adds directional tile + snap functionality to KWin

var snapMargin = 4; // pixels gap between tiled windows

function getScreen(client) {
    var screens = workspace.screens;
    var screenId = client.screen || 0;
    return {
        width: screens[screenId].width,
        height: screens[screenId].height,
        x: screens[screenId].x,
        y: screens[screenId].y
    };
}

function tileWindow(client, direction) {
    if (!client || !client.resizeable || client.fullScreen) return;

    var screen = getScreen(client);
    var geo = client.geometry;
    var halfW = Math.floor(screen.width / 2) - snapMargin;
    var halfH = Math.floor(screen.height / 2) - snapMargin;
    var fullW = screen.width - snapMargin * 2;
    var fullH = screen.height - snapMargin * 2;

    switch (direction) {
        case "left":
            client.geometry = {
                x: screen.x + snapMargin,
                y: screen.y + snapMargin,
                width: halfW,
                height: fullH
            };
            break;
        case "right":
            client.geometry = {
                x: screen.x + screen.width - halfW - snapMargin,
                y: screen.y + snapMargin,
                width: halfW,
                height: fullH
            };
            break;
        case "up":
            client.geometry = {
                x: screen.x + snapMargin,
                y: screen.y + snapMargin,
                width: fullW,
                height: halfH
            };
            break;
        case "down":
            client.geometry = {
                x: screen.x + snapMargin,
                y: screen.y + screen.height - halfH - snapMargin,
                width: fullW,
                height: halfH
            };
            break;
        case "top-left":
            client.geometry = {
                x: screen.x + snapMargin,
                y: screen.y + snapMargin,
                width: halfW,
                height: halfH
            };
            break;
        case "top-right":
            client.geometry = {
                x: screen.x + screen.width - halfW - snapMargin,
                y: screen.y + snapMargin,
                width: halfW,
                height: halfH
            };
            break;
        case "bottom-left":
            client.geometry = {
                x: screen.x + snapMargin,
                y: screen.y + screen.height - halfH - snapMargin,
                width: halfW,
                height: halfH
            };
            break;
        case "bottom-right":
            client.geometry = {
                x: screen.x + screen.width - halfW - snapMargin,
                y: screen.y + screen.height - halfH - snapMargin,
                width: halfW,
                height: halfH
            };
            break;
        case "maximize":
            client.geometry = {
                x: screen.x + snapMargin,
                y: screen.y + snapMargin,
                width: fullW,
                height: fullH
            };
            break;
        case "center":
            var cw = Math.floor(screen.width * 0.6);
            var ch = Math.floor(screen.height * 0.6);
            client.geometry = {
                x: screen.x + Math.floor((screen.width - cw) / 2),
                y: screen.y + Math.floor((screen.height - ch) / 2),
                width: cw,
                height: ch
            };
            break;
    }
}

function snapWindow(client, edge, cursorPos) {
    if (!client || !client.resizeable || client.fullScreen) return;

    var screen = getScreen(client);
    var halfW = Math.floor(screen.width / 2) - snapMargin;
    var halfH = Math.floor(screen.height / 2) - snapMargin;
    var fullW = screen.width - snapMargin * 2;
    var fullH = screen.height - snapMargin * 2;

    var threshold = 30;

    // Determine quadrant based on cursor position
    var centerX = screen.x + screen.width / 2;
    var centerY = screen.y + screen.height / 2;

    var onLeft = cursorPos.x <= screen.x + threshold;
    var onRight = cursorPos.x >= screen.x + screen.width - threshold;
    var onTop = cursorPos.y <= screen.y + threshold;
    var onBottom = cursorPos.y >= screen.y + screen.height - threshold;

    var nearCenterX = Math.abs(cursorPos.x - centerX) < threshold;
    var nearCenterY = Math.abs(cursorPos.y - centerY) < threshold;

    if (onTop && onLeft) {
        tileWindow(client, "top-left");
    } else if (onTop && onRight) {
        tileWindow(client, "top-right");
    } else if (onBottom && onLeft) {
        tileWindow(client, "bottom-left");
    } else if (onBottom && onRight) {
        tileWindow(client, "bottom-right");
    } else if (onLeft) {
        if (nearCenterY) {
            // Left half
            tileWindow(client, "left");
        } else {
            tileWindow(client, "top-left");
        }
    } else if (onRight) {
        if (nearCenterY) {
            tileWindow(client, "right");
        } else {
            tileWindow(client, "top-right");
        }
    } else if (onTop) {
        tileWindow(client, "up");
    } else if (onBottom) {
        tileWindow(client, "down");
    }
}

function unmaximize(client) {
    if (!client) return;
    var screen = getScreen(client);
    var centerW = Math.floor(screen.width * 0.6);
    var centerH = Math.floor(screen.height * 0.6);
    client.geometry = {
        x: screen.x + Math.floor((screen.width - centerW) / 2),
        y: screen.y + Math.floor((screen.height - centerH) / 2),
        width: centerW,
        height: centerH
    };
}

// Register shortcuts
registerShortcut("Tile Left", "Tile window to left half", "Meta+Left", function() {
    tileWindow(workspace.activeClient, "left");
});

registerShortcut("Tile Right", "Tile window to right half", "Meta+Right", function() {
    tileWindow(workspace.activeClient, "right");
});

registerShortcut("Tile Up", "Tile window to top half", "Meta+Up", function() {
    tileWindow(workspace.activeClient, "up");
});

registerShortcut("Tile Down", "Tile window to bottom half", "Meta+Down", function() {
    tileWindow(workspace.activeClient, "down");
});

registerShortcut("Tile Top-Left", "Tile window to top-left quadrant", "Meta+Ctrl+Left", function() {
    tileWindow(workspace.activeClient, "top-left");
});

registerShortcut("Tile Top-Right", "Tile window to top-right quadrant", "Meta+Ctrl+Right", function() {
    tileWindow(workspace.activeClient, "top-right");
});

registerShortcut("Tile Bottom-Left", "Tile window to bottom-left quadrant", "Meta+Ctrl+Down", function() {
    tileWindow(workspace.activeClient, "bottom-left");
});

registerShortcut("Tile Bottom-Right", "Tile window to bottom-right quadrant", "Meta+Ctrl+Up", function() {
    tileWindow(workspace.activeClient, "bottom-right");
});

registerShortcut("Center Window", "Center the active window", "Meta+C", function() {
    tileWindow(workspace.activeClient, "center");
});

registerShortcut("Unmaximize", "Unmaximize the active window", "Meta+Shift+Down", function() {
    unmaximize(workspace.activeClient);
});

// Connect to window move/resize events for edge snapping
workspace.clientAdded.connect(function(client) {
    client.clientStartUserMovedResized.connect(function() {
        client._moveSnapActive = true;
    });

    client.clientFinishUserMovedResized.connect(function() {
        if (client._moveSnapActive) {
            var cursor = Cursor.currentCursorArea();
            snapWindow(client, null, cursor);
            client._moveSnapActive = false;
        }
    });
});

print("Window Tiler loaded successfully!");
