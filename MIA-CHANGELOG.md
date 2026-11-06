# MIA-CHANGELOG

What this fork ([MiaAI-Lab/Imagination-Studio-by-keys-Wasserman](https://github.com/MiaAI-Lab/Imagination-Studio-by-keys-Wasserman))
has that upstream ([drowzeys/Imagination-Studio-by-keys-Wasserman](https://github.com/drowzeys/Imagination-Studio-by-keys-Wasserman))
does not.

- **Compared against:** upstream `main` at `d08cc93` (Merge pull request #207, Windows native features), 2026-11-05.
- **Where it lives:** this fork's `main`, which is upstream `main` up to `d08cc93` with the work below merged in
  (merge commit `64df388`). The same work, before upstream's newer commits were merged in, is on branch
  `feat/console-ui`.
- **How it was checked:** `git cherry` of every fork branch against upstream `main`, then a look at each remaining
  commit's files, since upstream squashes some merges. Only what upstream really lacks is listed.

Keep this file in step: add a line when something lands here first, and move it to *Landed upstream* when upstream
merges it.

---

## Only in this fork

### 1. The Console look: a complete redesign of the page

A calm tool in place of the glowing one: graphite in the dark, off-white in the light, true black for OLED. One accent,
amber or cobalt, marks the main action, what is selected and progress. Removed: glows and pulsing pills, the grid
texture, serif display titles, capitalised mono labels, the cover picture on every room, time-of-day slogans.

- **Themes.** Dark, **Light**, Dark (OLED) and **Match the computer**. They are set before the first paint (no flash),
  and a sun/moon button in the top bar switches between light and dark. Settings › Appearance shows them as cards,
  each with a small picture of the studio, and the accent as swatches. `app/settings.py` takes
  `studio | light | oled | system`.
- **Sidebar and top bar.** A compact mark and name, search under it, plain room groups, and the machine card
  (no version line or "Powered by" line under it: Updates is in Machine, the credit in Settings › Credits). The room's own tabs sit in the top bar with an accent underline.
- **Home.** "What are we making?" leads the page:
  - the kinds of take as tabs over the box, then one bar with recipe, length, estimate and Generate
  - quick starts, and a grid of recent takes
  - a right-hand column with what is rendering, what is next and the machine
- **Video › Create on one page** instead of the five-step wizard:
  - the page itself: the shot, its first frame or references, lines and sound, then *Engine, size and length* and
    *Review the full prompt* (both folded), then Render
  - **This clip** beside it: recipes, length, the take at a glance, the estimate and Render
  - Render rebuilds the prompt from the fields unless it was edited by hand (`createQueue` in `shell.js`)
  - Render stays greyed out, with the reason, until there is something to render; this follows typing
- **Library.** A toolbar (kind with counts, find, search what is in the clips), the grid, and the selected take in a
  side panel:
  - preview, what made it, the next actions, *More actions*, Download, Copy path, Delete
  - *Select* turns on the tick boxes for a bulk delete or Finish
  - clip thumbnails show a frame from half a second in
- **Sound › Voice.** The script is edited as lines, each with its speaker, and written back as Drama 3's own
  `<|speaker:N|>` text (a Text view stays for typing it directly). Beside it:
  - Cast, with names for you; the model still hears the speaker number
  - Clone a voice, with the consent box kept
  - Sampling, folded
  - the takes as compact cards with the word-check count
  - "Built with Fish Audio" stays
- **Text size** (Settings › Appearance) scales the **whole** studio (sidebar, rooms and queue), not the work area
  alone:
  - Small 1×, Default 1.1×, Large 1.2×, Largest 1.35×
  - a phone keeps 1× by default
  - heights taken from the window are corrected for the scale (`--vh`)
  - `app/settings.py` takes `compact` for Small
- **Quick Edit** at the same sizes as the other rooms.

Files: `app/static/studio.css`, `index.html`, `shell.js`, `home.js`, `settings.js`, `voice.js`, `nodes.css`;
`app/settings.py`.
Tests: `tests/test_shell_page.py` (themes, the top-bar switch, the theme cards, one-page Render, the Voice line
editor, Text size) and `tests/test_settings.py` (the theme and text-size values).

### 2. Quick Edit: a one-box picture edit

Image › Quick Edit (`app/static/quick.js`). Paste a picture, say what changes, press the arrow. It is the same `edit`
job as Create › Edit a picture, with nothing to set but the model. Each turn draws a new seed and keeps the picture's
size. Test: `tests/test_quick_page.py`.

### 3. No sound for a video

Create › Lines and sound › *No sound: deliver the clip silent*. MiniMax H3 always makes sound and asking it for
silence is not enough, so the app mutes the clip's track after the render (`hush`). It also works for a long video's
joined file.

### 4. Opt-in access without the key, for the owner's own networks

Both are off by default, and nothing of them runs unless set:

- **`STUDIO_TRUST_TAILNET=1`** lets in:
  - a device on a Tailscale address
  - this computer's own one-word name over loopback
  A proxied request (`tailscale serve`, `funnel`) is still asked for the key.
- **`STUDIO_TRUST_NETWORKS`** adds the owner's own private networks, for example `192.168.1.0/24`. A public range is
  never taken.

Code: `app/access.py` (`tailnet`, `trusted_networks`) and `app/server.py`. Also documented in the README and
`AGENTS.md`. Tests: `tests/test_access.py`.

### 5. A README of its own

This fork's `README.md` has only a link to the author's README upstream and a short list of what is unique here.
Upstream's README is not copied. `tests/test_tutorial_lessons.py` checks the Character Swap times against
`TUTORIAL.md` alone, since the README no longer carries them.

### 6. `deploy.sh`

Restarts the Studio's systemd user service and waits until the app answers again. It refuses while a job is queued or
running unless given `--force`.

### 7. The simple studio and fewer steps to a picture or clip

- **The simple studio.** A new studio opens with Home, Video, Image and Library only. One switch shows every room;
  `app/settings.py` `layout.simple`.
- **Another take is another take.** The seed is drawn per take; Home's Retake re-sends its own request.
- **Next actions under every result.** Animate, Edit (Quick Edit), More like these, Edit this frame, Higher quality,
  Extend / Restyle / Fix / Upscale.
- **Scouts.** Animate this and Use as end on each scout.
- **Create's first frame.** Change something in it (with Undo); Crop it to fit (POST `/api/fit`).
- **Smaller changes.** Reference Insert chips, recipes named Draft / Final with their sizes, and the 20-pass and
  picture-model hints.

Plan and status: `docs/opus.md`. Tests: `tests/test_shell_page.py`, `test_quick_page.py`, `test_settings.py`,
`test_lastframe.py`.

### Commits

| Commit | What |
|---|---|
| `3ff1abb` | Quick Edit tab, No sound, opt-in trusted tailnet and home networks, `deploy.sh` |
| `a3f5dd7` | The Console look: Light, Dark, OLED and Match the computer, and the screens rebuilt |
| `3486268` | Text size scales the whole studio, with Small; Quick Edit at the rooms' sizes |
| `7221a8d` | Text size a step larger: Small is the old Default, Largest past the old Largest |
| `ee2c327` | This file |
| `64df388` | Merge onto upstream `main` (`d08cc93`), keeping upstream's Windows work (see below) |

When merged onto upstream `main`, three files overlapped with upstream's Windows work (#198 to #207). Both sides were
kept:
- **Home:** the new composer, with Windows' per-platform gating on the kind tabs and Generate, and SD-Turbo as the
  picture model's name there.
- **Library:** the new side panel, with the same gating on its actions (*Extract last frame* on Windows).
- **The room table:** Windows' "not on this platform" gate, with Quick Edit kept (gated as an edit).
- **Tests:** `tests/test_shell_page.py` keeps both sides' stand-ins, and one upstream Windows test finds the kind tabs
  by name instead of by position.

### Other fork branches upstream does not have

- **`v2.7-multi-spark`** (2026-10-13): *Render nodes*, where a queued job runs on another machine's studio and the
  queue is kept across a restart, plus a script that makes another Spark a node. Never merged. Upstream later took a
  different route to several Sparks (`app/sparks.py`, `docs/multi-spark.md`), so it is kept for reference only.

---

## Landed upstream

Fork branches whose work upstream has merged (sometimes squashed, so their commits still differ by hash):
`feat/appearance-themes` (#197), `port/168-local-gpu-workers` (#177), `fix/168-head-gpu` (local NVIDIA GPU
workers, in #177), `feat/home-flux-yue` (#196), and the earlier PR branches.

## Keeping up with upstream

This `main` holds everything upstream `main` had at `d08cc93`, including the Windows and RTX Spark N1X work (#198 to
#207). When upstream moves on, merge its `main` in here and update the commit at the top of this file.
