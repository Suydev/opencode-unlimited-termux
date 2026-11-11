#!/data/data/com.termux/files/usr/bin/bash
# termux lane — run opencode with a rotating proxy egress.
#
# The free-tier wall is keyed to the egress IP. On Android/Termux there is no root,
# no TUN and no Cloudflare WARP, so the egress identity is rotated through a proxy
# pool instead: one random proxy per launch, exported as HTTPS_PROXY / ALL_PROXY.
set -u

DEST="$HOME/.local/share/opencode-unlimited-termux"
POOL="${OUC_PROXY_POOL:-$DEST/proxies.txt}"
REAL="${OUC_REAL_BIN:-$HOME/.opencode/bin/opencode}"

if [ ! -x "$REAL" ]; then
  for c in "$HOME/.local/bin/opencode" /data/data/com.termux/files/usr/bin/opencode /usr/local/bin/opencode; do
    [ -x "$c" ] && [ "$c" != "$(readlink -f "$0" 2>/dev/null)" ] && REAL="$c" && break
  done
fi
[ -x "$REAL" ] || { echo "opencode binary not found — set OUC_REAL_BIN"; exit 1; }

normalize() {
  case "$1" in
    http://*|https://*|socks5://*|socks5h://*) printf '%s\n' "$1" ;;
    *) printf 'http://%s\n' "$1" ;;
  esac
}

pick_proxy() {
  [ -f "$POOL" ] || { echo "proxy pool not found: $POOL"; return 1; }
  local line
  line="$(shuf -n 1 "$POOL" 2>/dev/null)" || {
    local n
    n=$(wc -l < "$POOL" 2>/dev/null || echo 0)
    [ "$n" -gt 0 ] || return 1
    line="$(sed -n "$((RANDOM % n + 1))p" "$POOL")"
  }
  [ -n "$line" ] || return 1
  normalize "$line"
}

PROXY="$(pick_proxy || true)"
if [ -n "$PROXY" ]; then
  export HTTPS_PROXY="$PROXY"
  export ALL_PROXY="$PROXY"
  export HTTP_PROXY="$PROXY"
  mkdir -p "$DEST"
  printf '%s\n' "$PROXY" > "$DEST/current-proxy"
fi

# OpenCode on Termux is a musl binary; it needs its loader (the plain exec fails with
# "cannot execute: required file not found"). Prefer the loader + musl binary.
OC_DIR="$HOME/.opencode"
if [ -x "$OC_DIR/ld-musl-aarch64.so.1" ] && [ -f "$OC_DIR/opencode" ]; then
  exec "$OC_DIR/ld-musl-aarch64.so.1" --library-path "$OC_DIR" "$OC_DIR/opencode" "$@"
fi
exec "$REAL" "$@"
