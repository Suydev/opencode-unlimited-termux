import fs from 'node:fs'
const proxy = process.argv[2] || ''
const maxTokens = Number(process.argv[3] || 32000)
const model = process.argv[4] || 'glm-5.3-flash-free'
const base = JSON.parse(fs.readFileSync('/data/data/com.termux/files/home/opencode-re/replay-body.json', 'utf8'))
base.max_completion_tokens = maxTokens
base.model = model
const BODY = JSON.stringify(base)
const sleep = (ms) => new Promise((r) => setTimeout(r, ms))
let ok = 0
let tokens = 0
for (let i = 0; i < 600; i++) {
  const s = 'ses_' + 'e4006d5c9ff0' + 'aZ9xKp2Qr7Tn4L'
  try {
    const res = await fetch('https://opencode.ai/inference/openai/v1/chat/completions', {
      method: 'POST',
      proxy: proxy ? `http://${proxy}` : undefined,
      tls: { rejectUnauthorized: false },
      headers: {
        authorization: 'Bearer public',
        'content-type': 'application/json',
        'user-agent': 'opencode/latest/2.2.6/cli',
        'x-opencode-session': s,
        'x-opencode-session-id': s,
        'x-opencode-client': 'cli',
        'x-opencode-project': 'global',
      },
      body: BODY,
    })
    const t = await res.text()
    if (res.status === 200 && t.includes('chat.completion.chunk')) {
      ok++
      const m = t.match(/"usage":\{"prompt_tokens":(\d+),"completion_tokens":(\d+)/)
      if (m) tokens += Number(m[1]) + Number(m[2])
    } else {
      console.log(`#${i + 1}: ${res.status} after ok=${ok} tokens=${tokens} retry-after=${res.headers.get('retry-after')}`)
      break
    }
  } catch (e) {
    console.log(`#${i + 1}: ERR ${e.message}`)
    break
  }
  await sleep(200)
}
console.log(`RESULT: ok=${ok} tokens=${tokens} maxTokens=${maxTokens} proxy=${proxy}`)
