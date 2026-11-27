# Keyboard shortcuts

Based on the owner's active Omarchy report, November 2026. These are intended equivalents, not yet runtime-tested. Super means the Windows key.

| Shortcut | Action |
|---|---|
| Super + Space / Alt + Super + Space | Rofi application launcher |
| Super + Enter / Ctrl + Alt + T | Kitty |
| Super + E | Emote emoji picker |
| Super + Shift + F | Thunar |
| Super + Shift + B / Enter | Browser |
| Super + Shift + Alt + B | Private Firefox window |
| Super + Shift + N | GNOME Text Editor |
| Super + Shift + Q | Calculator |
| Super + Ctrl + V | Clipboard history |
| Super + Escape | Power menu |
| Super + Ctrl + L / Ctrl + Alt + L | Lock |
| Super + arrows | Directional focus |
| Super + Shift + arrows | Swap windows |
| Super + 1–0 | Workspaces 1–10 |
| Super + Shift + 1–0 | Move and follow |
| Super + Shift + Alt + 1–0 | Move silently |
| Super + Tab / Shift + Super + Tab | Next / previous workspace on current monitor |
| Super + Ctrl + Tab | Former workspace |
| Alt + Tab / Alt + Shift + Tab | Next / previous visible window |
| Ctrl + Alt + Tab / Shift + Ctrl + Alt + Tab | Next / previous monitor |
| Super + Ctrl + Shift + arrows | Move window to monitor |
| Super + Shift + Alt + arrows | Move workspace to monitor |
| Super + W / Q | Close window |
| Super + F | Fullscreen |
| Super + Ctrl + F | Monocle (approximation of tiled fullscreen) |
| Super + T | Floating |
| Super + P | Pseudo-tiling |
| Super + J | Rotate parent split (approximation) |
| Super + L / Alt + Super + L | Toggle tiled/monocle layout |
| Super + minus / equals | Horizontal resize |
| Super + Shift + minus / equals | Vertical resize |
| Add Alt / Ctrl to resize | Fine / large increments |
| Super + K | This shortcut guide |
| Super + Ctrl + A/B/D/N/P | Audio/Bluetooth/display/network/power settings |
| Super + comma / Super + Alt + comma | Dismiss notification |
| Super + Shift + comma | Dismiss all |
| Super + Ctrl + comma | Notification context |
| Super + Shift + Alt + comma | Notification history item |
| Super + Ctrl + Alt + comma | Toggle notification silence |
| Print / Super + Ctrl + Alt + C | Flameshot |
| Super + Alt + R | Restart bspwm |
| Super + Ctrl + Alt + K/B/P | Edit shortcuts/window manager/bar |

Media keys: volume, mic mute, playback, brightness; Alt gives fine volume/brightness; Shift brightness sets max/min. Super + mouse left/right uses bspwm move/resize. Hardware and session testing required.

## Deliberately not implemented yet

- Universal Super+A/C/V/X: application-aware remapping (especially terminal copy/paste) needs careful testing. Normal Ctrl shortcuts remain available; do not use naive global remapping that hijacks terminal control keys.
- Scratchpad, Quake console, grouping, minimisation dock, pinned float, full width and saved window width: no exact native equivalent; avoid adding complex scripts without a demonstrated need.
- Omarchy menus, bar panels, transparency/gaps/theme toggles, scaling/zoom, capture extras, reminders, dictation, app-specific/web shortcuts and input-language cycling: defer or selectively map after review.
- Keyboard backlight, touchpad toggles, eject, output/source switching, lid events, power button and scroll workspace/group shortcuts: hardware-specific or require extra testing.
- File manager at focused terminal's cwd: not portable across applications, defer.
- Close-all shortcut intentionally omitted to prevent accidental loss of work.
- No global Escape binding (would interfere with ordinary application use).

The active report gives descriptions and Lua dispatch IDs, not original commands; exact app choices and implementation are inferred. No raw user report is committed. Validate all mappings in VM and on hardware, especially workspace numbering, multi-monitor movement, resizing and key conflicts. After editing sxhkd, run pkill -USR1 -x sxhkd.
