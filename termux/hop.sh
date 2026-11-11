#!/data/data/com.termux/files/usr/bin/bash
# termux hop — manually rotate to a fresh proxy right now.
set -u

DEST="$HOME/.local/share/opencode-unlimited-termux"
POOL="${OUC_PROXY_POOL:-$DEST/proxies.txt}"

[ -f "$POOL" ] || { echo "proxy pool not found: $POOL"; exit 1; }

np="$(shuf -n 1 "$POOL" 2>/dev/null)"
[ -n "$np" ] || { echo "pool empty"; exit 1; }
case "$np" in
  http://*|https://*|socks5://*|socks5h://*) ;;
  *) np="http://$np" ;;
esac

mkdir -p "$DEST"
printf '%s\n' "$np" > "$DEST/current-proxy"
echo "fresh proxy: $np"
echo "next 'opencode-unlimited-lane' launch rides it."
