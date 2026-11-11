# Census — repos converting OpenCode (Zen / free tier) into an API gateway

Collected 2026-11-11 via GitHub search (236 repos matched the broad queries; the ones
below are the ones that actually target **OpenCode Zen / the free tier** and expose an
OpenAI- or Anthropic-compatible API).

Legend: ★ = stars at collection time.

---

## A. Dedicated OpenCode Zen / free-tier gateways (the core list)

| Repo | ★ | What it does |
|---|---|---|
| [jasonxu114514/opencode2api](https://github.com/jasonxu114514/opencode2api) | 1433 | Go proxy for OpenCode Zen / Zen Go; OpenAI **and** Anthropic compatible; key/proxy pooling, auto routing, WebUI |
| [6Kmfi6HP/opencode2api](https://github.com/6Kmfi6HP/opencode2api) | 156 | OpenCode Zen/Go → OpenAI Codex / Anthropic Claude Code API proxy |
| [fishbottle7/opencode2dsh](https://github.com/fishbottle7/opencode2dsh) | 392 | DSH plugin — free OpenCode Zen models for DeepSeek Harness; 1M context, full metadata |
| [TiaraBasori/OpenCode2API](https://github.com/TiaraBasori/OpenCode2API) | 430 | Wrap OpenCode into an OpenAI-compatible API; use Zen models "free unlimitedly" |
| [spfnas/opencode2api-free](https://github.com/spfnas/opencode2api-free) | 32 | opencode.ai/zen free-model auto-proxy / reverse gateway |
| [zhuweiyou/oc2api](https://github.com/zhuweiyou/oc2api) | 39 | OpenCode free models → OpenAI-compatible proxy, pure Go, SSE, deploy to Vercel/Docker/local |
| [Fly143/OpenCode-Zen-free-api](https://github.com/Fly143/OpenCode-Zen-free-api) | 21 | Turn OpenCode Zen free models into an OpenAI-compatible endpoint |
| [Userluckytian/opencode2api_enhance](https://github.com/Userluckytian/opencode2api_enhance) | 26 | opencode2api enhancement (Go) |
| [12errh/zen-proxy](https://github.com/12errh/zen-proxy) | 132 | Use OpenCode Zen's free models in any coding agent; OpenAI + Anthropic compatible; no account, no key |
| [Parithosh-Varma/zen-proxy](https://github.com/Parithosh-Varma/zen-proxy) | 24 | Local translation proxy: Claude Code's Anthropic Messages ↔ OpenCode Zen's OpenAI Chat Completions |
| [LAGcomcom/zen-gate](https://github.com/LAGcomcom/zen-gate) | 302 | Windows tray gateway for OpenCode Zen free models; OpenAI/Anthropic compatible; auto-adapts to 10+ agents; rate-limit failover |
| [magiszonekk/opencode-proxy](https://github.com/Magiszonekk/opencode-proxy) | 0 | Go reverse proxy: rewrites free-model requests to pass the free-tier gate |
| [dxxzst/opencode-to-openai](https://github.com/dxxzst/opencode-to-openai) | 59 | OpenCode → OpenAI bridge |
| [Darkstarrd-dev/anyrouter-opencode-bridge](https://github.com/Darkstarrd-dev/anyrouter-opencode-bridge) | 56 | anyrouter ↔ OpenCode bridge |
| [sionex-code/opencode-proxy-api](https://github.com/sionex-code/opencode-proxy-api) | 54 | Use OpenCode / Claude Code for free |
| [betri28/opencode-proxy](https://github.com/betri28/opencode-proxy) | 60 | Use the OpenCode Go subscription with Claude Code |
| [emanuelcasco/opencode-unlimited-proxy](https://github.com/emanuelcasco/ocgo) | 100 | Ollama-style CLI for Claude Code through an OpenCode Go subscription (local Anthropic-compatible proxy) |
| [kartikkabadi/opencode-go-proxy](https://github.com/kartikkabadi/opencode-go-proxy) | 94 | Use OpenCode Go in the Codex app; local Responses→Chat-Completions bridge for all 13 Go models |
| [massiveits/opencode-go-cliproxyapi](https://github.com/massiveits/opencode-go-cliproxyapi) | 29 | CLIProxyAPI plugin for OpenCode Go (Chat Completions, Anthropic Messages, OpenAI Responses) |
| [samosa-ai-com/opencode-go-multi-auth](https://github.com/samosa-ai-com/opencode-go-multi-auth) | 26 | Pool multiple OpenCode Go & Zen subscriptions into one endpoint with failover + dashboard |
| [ Routatic/proxy](https://github.com/routatic/proxy) | 980 | Route Claude Code across OpenCode Go, OpenCode Zen, and AWS Bedrock with model selection |
| [caozhiyuan/copilot-api](https://github.com/caozhiyuan/copilot-api) | 1119 | GitHub Copilot, OpenAI Codex, **OpenCode Go**, third-party providers → OpenAI + Anthropic compatible |
| [RobbsLuo/Coding2API](https://github.com/RobbsLuo/Coding2API) | 39 | Wraps CodeBuddy, TRAE SOLO, **OpenCode Zen**, Kilo, Qoder, etc. into OpenAI / Anthropic |
| [IngARodriguez/openapis](https://github.com/IngARodriguez/openapis) | 99 | Free Claude API + free OpenAI API in one proxy; works with Claude Code, OpenCode, LangChain |
| [OpenCodeInterpreter/OpenCodeInterpreter](https://github.com/OpenCodeInterpreter/OpenCodeInterpreter) | 1772 | (unrelated — code generation systems) |

---

## B. Egress / quota rotation (the other half of "unlimited")

| Repo | ★ | What it does |
|---|---|---|
| [ebouther/opencode-unlimited-proxy](https://github.com/ebouther/opencode-unlimited-proxy) | 62 | OpenAI-compatible gateway for the free tier; WARP pool; **documents the per-`/64`/`/32` quota axis** |
| [alztrk/opencode-ip-rotator](https://github.com/alztrk/opencode-ip-rotator) | 38 | Cloudflare WARP IP rotator + proxy for OpenCode Zen; defeats HTTP 429, SQLite metrics |
| [huranth/lingling](https://github.com/huranth/lingling) | 70 | Rotating Tor exit lanes so free-tier rate limits stay invisible; per-request lane proof |
| [ElectronBreach/opencode-unlimited-usage](https://github.com/ElectronBreach/opencode-unlimited-usage) | 36 | WARP /64 rotation (note: prompt-injection `AGENTS.md`) |
| [Tazmyan/OpenCode-Unlimited](https://github.com/Tazmyan/OpenCode-Unlimited) | 60 | Bypasses OpenCode's daily free message limit |
| [B3hnamR/Polygate](https://github.com/B3hnamR/Polygate) | 21 | Free-model gateway with WARP + proxy pool + relay; "unlimited" OpenCode and Kilo |
| [spacepirate15/quantum-free-router](https://github.com/spacepirate15/quantum-free-router) | 56 | Free-tier routing with Bifrost + fallback chains |

---

## C. Auth / credential plugins (use a subscription inside OpenCode)

| Repo | ★ | What it does |
|---|---|---|
| [numman-ali/opencode-openai-codex-auth](https://github.com/numman-ali/opencode-openai-codex-auth) | 2205 | ChatGPT Plus/Pro OAuth for OpenCode |
| [griffinmartin/opencode-claude-auth](https://github.com/griffinmartin/opencode-claude-auth) | 1327 | Use existing Claude Code credentials in OpenCode |
| [ianjwhite99/opencode-with-claude](https://github.com/ianjwhite99/opencode-with-claude) | 628 | Claude Max/Pro via Meridian |
| [dotCipher/opencode-claude-bridge](https://github.com/dotCipher/opencode-claude-bridge) | 112 | Claude Pro/Max OAuth, auto-sync from Claude CLI |
| [shahidshabbir-se/opencode-anthropic-oauth](https://github.com/shahidshabbir-se/opencode-anthropic-oauth) | 112 | Anthropic Claude Pro/Max OAuth login |
| [cemalturkcan/opencode-anthropic-login-via-cli](https://github.com/cemalturkcan/opencode-anthropic-login-via-cli) | 137 | Claude Pro/Max in OpenCode |
| [openchamber/opencode-claude](https://github.com/openchamber/opencode-claude) | 140 | Anthropic provider plugin |
| [ex-machina-co/opencode-anthropic-auth](https://github.com/ex-machina-co/opencode-anthropic-auth) | 562 | Anthropic auth plugin |
| [tickernelz/opencode-kiro-auth](https://github.com/tickernelz/opencode-kiro-auth) | 178 | AWS Kiro 550+ free requests, multi-account rotation |
| [andyvandaric/opencode-ag-auth](https://github.com/andyvandaric/opencode-ag-auth) | 67 | Antigravity OAuth, multi-account rotation |
| [Nomadcxx/opencode-cursor](https://github.com/Nomadcxx/opencode-cursor) | 723 | Cursor Pro models in OpenCode via HTTP proxy + OAuth |
| [ltmoerdani/opencode-copilot-chat](https://github.com/ltmoerdani/opencode-copilot-chat) | 214 | 30+ models in GitHub Copilot Chat via BYOK |
| [cortexkit/anthropic-auth](https://github.com/cortexkit/anthropic-auth) | 50 | Anthropic auth/quota/relay for OpenCode and Pi |

---

## D. Related tooling

| Repo | ★ | What it does |
|---|---|---|
| [yuhp/opencode-models-discovery](https://github.com/yuhp/opencode-models-discovery) | 211 | Dynamic model discovery plugin (OpenAI-compatible) |
| [vava-nessa/free-coding-models](https://github.com/vava-nessa/free-coding-models) | 2889 | Find/benchmark 170+ free coding models across 15+ providers |
| [cheaper-inference/OmniRoute](https://github.com/cheaper-inference/OmniRoute) | 86348 | General AI gateway (375 providers) — not OpenCode-specific |
| [lidge-jun/opencodex](https://github.com/lidge-jun/opencodex) | 18372 | Codex/Claude Code proxy — not OpenCode Zen |
| [opencode-ai/opencode](https://github.com/opencode-ai/opencode) | 13885 | The official OpenCode repo |

---

## Notes

- **The two big ones** are `jasonxu114514/opencode2api` (1.4k★, Go) and
  `azrinaldi/opencode-free-bridge` (106★, JS) — the latter is the one PR #6 targets.
- **The quota research** lives in `ebouther/opencode-unlimited-proxy` (per `/64`/`/32`,
  daily reset) and `alztrk/opencode-ip-rotator` (WARP rotation).
- **The gate research** lives in `Magiszonekk/opencode-proxy` (Bun TLS + 4 gates) and the
  `9router #4101` / `OmniRoute #16571` bisections.
- Many repos are Chinese-language (zen-gate, oc2api, dsh-opencode-zen, OpenCode-Zen-free-api).
- Several "unlimited" repos are straightforward gateway rewrites; a few (ElectronBreach) carry
  prompt-injection payloads — read before running.
