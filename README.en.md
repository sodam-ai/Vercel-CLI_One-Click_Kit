# Vercel CLI One-Click Kit

> A **Korean-first helper** that lets total beginners install Vercel and publish a
> website with **one double-click** — no scary command line required.

- **Vercel**: a service that hosts (deploys) your website/app on the internet for free.
- **This kit**: lets you do that through a friendly **Korean menu** instead of a black command window.
- Installs with **no admin (UAC) popup** — the Node.js auto-install is admin-free too.

> 🇰🇷 Korean: **[README.md](README.md)** · Step-by-step: **[GUIDE.en.md](GUIDE.en.md)**

---

## ⚡ Quick start (3 steps)

| Step | Do this |
|---|---|
| **1** | Double-click **`시작하기.bat`** ("Start Here") in this folder |
| **2** | Press the number shown next to **">> 지금 할 일"** ("Do this now") — usually `[1] Install` → `[2] Use → Login` → `Deploy` |
| **3** | Done. The screen always tells you the next number to press |

> Use ↑/↓ + Enter, or just press a number key.

---

## 📋 Prerequisites / required programs

| Item | Required? | Notes |
|---|---|---|
| **Windows 10 / 11** | Required | Windows only. |
| **Internet** | Required | For install, login, deploy. |
| **Node.js 18+** | Auto | If missing, the kit installs a **portable (admin-free)** copy (or guides you to nodejs.org). |
| **Vercel CLI** | Auto | `[1] Install` sets it up automatically. |
| **Web browser** | For login | Vercel login happens in your browser. |
| **Vercel account** | For login | Create one free in the browser (GitHub/email). |
| **Admin rights** | ❌ Not needed | No UAC popup. |

---

## 📥 Download / install

1. **Get the kit**: if you received a zip, **extract it** into one folder.
2. **Unblock**: Windows may block files from the internet → `시작하기.bat` **auto-unblocks** them. (If not: right-click file → Properties → check **Unblock** → OK)
3. **Install**: double-click `시작하기.bat` → **`[1] Install`**.
   - If Node.js is missing → **`Y` (portable, admin-free)** or the nodejs.org guide. Then **close the window and run it again**.
   - A black English install window is normal. **Don't close it** (3–10 min).

> 💡 Blue SmartScreen warning → **More info → Run anyway** (normal for new files).

---

## 🖥️ How to run / first screen

Opening `시작하기.bat` shows your computer status at the top:

```
[Your computer status]
 - Node.js (required)   : OK / missing
 - Vercel CLI           : OK / needs install
 - Vercel login         : OK / login needed

 >> Do this now: press [1] Install.
```

- Green [OK] = ready / Yellow [needed] = press the number the screen suggests.

---

## 🧭 Workflow (full flow)

```
시작하기.bat
   → [1] Install            (once: Node.js + Vercel CLI)
   → [2] Use → Login         (once: log in via browser)
   → [2] Use → (Link)        (optional: link this folder to Vercel)
   → [2] Use → Deploy → Preview (safe, temporary URL)
   → when confirmed → Production (type YES)
```

> Stuck? Use **`[6] Diagnose / Fix`** anytime.

---

## 📂 How to use — Start menu (Korean UI)

| # | Name | What it does |
|---|---|---|
| 1 | **Install** | Installs Vercel CLI (auto-guides Node.js). **If already installed, it just finishes.** |
| 2 | **Use** | Login · Link · **Deploy** · **Advanced** (domains/env/logs/promote) |
| 3 | **Remove** | Cleanly uninstalls (your own code/files are kept) |
| 4 | **Guide** | Opens the beginner guide |
| 5 | **Dashboard** | Opens the Vercel web dashboard |
| 6 | **Diagnose / Fix** | Re-check status + fix errors + verify login |
| 0 | Exit | Closes the window |

---

## 🧰 Full features — RUN.bat menu

`RUN.bat` gathers every feature in one place. Simple front, full detail inside:

- **Most used**: `1` Preview deploy · `2` Production deploy · `3` Login · `4` Who am I
- **By group**: `5` Account/Team · `6` Project/Deploys · `7` Env vars · `8` Domains · `9` Advanced · `10` Tools
- `11` **Update** (latest Vercel) · `0` Exit

---

## ⌨️ Command table (menu ↔ real Vercel command)

Pressing a menu item runs the real command for you (no typing needed).

| Action | Real command |
|---|---|
| Preview deploy | `vercel` |
| Production deploy | `vercel --prod` |
| Run locally | `vercel dev` |
| Redeploy | `vercel redeploy` |
| Login / Logout | `vercel login` / `vercel logout` |
| Who am I | `vercel whoami` |
| Teams / Switch | `vercel teams ls` / `vercel switch` |
| Link folder | `vercel link` |
| List / Inspect / Logs | `vercel ls` / `vercel inspect <URL>` / `vercel logs <URL>` |
| Open in browser | `vercel open` |
| Env list/add/remove/pull | `vercel env ls` / `add` / `rm` / `pull` |
| Domains list/add/remove | `vercel domains ls` / `add <domain>` / `rm <domain>` |
| DNS / Alias | `vercel dns ls <domain>` / `vercel alias <URL> <domain>` |
| Promote / Rollback | `vercel promote <URL>` / `vercel rollback <URL>` |
| Remove deploy / Pull settings | `vercel remove <URL>` / `vercel pull` |
| Init / Help / Version | `vercel init` / `vercel help` / `vercel --version` |
| Update | `npm install -g vercel@latest` |

---

## 🌐 Preview vs Production (important)

| Type | Meaning | Safety |
|---|---|---|
| **Preview** | Temporary URL, only you check it | 🟢 **Safe (recommended)** — live site untouched |
| **Production** | Visitors see it immediately | 🔴 Caution — requires typing **`YES`** (case-insensitive) |

> Nothing goes live until you type `YES`.

---

## 🔄 Update (once in a while)

To get the latest Vercel (no admin popup):
- **RUN.bat** → `11` Update  (or `[10] Tools → 2`)
- or **시작하기.bat** → `[2] Use → [5] Advanced → U`

> Usually optional — only when errors keep happening or you need new features.

---

## 🗑️ How to remove

- `시작하기.bat` → **`[3] Remove`** (or double-click `UNINSTALL.bat`)
- Requires typing **`YES`** (case-insensitive). **Your own code/files are kept.**
- Removes: Vercel CLI (global npm package) + config folder (`%USERPROFILE%\.vercel`).

---

## 🗂️ File / document locations

```
Vercel-CLI_One-Click_Kit/
├─ 시작하기.bat        ← start here (Korean UI)
├─ lib/start.ps1       ← Korean screen (internal, auto-run)
├─ INSTALL.bat         ← install engine (bilingual)
├─ RUN.bat             ← full menu (grouped, all features)
├─ UNINSTALL.bat       ← uninstall engine (bilingual)
├─ README.md / README.en.md
├─ 왕초보가이드.md / GUIDE.en.md
├─ README.pdf / README.en.pdf / 왕초보가이드.pdf / GUIDE.en.pdf
├─ LICENSE / NOTICE
└─ .gitattributes / .gitignore
```

**Install locations (for reference):**
- Vercel CLI → `%APPDATA%\npm` (user folder, no admin)
- Auto Node.js (portable) → `%LOCALAPPDATA%\Programs\node-portable`
- Login token → `%APPDATA%\com.vercel.cli\Data\auth.json`

---

## ❓ Troubleshooting

| Symptom | Fix |
|---|---|
| "Node.js not installed" | `[1] Install` → **auto (Y)**, or get **LTS** from [nodejs.org](https://nodejs.org/) |
| Blue SmartScreen warning | **More info → Run anyway** |
| Files seem blocked | `시작하기.bat` auto-unblocks; else right-click → Properties → **Unblock** |
| Install keeps failing | **Pause antivirus** (below), retry / check Wi-Fi |
| `vercel` not found | Close the window and **run `시작하기.bat` again** |
| Scary English error | A **Korean explanation + next step** now appears right below it — just follow it |
| Login shows "not confirmed" | `[6]` → **`[4]` Verify login** for the real status |
| Arrows don't work | Use **number key + Enter** |
| The black window looks scary | It just means work is in progress — don't close it |

**💉 If antivirus blocks the install (pause briefly):**
1. Start → **Windows Security**
2. **Virus & threat protection** → **Manage settings**
3. Turn **Real-time protection** off briefly → retry `[1] Install`
4. **Turn it back on** when done (important!)

---

## 🔒 Safety / privacy

- Runs **without admin rights**; does not touch system folders.
- The login token is stored by Vercel's official CLI in **your user folder** (the kit does not collect or transmit it).
- The kit **sends no data anywhere** of its own (Vercel commands talk only to Vercel servers).
- Irreversible actions (production deploy, uninstall) require a **`YES`** confirmation.

---

## 📄 License / copyright / commercial use (please read)

**This kit**
- License: **Apache License 2.0**
- Copyright: **Copyright 2026 SoDam AI Studio**
- Commercial use: **allowed**, but you **must** follow Apache-2.0 terms (include the license copy and **`NOTICE`**, state changes, keep copyright/trademark notices). Full text: **[LICENSE](LICENSE)**.

**Third-party tools this kit installs/uses (each separately licensed)**
- **Vercel CLI (`vercel`)** — Copyright Vercel, Inc. / Apache-2.0 / <https://github.com/vercel/vercel>
- **Node.js** — a **trademark (®)** of the OpenJS Foundation; the software is **MIT-licensed** / <https://nodejs.org/>

**Important notices (strict)**
- This kit is an **independent helper**; it is **NOT affiliated with, endorsed by, or sponsored by Vercel, Inc. or the OpenJS Foundation.**
- **"Vercel" is a trademark of Vercel, Inc.** Do not use the trademark as if it were your own product.
- The kit installs the official `vercel` CLI **as-is** from the public npm registry.
- **Your use of Vercel itself is governed by [Vercel's Terms & pricing](https://vercel.com/legal/terms).**
- This kit is provided **"AS IS" without warranty**; you are responsible for your use (Apache-2.0 §7–8).
