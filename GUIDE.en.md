# Beginner Guide — Vercel CLI One-Click Kit

New to computers or the command line? That's fine. Follow the steps in order.
The only thing to remember: **double-click `시작하기.bat`**.

> For full details / command table / license, see **[README.en.md](README.en.md)**.
> 🇰🇷 Korean step-by-step: **[왕초보가이드.md](왕초보가이드.md)**

---

## Step 0. What this kit does

It lets you use **Vercel** (which puts your website on the internet) through a simple
**Korean menu** instead of a black command window. **No admin (UAC) popup appears.**

**You need beforehand:** Windows 10/11 · internet. (Node.js is installed automatically if missing.)

---

## Step 1. Start

1. Double-click **`시작하기.bat`** in this folder.
2. If a blue SmartScreen warning appears → **More info → Run anyway** (normal for new files).
3. The Korean guide window opens.

> Use **↑ ↓ + Enter**, or press a **number key**. Read only the top line **">> 지금 할 일"** — it shows the next number to press.

---

## Step 2. Install (once)

1. Choose **[1] Install**.
2. If **Node.js** is missing:
   - Press **Y** to auto-install — a **portable Node.js with NO admin popup** (recommended), or
   - Get the **green LTS button** at [nodejs.org](https://nodejs.org/), install it,
     then **close the window and run `시작하기.bat` again** (a new window is required).
3. If Node.js is present, a black install window runs and **finishes automatically** (3–10 min — don't close it).
   - **If already installed**, it just finishes (updating is separate — see Steps 4 & 5).

> 💡 **No admin (UAC) popup appears** — both the kit and the auto Node install (portable) go into your user folder only.

---

## Step 3. Login (once)

1. **[2] Use → [1] Login**.
2. Your browser opens — sign in / authorize there.
3. It returns to the window automatically; a Korean "success + next step" note appears.

> No account? Create one free in the browser (GitHub/email).
> If login shows "not confirmed" → **[6] Diagnose → [4] Verify login**.

---

## Step 4. Deploy to the internet

1. You need a **folder that contains your website files** (e.g. an `index.html`).
2. **[2] Use → [4] Deploy**.
3. A **"Is this the right folder?"** check appears → `Y` if correct, or `N` then paste another path.
4. Pick one:
   - 🟢 **Preview (recommended)** — temporary URL, live site untouched.
   - 🔴 **Production** — visitors see it; requires typing **`YES`** (case-insensitive).
5. A **URL** appears — that's your site!

First deploy asks a few questions in English. **Pressing Enter (defaults) is usually fine:**

| Question | Answer |
|---|---|
| Set up and deploy? | **Y** + Enter |
| Which scope? | just **Enter** |
| Link to existing project? | **N** + Enter (first time) |
| Project name? | just **Enter** |
| In which directory? | just **Enter** |

> When it finishes, a **Korean "success + next step"** note appears right below.
> 🔧 Domains, env vars, logs, rollback (Advanced) live in **[2] Use → [5] Advanced**.

---

## Step 5. Update (occasional)

To get the latest Vercel (no admin popup):
- **RUN.bat** → `11` Update  (or `[10] Tools → 2`)
- or **시작하기.bat** → `[2] Use → [5] Advanced → U`

> Usually optional — only when errors keep happening or you need new features.

---

## Step 6. Remove (uninstall)

1. **[3] Remove** (or `UNINSTALL.bat`).
2. Confirm by typing **`YES`** (case-insensitive).
3. **Your own code/files are kept** — only the Vercel tool is removed.

---

## Troubleshooting

> 💡 **Fastest path:** On the start screen, press **[6] Diagnose / Fix**. It shows your
> current status (install/login/internet) and pinpoints what to do next.

| Problem | Fix |
|---|---|
| "Node.js not installed" | [1] Install → auto (Y), or get LTS from nodejs.org |
| Blue SmartScreen warning | More info → Run anyway |
| Install keeps failing | **Pause antivirus** (below), retry / check Wi-Fi |
| `vercel` not found | Close window, run `시작하기.bat` again |
| Scary English error | A **Korean explanation + next step** now appears right below it |
| Login shows "not confirmed" | [6] → **[4] Verify login** |
| Arrows don't work | Just use **number key + Enter** |
| The black window looks scary | It just means work is in progress — don't close it |

**💉 If antivirus blocks the install:**
Start → **Windows Security** → **Virus & threat protection** → **Manage settings** → turn
**Real-time protection** off briefly → retry `[1] Install` → **turn it back on** when done.

---

## Where are the files?

- **Always start with** `시작하기.bat` (this folder).
- Docs: `README.md`(KO)·`README.en.md`(EN)·`왕초보가이드.md`(KO)·`GUIDE.en.md`(EN) + PDFs.
- Vercel installs to `%APPDATA%\npm`; portable Node to `%LOCALAPPDATA%\Programs\node-portable`.

---

## One-page summary

```
Double-click 시작하기.bat
   → [1] Install   (once)
   → [2] Use → Login   (once)
   → [2] Use → Deploy → Preview (safe)
   → (when confirmed) Production = type YES
   stuck? → [6] Diagnose / Fix
```

Stuck? Read only the top line **">> 지금 할 일"** — it always shows the next number to press.

---

## 📄 License (summary)

- This kit: **Apache-2.0** © 2026 SoDam AI Studio (commercial use allowed; keep `NOTICE` etc.).
- Vercel CLI: Apache-2.0 © Vercel Inc. / Node.js: OpenJS Foundation trademark (MIT).
- This kit is **NOT affiliated with or endorsed by Vercel**; using Vercel follows **Vercel's Terms & pricing**.
- See the License section in **[README.en.md](README.en.md)** and **[LICENSE](LICENSE)·[NOTICE](NOTICE)**.
