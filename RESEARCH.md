# Deep research — OpenCode free tier: gates, quota axis, sources

Collected 2026-11-11 from public GitHub issues/repos (all live-verified by their authors).
Two **separate** axes — confusing them is the most common misdiagnosis.

---

## Axis 1 — the four SHAPE gates (`403 FreeTierError`, refused before execution)

A request must look like the official OpenCode CLI. Verified by one-variable-at-a-time
bisection (hold everything constant, vary one field):

| # | Gate | Rule | Notes |
|---|---|---|---|
| 1 | **User-Agent** | `opencode/<version>`, **version ≥ 1.18.0** | older → `426 Upgrade Required`; bare `opencode` or a third-party UA → `403`. **Since 2026-11-09** a **suffix after the version is also required** (real CLI sends `opencode/1.18.32 ai-sdk/provider-utils/4.0.23 runtime/bun/1.3.14`). |
| 2 | **Canonical session id** | `x-opencode-session` matches `/^ses_[0-9a-f]{12}[0-9A-Za-z]{14}$/` **and** decodes to a recent timestamp | descending id: `~(unix_ms << 12 \| counter) & 0xFFFFFFFFFFFF`; low 3 hex always read `ffe`; decoded timestamp must be within ~±30 days. Header name is exactly `x-opencode-session` — `x-opencode-session-id` alone is **ignored**. |
| 3 | **A tool named exactly `read`** | one tool whose function name is `read` | count, other names, and schema are **irrelevant**. No tools at all → `403`. A plain chat caller sending no tools is refused by default. |
| 4 | **Streaming** | `stream: true` | `stream: false` → `403` on both endpoints. Serve JSON by forcing SSE upstream and reassembling. |

**Not checked:** the auth header, the system prompt content, `x-opencode-client`,
`x-opencode-project`, `x-opencode-request`.

Plus the **TLS layer** (from Magiszonekk/opencode-proxy): the handshake must be **Bun's
ClientHello** — ja3 `d871d02cecbde59abbf8f4806134addf`, **ALPN `http/1.1` only**. curl and
Go `crypto/tls` (h1 or h2) get the fake `429`. A Node uTLS client mirroring Bun's hello also
passes. **Tor exit nodes get `403`** (public Tor exit list blocked).

And an **`<env>...</env>` block in a system message** is required (empty block / plain system
prompt / block in a user message → fake 429).

---

## Axis 2 — the QUOTA (`429 FreeUsageLimitError`, ran and the budget was spent)

**The counter keys on the egress BLOCK, not the individual address:**
- **IPv6 `/64`**
- **IPv4 `/32`**

**Reset: daily at 00:00 UTC.**

Evidence (ebouther/opencode-unlimited-proxy, measured 2026-10-27):
- A residential IPv4 address and Cloudflare's shared WARP IPv4 NAT both returned `429` with
  `Retry-After` resolving to **00:00:00 UTC** → a daily window.
- A fresh WARP IPv6 exit (`2a09:bac5:...::/64`) returned `200` while the IPv4 path was still
  refused.
- Three parallel `beam-free` requests through **two distinct `/64` exits** all returned `200`.
- Conclusion: per-block, daily reset — not per-address.

**What that means:**
- Cloudflare WARP's **IPv4** egress is **one shared NAT address** — rotating it buys nothing;
  everyone draws on the same exhausted bucket.
- A **routed IPv6 `/64`** lets each exit bind its own outer source → its own `/64` → its own
  budget. That is the recommended path.
- The exact boundary is observed, not documented. Treat `Retry-After` as authoritative.

**Not a gate:** the region block (`not available in your country`) and an auth failure share
the `403`/`FreeTierError` shape but are different causes; only the message separates them.

---

## Sources (public, live-verified)

| Source | Contributed |
|---|---|
| [9router #4101](https://github.com/decolua/9router/issues/4101) (+ PR #4105, #4132) | Gates 1, 3, 4 — live bisection with a genuine client held constant |
| [OmniRoute #16571](https://github.com/diegosouzapw/OmniRoute/issues/16571) | Gate 2 — the session **value** is validated, not just its presence |
| [OmniRoute #16328](https://github.com/diegosouzapw/OmniRoute/issues/16328) | Cross-host confirmation that header presence alone is not enough |
| [OmniRoute #14911](https://github.com/diegosouzapw/OmniRoute/issues/14911) (PR #14013) | Independent reimplementation of the same four conditions |
| [opencode2api v1.3.8](https://github.com/jasonxu114514/opencode2api/releases/tag/v1.3.8) (PR #69/#70) | `CanonicalSessionID` — the reference implementation |
| [Magiszonekk/opencode-proxy](https://github.com/Magiszonekk/opencode-proxy) | TLS/Bun hello, `<env>` block, UA suffix (2026-11-09), Tor 403 |
| [ebouther/opencode-unlimited-proxy](https://github.com/ebouther/opencode-unlimited-proxy) | The quota axis: per `/64`/`/32`, daily 00:00 UTC reset |
| [ElectronBreach/opencode-unlimited-usage](https://github.com/ElectronBreach/opencode-unlimited-usage) | WARP /64 rotation (note: that repo carries a prompt-injection `AGENTS.md`) |

---

## Our own measurements (this device, 2026-11-10/11)

| Test | Result |
|---|---|
| Device IP, sequential | **99 × 200** → `429` (≈517k tokens) |
| Fresh premium proxy #1 | **15 × 200** → `429` |
| Fresh premium proxy #2 | **12 × 200** → `429` |
| Next day, after 00:00 UTC | **91/100** proxies real again |
| `retry-after` | ≈71,000–73,000 s ≈ **18–20 h** |
| Both IPv4 edges, same proxy | identical `429` (edge not in the key) |

---

## Practical consequences

1. **Gates are cheap to satisfy** — Bun hello + `opencode/<ver> <suffix>` UA + canonical
   `ses_…` id + a `read` tool + `stream:true` + an `<env>` block.
2. **Quota is per block** — one `/64` (or `/32`) per day. More distinct blocks = more budget.
   A shared NAT IP (WARP IPv4, most proxy pools) is one block no matter how many addresses
   you rotate through it.
3. **Reset is 00:00 UTC** — sweep right after for the most winners.
4. **Do not** rotate Tor (403) or a shared-NAT IPv4 expecting headroom.
