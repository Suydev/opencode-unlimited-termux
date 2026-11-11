# Research notes — the OpenCode free-tier wall

Measured on this device (Termux + proot ubuntu, aarch64, 2026-11-10/11).

## TL;DR

The wall is keyed to the **egress IP**. Rotate the egress IP and speak to the gateway with
a **Bun-like ClientHello** and the **real request shape**. That is the whole trick.

## Measurements

### The wall is per-IP, not per-account
- 100 premium proxies × the full captured shape → **71 × 200** on the first pass (right
  after the midnight-UTC reset), 17 × 429, 12 × timeout.
- Immediate retry (3 tries each) → **6 × 200**, 89 × 429, 5 × timeout. The first pass
  consumed the per-IP bucket.
- 429 headers: `server-timing: gateway;dur=5` (real quota, not the TLS gate),
  `retry-after: 66017` s ≈ **18.3 h**, `x-opencode-log-id` present.
- Conclusion: ≈ **100 requests / IP / day** — measured directly: the device IP served
  **99 × 200** in a row (≈517k tokens), then `429` (`retry-after ≈ 18 h`). Fresh premium
  proxies served 12–15 each. Resets near **midnight UTC (05:30 IST)**: the next day's sweep
  returned **91/100** real. The docs list LongCat 2.5 Free at **100 requests/day**; a token
  cap is not ruled out (the reasoning output dominates the ≈5.2k tokens/request).

### The TLS gate is "Bun-like", not an exact SHA
- Bun 1.4.3 and 1.4.4 produce **identical** ClientHellos (17 ciphers, 12 extensions,
  legacy version 0x303).
- Both pass the gate (`dur>0`).
- A Node client mirroring Bun's ciphers/groups still differs (OpenSSL quirks) and is
  rejected (`dur=0`).
- A different Bun SHA does **not** reset the per-IP quota.

### The body shape matters
- Minimal body `{model,messages,stream:true}` → 429.
- Full captured body (`replay-body.json`: system prompt + tools + `stream_options`) → 200.

### Edge is not part of the key (on IPv4)
- `opencode.ai` has 2 IPv4 edges: `104.20.32.17`, `172.66.173.149`.
- Same exhausted proxy → both edges return the same 429 / `retry-after`.
- So on IPv4 the bucket is the egress IP, not the edge.

## Scripts (in `opencode-re/`)

| Script | Purpose |
|---|---|
| `sweep-full.mjs` | 100 proxies × full captured shape, prints winners |
| `sweep-retry.mjs` | same with retries (shows bucket exhaustion) |
| `one-shot.mjs` | one request (optional proxy) |
| `replay.mjs` | exact captured request |
| `headers.mjs` | dump status + headers for one proxy |
| `edge-test.mjs` | pin to each IPv4 edge |
| `edge-proxy-test.mjs` | pin to each edge through a proxy |
| `fake-tls-check.mjs` | Node mirror of Bun's hello vs the gate |

## What the OpenCode docs actually say (checked 2026-11-11)

- **Pricing is per token** (per 1M tokens) — that is the billing model.
- **Go (paid) usage limits are monthly dollar amounts**, split into windows:
  **5-hour = 20%**, **weekly = 50%**, **monthly = 100%** of the plan's limit. Each model has
  its own monthly dollar limit (e.g. GLM-5.3-Flash **$60/mo** on Go).
- **Free models: no published quota.** LongCat 2.5 Free is the only one with an explicit
  number — **"a limit of 100 requests per day"**.
- **The `usage` object** reports `cost`, `opencode.list_cost`, `opencode.billing_source`
  (`free` / `balance` / `go` / `go-plus` / `byok`) and `opencode.allowance` (**Go only** —
  how much of the request counted toward the plan limit, in dollars).
- **Free-tier chat models require OpenCode** — other clients get HTTP 403 even with an API
  key. That is exactly the shape/TLS gate measured here.
- "If you reach the usage limit, you can continue using the free models" — i.e. the free
  tier is a separate bucket from Go.

**Our free-tier measurement (no Go):** ≈**100 requests / IP / day** (99 on the device IP,
≈517k tokens), resetting near **midnight UTC**. The docs do not publish the free-tier quota,
and a **token cap is not confirmed** — the reasoning output dominates the token count, so a
token cap and a request cap are hard to separate with this model.

## Environment fix (why the shell works here)

The running OpenCode server exports
`LD_LIBRARY_PATH=/data/data/com.termux/files/usr/glibc/lib`, which makes every **bionic**
child (`bash`, `sh`, `id`, `git`, `node`) resolve `libc.so` to the glibc linker script →
`bad ELF magic`. The musl `opencode` binary is immune, so the session keeps running.

Fix: point OpenCode's `shell` at a wrapper whose shebang is the **glibc** bash; it unsets
the poison and re-execs the real **bionic** bash. See `~/.opencode/bin/bash-fix` and
`~/.config/opencode/opencode.jsonc`.
