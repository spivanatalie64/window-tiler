#!/usr/bin/env python3
"""
Window Tiler Daemon
Provides window snapping and tiling for KDE/KWin.
Dependencies: xdotool, xprop, xwininfo
"""

import subprocess
import time
import os
import signal
import sys
import json
from enum import Enum

SNAP_MARGIN = 4
SNAP_THRESHOLD = 30
POLL_INTERVAL = 0.1

class Direction(Enum):
    LEFT = "left"
    RIGHT = "right"
    UP = "up"
    DOWN = "down"
    TOP_LEFT = "top-left"
    TOP_RIGHT = "top-right"
    BOTTOM_LEFT = "bottom-left"
    BOTTOM_RIGHT = "bottom-right"
    MAXIMIZE = "maximize"
    CENTER = "center"

def run(cmd):
    return subprocess.run(cmd, capture_output=True, text=True).stdout.strip()

def get_active_window():
    return run(["xdotool", "getactivewindow"])

def get_window_geometry(wid):
    data = run(["xdotool", "getwindowgeometry", "--shell", wid])
    geo = {}
    for line in data.splitlines():
        if "=" in line:
            k, v = line.split("=", 1)
            geo[k.lower()] = int(v)
    return geo

def get_window_state(wid):
    data = run(["xprop", "-id", wid, "_NET_WM_STATE"])
    return data

def get_screen_geometry():
    data = run(["xdotool", "getdisplaygeometry"])
    parts = data.split()
    return {"width": int(parts[0]), "height": int(parts[1]), "x": 0, "y": 0}

def get_cursor_pos():
    data = run(["xdotool", "getmouselocation", "--shell"])
    pos = {}
    for line in data.splitlines():
        if "=" in line:
            k, v = line.split("=", 1)
            pos[k.lower()] = int(v)
    return pos

def tile_window(wid, direction):
    screen = get_screen_geometry()
    geo = get_window_geometry(wid)

    if "width" not in geo:
        return

    half_w = screen["width"] // 2 - SNAP_MARGIN
    half_h = screen["height"] // 2 - SNAP_MARGIN
    full_w = screen["width"] - SNAP_MARGIN * 2
    full_h = screen["height"] - SNAP_MARGIN * 2

    positions = {
        Direction.LEFT:         (SNAP_MARGIN, SNAP_MARGIN, half_w, full_h),
        Direction.RIGHT:        (screen["width"] - half_w - SNAP_MARGIN, SNAP_MARGIN, half_w, full_h),
        Direction.UP:           (SNAP_MARGIN, SNAP_MARGIN, full_w, half_h),
        Direction.DOWN:         (SNAP_MARGIN, screen["height"] - half_h - SNAP_MARGIN, full_w, half_h),
        Direction.TOP_LEFT:     (SNAP_MARGIN, SNAP_MARGIN, half_w, half_h),
        Direction.TOP_RIGHT:    (screen["width"] - half_w - SNAP_MARGIN, SNAP_MARGIN, half_w, half_h),
        Direction.BOTTOM_LEFT:  (SNAP_MARGIN, screen["height"] - half_h - SNAP_MARGIN, half_w, half_h),
        Direction.BOTTOM_RIGHT: (screen["width"] - half_w - SNAP_MARGIN, screen["height"] - half_h - SNAP_MARGIN, half_w, half_h),
        Direction.MAXIMIZE:     (SNAP_MARGIN, SNAP_MARGIN, full_w, full_h),
        Direction.CENTER:       (screen["width"] // 2 - full_w // 4, screen["height"] // 2 - full_h // 4, full_w // 2, full_h // 2),
    }

    if direction in positions:
        x, y, w, h = positions[direction]
        run(["xdotool", "windowmove", wid, str(x), str(y)])
        run(["xdotool", "windowsize", wid, str(w), str(h)])

def get_snap_direction(cursor, screen):
    threshold = SNAP_THRESHOLD
    center_x = screen["width"] / 2
    center_y = screen["height"] / 2

    on_left = cursor["x"] <= threshold
    on_right = cursor["x"] >= screen["width"] - threshold
    on_top = cursor["y"] <= threshold
    on_bottom = cursor["y"] >= screen["height"] - threshold
    near_center_x = abs(cursor["x"] - center_x) < threshold
    near_center_y = abs(cursor["y"] - center_y) < threshold

    if on_top and on_left:
        return Direction.TOP_LEFT
    elif on_top and on_right:
        return Direction.TOP_RIGHT
    elif on_bottom and on_left:
        return Direction.BOTTOM_LEFT
    elif on_bottom and on_right:
        return Direction.BOTTOM_RIGHT
    elif on_left:
        return Direction.LEFT
    elif on_right:
        return Direction.RIGHT
    elif on_top:
        return Direction.UP
    elif on_bottom:
        return Direction.DOWN
    return None

def handle_snap():
    prev_wid = None
    prev_pos = None

    while True:
        try:
            wid = get_active_window()
            cursor = get_cursor_pos()
            state = get_window_state(wid)

            # Check if window is being moved (left mouse button held + alt typically)
            # We detect by checking if window position changed while mouse is moving
            geo = get_window_geometry(wid)

            if prev_wid == wid and prev_pos and "x" in geo:
                dx = abs(geo["x"] - prev_pos.get("x", geo["x"]))
                dy = abs(geo["y"] - prev_pos.get("y", geo["y"]))

                # If window moved and we're near a screen edge
                if dx > 5 or dy > 5:
                    direction = get_snap_direction(cursor, get_screen_geometry())
                    if direction:
                        tile_window(wid, direction)
                        time.sleep(0.3)  # Debounce

            prev_wid = wid
            prev_pos = geo
            time.sleep(POLL_INTERVAL)

        except Exception as e:
            time.sleep(POLL_INTERVAL)

class TilerCLI:
    @staticmethod
    def tile(direction_str):
        wid = get_active_window()
        try:
            direction = Direction(direction_str)
        except ValueError:
            print(f"Invalid direction: {direction_str}")
            print(f"Valid: {', '.join(d.value for d in Direction)}")
            return
        tile_window(wid, direction)

    @staticmethod
    def snap():
        handle_snap()

    @staticmethod
    def daemon():
        print("Window Tiler Daemon started (PID: %d)" % os.getpid())
        handle_snap()

def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  tiler-daemon.py tile <direction>   # Tile active window")
        print("  tiler-daemon.py daemon              # Run snapping daemon")
        print("  tiler-daemon.py snap                # Run snapping (foreground)")
        print("")
        print("Directions: %s" % ", ".join(d.value for d in Direction))
        sys.exit(1)

    command = sys.argv[1]
    if command == "tile" and len(sys.argv) > 2:
        TilerCLI.tile(sys.argv[2])
    elif command == "daemon":
        TilerCLI.daemon()
    elif command == "snap":
        TilerCLI.snap()
    else:
        print("Unknown command")
        sys.exit(1)

if __name__ == "__main__":
    main()
