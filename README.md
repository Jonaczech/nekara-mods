# Nekara Mods

Source repository for Nekara's client-side Fabric mod for Minecraft `26.1.2`.
The mod customizes the title logo, the static out-of-game menu background, and
Minecraft music event mappings.

## Repository contents

This repository intentionally contains the source code, Gradle build files,
build scripts, and Nekara menu artwork. Audio source files, generated OGG files,
and built JAR files are not tracked. The following directory structure is kept
with `.gitkeep` files so that authorized assets can be restored locally:

- `source_music/` contains local MP3 or OGG source tracks grouped by category.
- `src/main/resources/assets/minecraft/sounds/music/nekara/` is the generated
  streamed OGG output used by the mod.

Do not add music or other third-party assets unless their distribution rights
have been verified.

## Local build

1. Restore only music assets that are authorized for local use into
   `source_music/<category>/`.
2. Install `ffmpeg` and make it available on `PATH` (or set `FFMPEG_PATH`).
3. Run `powershell -ExecutionPolicy Bypass -File .\scripts\rebuild-from-source.ps1`.

The script converts the source tracks, regenerates `sounds.json`, refreshes the
menu assets, and writes the JAR into `dist/`. Generated assets remain ignored.
