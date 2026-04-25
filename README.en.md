# Vercel CLI - One-Click Kit (Windows)

> A collection of batch files that lets you install Vercel CLI and use 31 features through a simple menu — all with a double-click on Windows.

[한국어 README](./README.md)

---

## Overview

Vercel CLI is a command-line tool that can be intimidating for non-developers.  
This kit wraps it in a **double-click experience** — install, run, and uninstall with no terminal knowledge required.

---

## Requirements

| Item | Version | Notes |
|------|---------|-------|
| Windows | 10 / 11 | Other OS not supported |
| Node.js | 18 or newer | Free download at [nodejs.org](https://nodejs.org) |
| Internet | — | Required during installation |

> If Node.js is missing, INSTALL.bat will display a clear error message with a download link.

---

## Folder Structure

```
Vercel-CLI/
├── INSTALL.bat                  ← Install Vercel CLI
├── RUN.bat                      ← Run Vercel CLI (full menu)
├── UNINSTALL.bat                ← Remove Vercel CLI
├── Vercel-CLI_One-Click_Kit.7z  ← Compressed archive for distribution
├── .gitignore
├── LICENSE
├── README.md                    ← Korean documentation
└── README.en.md                 ← This file (English)
```

---

## How to Use

### Step 1 — Install

Double-click `INSTALL.bat`.

- Checks Node.js version automatically
- Configures npm global path
- Runs `npm install -g vercel`
- Offers update/reinstall if already installed

### Step 2 — Run

Double-click `RUN.bat`.

A numbered menu opens. Type a number and press Enter to use that feature.

```
============================================================
  Vercel CLI - Easy Menu
============================================================

  --- Deploy and Run ---
   1. Deploy (Preview)
   2. Deploy (Production)
   3. Dev Server (run locally)
   4. Redeploy last build

  --- Account ---
   5. Login
   6. Logout
   7. Who Am I
   8. Teams
   9. Switch Team

  --- Project Info ---
  10. Link Project
  11. List Deployments
  12. Inspect a Deploy
  13. View Logs
  14. Open in Browser

  --- Environment Variables ---
  15. List Env Variables
  16. Add Env Variable
  17. Remove Env Variable
  18. Pull Env to .env file

  --- Domains ---
  19. List Domains
  20. Add Domain
  21. Remove Domain

  --- Advanced ---
  22. Promote Deploy
  23. Rollback Deploy
  24. Remove Deploy
  25. Pull Project Settings
  26. Init New Project
  27. Alias (custom URL)
  28. DNS Records

  --- Tools ---
  29. Version Check
  30. Update Vercel CLI
  31. Help

   0. Exit
============================================================
```

### Step 3 — Uninstall (if needed)

Double-click `UNINSTALL.bat`.

- Removes the Vercel CLI npm package
- Optionally deletes `~/.vercel` (global config)
- Optionally deletes local `.vercel` folder

---

## Beginner's Guide

No coding experience needed. Just follow these steps:

**What is Vercel?**  
Vercel is a free service that publishes your website or app to the internet so anyone can visit it.

**First-time setup:**

1. Download [Node.js](https://nodejs.org) → click the **LTS** button → install it
2. Double-click `INSTALL.bat` → follow the on-screen instructions
3. Double-click `RUN.bat` → type `5` → press Enter → log in to your Vercel account
4. To deploy: open `RUN.bat` in your project folder → type `2` → press Enter

**Common issues:**

- **"Administrator privileges required" error?**  
  → Right-click the bat file → select "Run as administrator"

- **`vercel` not recognized after install?**  
  → Close all terminals and open a new one. If still failing, restart your computer.

- **Which folder should I run this from?**  
  → Copy the bat files into your project folder, or drag-and-drop your project folder into the terminal after launching RUN.bat.

---

## Important Notes

- `.env` files downloaded via `vercel env pull` may contain API keys. **Never commit them to GitHub.** (Already excluded in `.gitignore`)
- The `.vercel/` folder contains project link info. **Do not share it.** (Already excluded in `.gitignore`)
- Vercel free plan has deployment limits. [Check pricing](https://vercel.com/pricing)

---

## License

[MIT License](./LICENSE) — Copyright (c) 2026 SoDam AI Studio
