#!/bin/bash
# Generate XPM icon files for window decoration buttons
# Left: Up, Down, Left, Right (directional snap)
# Right: Close, Minimize, Maximize/Restore

ICON_DIR="$HOME/.fvwm/decorations/icons"
mkdir -p "$ICON_DIR"

# Directional arrow icons
make_arrow_up() {
    cat > "$ICON_DIR/arrow_up.xpm" << 'XPMEOF'
/* XPM */
static char *arrow_up[] = {
"22 22 2 1",
"  c None",
". c #ecf0f1",
"                  ",
"                  ",
"        ..        ",
"       ....       ",
"      ......      ",
"     ........     ",
"    ..........    ",
"   ............   ",
"  ..............  ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"                  ",
"                  ",
"                  ",
"                  "
};
XPMEOF
}

make_arrow_down() {
    cat > "$ICON_DIR/arrow_down.xpm" << 'XPMEOF'
/* XPM */
static char *arrow_down[] = {
"22 22 2 1",
"  c None",
". c #ecf0f1",
"                  ",
"                  ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"        ..        ",
"  ..............  ",
"   ............   ",
"    ..........    ",
"     ........     ",
"      ......      ",
"       ....       ",
"        ..        ",
"                  ",
"                  ",
"                  "
};
XPMEOF
}

make_arrow_left() {
    cat > "$ICON_DIR/arrow_left.xpm" << 'XPMEOF'
/* XPM */
static char *arrow_left[] = {
"22 22 2 1",
"  c None",
". c #ecf0f1",
"                  ",
"                  ",
"        ..        ",
"       ...        ",
"      ....        ",
"     .....        ",
"    ......        ",
"   .......        ",
"  ............... ",
"  ............... ",
"  ............... ",
"  ............... ",
"  ............... ",
"   .......        ",
"    ......        ",
"     .....        ",
"      ....        ",
"       ...        ",
"        ..        ",
"                  ",
"                  ",
"                  "
};
XPMEOF
}

make_arrow_right() {
    cat > "$ICON_DIR/arrow_right.xpm" << 'XPMEOF'
/* XPM */
static char *arrow_right[] = {
"22 22 2 1",
"  c None",
". c #ecf0f1",
"                  ",
"                  ",
"        ..        ",
"       ...        ",
"      ....        ",
"     .....        ",
"    ......        ",
"   .......        ",
"  ............... ",
"  ............... ",
"  ............... ",
"  ............... ",
"  ............... ",
"   .......        ",
"    ......        ",
"     .....        ",
"      ....        ",
"       ...        ",
"        ..        ",
"                  ",
"                  ",
"                  "
};
XPMEOF
}

# Standard window control icons
make_close() {
    cat > "$ICON_DIR/close.xpm" << 'XPMEOF'
/* XPM */
static char *close_icon[] = {
"22 22 2 1",
"  c None",
". c #e74c3c",
"                  ",
"  ..          ..  ",
"   ..        ..   ",
"    ..      ..    ",
"     ..    ..     ",
"      ..  ..      ",
"       ....       ",
"        ..        ",
"       ....       ",
"      ..  ..      ",
"     ..    ..     ",
"    ..      ..    ",
"   ..        ..   ",
"  ..          ..  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  "
};
XPMEOF
}

make_minimize() {
    cat > "$ICON_DIR/minimize.xpm" << 'XPMEOF'
/* XPM */
static char *minimize_icon[] = {
"22 22 2 1",
"  c None",
". c #ecf0f1",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"  ..............  ",
"  ..............  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  "
};
XPMEOF
}

make_maximize() {
    cat > "$ICON_DIR/maximize.xpm" << 'XPMEOF'
/* XPM */
static char *maximize_icon[] = {
"22 22 2 1",
"  c None",
". c #ecf0f1",
"                  ",
"                  ",
"  ..............  ",
"  ..............  ",
"  ..          ..  ",
"  ..          ..  ",
"  ..          ..  ",
"  ..          ..  ",
"  ..          ..  ",
"  ..          ..  ",
"  ..          ..  ",
"  ..          ..  ",
"  ..          ..  ",
"  ..          ..  ",
"  ..          ..  ",
"  ..          ..  ",
"  ..............  ",
"  ..............  ",
"                  ",
"                  ",
"                  ",
"                  "
};
XPMEOF
}

make_restore() {
    cat > "$ICON_DIR/restore.xpm" << 'XPMEOF'
/* XPM */
static char *restore_icon[] = {
"22 22 2 1",
"  c None",
". c #ecf0f1",
"                  ",
"    ..........    ",
"    ..........    ",
"    ..      ..    ",
"    ..      ..    ",
"    ..      ..    ",
" .......... ..    ",
" .......... ..    ",
" ..       ....    ",
" ..       ....    ",
" ..       ..      ",
" ..       ..      ",
" ..       ..      ",
" ..       ..      ",
" ..........       ",
" ..........       ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  ",
"                  "
};
XPMEOF
}

generate() {
    make_arrow_up
    make_arrow_down
    make_arrow_left
    make_arrow_right
    make_close
    make_minimize
    make_maximize
    make_restore
    echo "Icons generated in $ICON_DIR"
    ls -1 "$ICON_DIR"/*.xpm
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    generate
fi
