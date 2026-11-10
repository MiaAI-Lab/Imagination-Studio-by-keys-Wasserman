# Studio + TensorFold version landscape (verified 2026-11-10)

Deployed: **Studio 4.3.1** (deploy-20261107T185210Z; source tarball, no .git) — hash-identical on Mac and spark-faea.
Latest upstream release: **v4.4.1** (drowzeys, 2026-11-08, "the 4.3.1 screens are back" — keeps all Sparks fixes).
The fork (MiaAI-Lab) tracks upstream; its main is at 4.4.1-era content (e3ad8538, 2026-11-06) + tag v4.4.1 exists.

## What 4.4.x changes that matters here (diff v4.3.1 → v4.4.1)

- `spark/memory_guard.py`: adds `STUDIO_MEMORY_GUARD=warn` — a job the estimate refuses becomes a WARNING and is
  tried anyway (fits_or_exit, spark_generate.py:234). **4.3.1 has no such hatch.** The int8 estimate line is
  UNCHANGED (54_500 MB + 215/1k rows), so warn-mode does not make the job fit — it just tries.
- Native Windows, SPARK_PROGRESS_FILE, two-GPU, "Sparks fixes", ComfyUI + TensorFold 1.2.2 engines bundled.

## Upgrade path (when approved)

The deployed copy is a tarball (no .git). The app's own updater: `git pull && bash oneshot-setup.sh --upgrade`
(TUTORIAL.md) — for a tarball deploy, re-clone from `MiaAI-Lab/Imagination-Studio-by-keys-Wasserman` at tag
`v4.4.1` into a NEW source dir, keep `/home/x/ImaginationStudio` (projects/uploads) intact, restart
`ams-studio-ui-8197.service`. No model downloads in this path.

## The render-fit blocker is NOT a version bug

`memory_guard.check()` needs `available − need − 6000 ≥ floor`: int8 needs 57.8 GB for ANY supported clip
(fixed 54.5 GB weights + rows); spark-faea has 6.0 GB available because the GLM pair holds ~102 GB of the
124.6 GB unified pool. Full math + proof in `kitty-heist-20261109/handover/tf-fix-report.md`. Upgrading to
4.4.1 + `STUDIO_MEMORY_GUARD=warn` lets the job ATTEMPT (likely OOM-killed by the guard's watchdog); the honest
fixes are a GLM pause window, rendering on a Spark with ≥74 GB free, or adding a second Spark as a Studio worker.

## Verification record (2026-11-10)

- Deployed 4.3.1 source ↔ spark-faea runtime: SHA-256 identical (4 key files, earlier check).
- v4.4.1 release notes read; memory_guard diff 4.3.1→4.4.1 inspected (estimate lines unchanged; warn-mode added).
- Upstream drowzeys main is ahead of v4.4.1 (ef88a074 2026-11-10, page-redraw fixes) — normal release cadence,
  not required for the render-fit work.
