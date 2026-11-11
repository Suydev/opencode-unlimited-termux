#!/data/data/com.termux/files/usr/bin/bash
# termux guard — watch opencode's log for the free-usage wall and rotate the proxy.
#
# opencode writes its log to ~/.local/share/opencode/log/opencode.log. When the
# wall appears, drop the current proxy and pick a fresh one from the pool. The
# lane reads the pool at launch, so the next launch rides the new egress.
set -u

DEST="$HOME/.local/share/opencode-unlimited-termux"
LOGF="$HOME/.local/share/opencode/log/opencode.log"
POOL="${OUC_PROXY_POOL:-$DEST/proxies.txt}"
LOG="$DEST/guard.log"
mkdir -p "$DEST"

glog() { echo "$(date '+%m-%d %H:%M:%S') $*" >> "$LOG"; }

cur() { cat "$DEST/current-proxy" 2>/dev/null || echo ""; }

rotate() {
  local old np
  old="$(cur)"
  np="$(shuf -n 1 "$POOL" 2>/dev/null || true)"
  [ -n "$np" ] || { glog "rotate: pool empty ($POOL)"; return 1; }
  case "$np" in
    http://*|https://*|socks5://*|socks5h://*) ;;
    *) np="http://$np" ;;
  esac
  printf '%s\n' "$np" > "$DEST/current-proxy"
  glog "rotated: $old -> $np"
}

glog "termux-guard up (log: $LOGF)"
while true; do
  sleep 15
  [ -f "$LOGF" ] || continue
  if tail -n 80 "$LOGF" 2>/dev/null | grep -aqE "Free usage limit|QuotaExceeded|FreeUsageLimitError|usage limit reached"; then
    rotate
    sleep 60   # do not rotate hot
  fi
done
