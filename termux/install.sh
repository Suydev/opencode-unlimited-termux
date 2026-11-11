#!/data/data/com.termux/files/usr/bin/bash
# Termux/Android installer for opencode-unlimited-termux.
#
# No systemd on Android: the guard runs under nohup. Everything lives under
# ~/.local/share/opencode-unlimited-termux/ and ~/.local/bin/.
set -u

DEST="$HOME/.local/share/opencode-unlimited-termux"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[install] opencode-unlimited-termux (Termux/Android)"

# 1. scripts + pool
mkdir -p "$DEST/scripts" "$HOME/.local/bin"
cp "$SRC/termux/lane.sh"  "$DEST/scripts/lane.sh"
cp "$SRC/termux/guard.sh" "$DEST/scripts/guard.sh"
cp "$SRC/termux/hop.sh"   "$DEST/scripts/hop.sh"
cp "$SRC/termux/proxies.txt" "$DEST/proxies.txt"
chmod +x "$DEST/scripts/"*.sh

# 2. wrappers
ln -sf "$DEST/scripts/lane.sh"  "$HOME/.local/bin/opencode-unlimited-lane"
ln -sf "$DEST/scripts/guard.sh" "$HOME/.local/bin/opencode-unlimited-guard"
ln -sf "$DEST/scripts/hop.sh"   "$HOME/.local/bin/opencode-unlimited-hop"

# 3. guard (background, no systemd)
if pgrep -f "$DEST/scripts/guard.sh" >/dev/null 2>&1; then
  echo "[install] guard already running"
else
  nohup bash "$DEST/scripts/guard.sh" >> "$DEST/guard.log" 2>&1 &
  echo "[install] guard started (pid $!)"
fi

# 4. PATH hint
case ":$PATH:" in
  *":$HOME/.local/bin:"*) : ;;
  *) echo "[install] add to ~/.bashrc: export PATH=\"\$HOME/.local/bin:\$PATH\"" ;;
esac

echo "[install] done."
echo "  run:      opencode-unlimited-lane"
echo "  rotate:   opencode-unlimited-hop"
echo "  guard log: $DEST/guard.log"
