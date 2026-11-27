#!/usr/bin/env bash
set -euo pipefail
# Run as the desktop user; xdg-mime writes per-user defaults.
xdg-mime default thunar.desktop inode/directory
xdg-mime default org.gnome.TextEditor.desktop text/plain
xdg-mime default org.mozilla.firefox.desktop text/html application/xhtml+xml x-scheme-handler/http x-scheme-handler/https application/pdf
xdg-mime default org.kde.gwenview.desktop image/jpeg image/png image/gif image/webp image/bmp image/tiff
xdg-mime default vlc.desktop video/mp4 video/mpeg video/webm video/x-matroska video/quicktime audio/mpeg audio/ogg audio/wav audio/flac audio/aac
xdg-mime default xarchiver.desktop application/zip application/gzip application/x-tar application/x-xz application/x-bzip2 application/x-7z-compressed application/vnd.rar application/x-rar

# xdg-settings may need a running X session; MIME defaults above still apply.
if [[ -n ${DISPLAY:-} ]]; then xdg-settings set default-web-browser org.mozilla.firefox.desktop || echo "Check default browser after login."; fi
