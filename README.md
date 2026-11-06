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
- **The simple studio.** A new studio opens with only Home, Video, Image and Library in the sidebar (plus Machine
  and Settings). Every other room stays one search away (⌘K), and one switch under the rooms, *All tools*, brings
  them all back. Video and Image open straight onto Create. A studio set up before keeps every room, and Home offers
  the simple one.
- **Fewer steps from one result to the next.** Each result offers the next thing to do with it:
  - **Under a picture:** *Animate*, *Edit* (Quick Edit) and *More like these*.
  - **Under a clip:** *Edit this frame* (a still of the frame you are on, in Quick Edit), *Higher quality* (the same
    take again at the Final recipe and seed), *Extend*, *Restyle*, *Fix* and *Upscale*.
  - **On each picture scout:** *Animate this* queues the clip on it; *Use as end* makes it the last frame.
- **Another take is another take.** *Another take* queues at once with the next seed, and *Same seed every take* is
  a tick box. Home's *Retake* re-sends the exact settings that made the take.
- **A first frame you can change in place.** Create's *Change something in it* edits the first frame with one
  sentence, with *Use this version* and *Undo*. A picture of another shape than the clip is said so, with
  *Crop it to fit* in one click instead of a stretched clip.
- **Less to read and set.** Recipes named *Draft* and *Final* with their real sizes; seed and the other render
  options folded away; an *Insert* chip puts `<Picture 1>` where the cursor is. Two hints, applied only with a click:
  *Use 20 passes* when a shot has several actions, and the better picture model for faces, posters, crowds,
  illustration and hands.
- **Quick Edit:** paste a picture, say what changes, press the arrow. *More tools* carries the picture, the words
  and the model into the full editor.
- **No sound for a video:** the clip's track is muted after the render.
- **Getting in without the access key from your own networks, opt-in:** `STUDIO_TRUST_TAILNET=1` for your
  tailnet, and `STUDIO_TRUST_NETWORKS` for your own private networks. Both are off by default.
- **`deploy.sh`:** restarts the Studio's service, and refuses while a job is queued or running.
