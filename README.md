# Imagination Studio by keys+Wasserman: MiaAI-Lab fork

The documentation is the author's own README upstream:
**[drowzeys/Imagination-Studio-by-keys-Wasserman: README](https://github.com/drowzeys/Imagination-Studio-by-keys-Wasserman/blob/main/README.md)**

## What only this fork has

This fork's `main` is upstream `main` with the following merged in. The full list, with its commits, is in
[MIA-CHANGELOG.md](MIA-CHANGELOG.md).

- **A new look for the whole page, the Console look.** Graphite in the dark, off-white in the light, true black
  for OLED, and one accent (amber or cobalt) for the main action. Glows, textures, serif titles and cover pictures
  are gone. Rebuilt screens:
  - **Home:** one box to start, recent takes, and what is rendering.
  - **Video › Create:** one page instead of five steps, with a *This clip* panel and Render.
  - **Library:** a grid with the selected take in a side panel.
  - **Sound › Voice:** the script as lines, one speaker each.
- **Themes:** Light, Dark, Dark (OLED) and Match the computer, as picture cards in Settings › Appearance, with a
  sun/moon switch in the top bar.
- **Text size for the whole studio, sidebar included:** Small, Default, Large and Largest.
- **Quick Edit:** paste a picture, say what changes, press the arrow.
- **No sound for a video:** the clip's track is muted after the render.
- **Getting in without the access key from your own networks, opt-in:** `STUDIO_TRUST_TAILNET=1` for your
  tailnet, and `STUDIO_TRUST_NETWORKS` for your own private networks. Both are off by default.
- **`deploy.sh`:** restarts the Studio's service, and refuses while a job is queued or running.
