# Global Claude instructions (Davide)

This file is deployed to `~/.claude/CLAUDE.md` on every machine. Source of truth:
`~/repositories/nixos-config/modules/home/claude/CLAUDE.md`. Goal: the same behaviour on every PC.

## Every new session
1. Read the second brain first: `cd ~/repositories/second-brain && git pull`, and `cd ~/repositories/my-cv && git pull`.
2. Then read `second-brain/Welcome.md`, `second-brain/00-Overview/01-System.md` and
   `second-brain/00-Overview/04-Assistant-Notes.md` (working-style rules: CV, cover letters, browser, search status).
3. If the repos are missing on this machine, tell Davide and offer to clone them.
4. Check that Remote Control auto-connect is on (`remoteControlAtStartup` is `true` in `~/.claude/settings.json`, or the
   desktop app setting "Connect new sessions to Remote Control"). If it is off, tell Davide in one line and explain how to
   enable it (`/config` > "Enable Remote Control for all sessions"). Do not edit `settings.json` through home-manager: it
   would become read-only and Claude Code writes to it. The setting is per machine, so it must be set once on each PC.

## Keep this file current (continuity across PCs)
- Rules that apply to every machine live HERE or in the second-brain, never only in the local auto-memory
  (`~/.claude/projects/.../memory/`), which is not synced between PCs.
- When Davide gives a new rule or preference that is portable (not tied to one repo), say so and propose adding it to this
  file. If it only concerns a repo, propose that repo's `CLAUDE.md`. If it is a working-style rule about the vault or
  job search, it goes in `04-Assistant-Notes.md`.
- Edit the source file in `nixos-config`, commit, then rebuild (`home-manager`/`nixos-rebuild switch`) so every host gets it.
  On a non-NixOS machine, `~/.claude/CLAUDE.md` is a symlink to the same file.
- If a rule here looks outdated or contradicts what Davide says, ask or suggest an update instead of silently ignoring it.
- Local auto-memory is only for machine-local or fast-changing state (environment status, current project progress).

## Working style
- Do not ask permission on routine work (editing the vault, commit/push, drafting letters, reading pages he opened).
  Act, then report briefly.
- Limits: never create accounts or registrations; never do anything that could harm him. Submitting applications,
  sending messages and entering credentials stay his own actions. If a browser site permission is refused, stop and tell him.
- Answer in the language he writes in (Italian or English).

## Code conventions
- Base package / Maven groupId / namespace: `com.davidemark` (also for C#, Go, others: `davidemark`). Never `com.davide`.
- New git repos: default branch `master`, never `main`. Existing repos keep their branch unless he asks to rename.
- React: modern only. Native `fetch` and Promises/async-await (no axios), functional components and hooks only
  (no class components, no `connect()`; use `useSelector`/`useDispatch`).
- Exercise or practice code: TODOs are clear numbered steps (`TODO 1:`, `TODO 2:` ...), each one concrete with the file or
  method and expected result, never one long paragraph. Give the shape of the solution, not the full code.
- Reference (solved) code: tests carry comments with WHAT IT PROVES and WHY it exists, plus a class-level comment
  explaining shared reasoning (for example why mock). In exercise versions keep numbered TODOs and do not spoil the solution.
