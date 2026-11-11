# opencode-unlimited-termux

Effectively **unlimited OpenCode free tier** on **Termux / Android** — no root, no
systemd, no Cloudflare WARP, no TUN.

Built on the model measured on-device (2026-11-10/11). It is not a magic flag; it is the
correct rotation of the one thing the wall is keyed to.

## The model (measured)

| Fact | Measurement |
|---|---|
| Wall key | **egress IP**, not the account |
| Quota | ≈ **1 request / IP / day** with the real client shape |
| Reset | near **midnight UTC (05:30 IST)**; `retry-after ≈ 18 h` |
| TLS gate | requires a **Bun-like ClientHello**; `server-timing: gateway;dur=0` = TLS rejected, `dur>0` = reached the inference service |
| Body gate | a **minimal body is rejected**; the full captured shape is accepted |
| 429 is real quota | `dur>0` + `x-opencode-log-id` present |

**Consequence:** rotate the **egress IP** (proxy pool) and speak to the gateway with
**Bun** and the **real request shape**. That is the whole trick.

## Components

| Piece | Role |
|---|---|
| `termux/lane.sh` | runs `opencode` with a random proxy egress |
| `termux/guard.sh` | tails opencode's log; on the wall, rotates the proxy |
| `termux/hop.sh` | manual "give me a fresh proxy now" |
| `termux/install.sh` | one-command setup (background loops, no systemd) |
| `termux/proxies.txt` | the proxy pool |
| `bridge/` | [opencode-free-bridge](https://github.com/azrinaldi/opencode-free-bridge) v2.3.1 — Bun TLS + proxy pool + `/v1/messages` |
| `NOTES.md` | the full research log |

## Setup

```sh
bash termux/install.sh
```

The installer:

1. copies the lane/guard/hop to `~/.local/share/opencode-unlimited-termux/`
2. installs `opencode-unlimited-*` wrappers into `~/.local/bin/`
3. starts the guard under `nohup` (no systemd on Android)

Then run OpenCode through the lane:

```sh
opencode-unlimited-lane            # interactive
opencode-unlimited-lane run "..."  # one-shot
```

When the wall hits, the guard rotates the proxy automatically; `opencode-unlimited-hop`
does it on demand.

## Proxy pool

One `host:port` or `user:pass@host:port` per line:

```sh
cp termux/proxies.txt ~/.local/share/opencode-unlimited-termux/proxies.txt
$EDITOR ~/.local/share/opencode-unlimited-termux/proxies.txt
opencode-unlimited-hop
```

## Pairing with the bridge

For the Bun TLS + real shape, point OpenCode at the bridge instead of a bare proxy:

```sh
# bridge on :20129 (Bun, proxy pool, /v1/messages)
opencode --provider opencode-free/glm-5.3-flash-free ...
```

The bridge already rotates its egress on a 429; the lane/guard add the proactive
rotation and the log-based wall detection.

## measured results (this device)

- 100 premium proxies × full captured shape → **71 × 200** on the first pass after the
  midnight-UTC reset; **6 × 200** on an immediate retry (per-IP bucket consumed).
- Bun 1.4.3 and 1.4.4 produce **identical** ClientHellos; the gate accepts both
  (`dur>0`), so the TLS gate is "Bun-like", not an exact-SHA match.
- A different ClientHello SHA does **not** reset the per-IP quota.

See `NOTES.md` for the raw numbers and scripts.
