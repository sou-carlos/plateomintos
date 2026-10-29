# Repository Guidelines

## Project Structure & Module Organization

This is a small Godot 4.7 2D game project. `project.godot` holds engine settings and input actions; `main.tscn` and `main.gd` form the game entry point. Player, enemy, and HUD logic lives in the matching root-level `.gd` scripts, with `.tscn` scenes alongside them. Artwork is in `art/`, fonts in `fonts/`, and shared cursor/app icon assets at the repository root. Godot-generated cache files in `.godot/` are editor artifacts, not source.

## Build, Test, and Development Commands

Open the repository folder in Godot 4.7, or use the command line from the project root:

- `godot --editor project.godot` opens the project for editing.
- `godot --path .` runs the configured main scene.
- `godot --headless --path . --editor --quit` imports assets and checks that the project opens without launching the game window.

There is no separate build system or automated test suite currently. Verify gameplay changes by running the project and checking the affected scene or input flow in Godot.

## Coding Style & Naming Conventions

Use UTF-8 text and follow `.editorconfig` (root applies to all files). Keep GDScript readable with Godot's standard indentation and idioms. Preserve the existing Portuguese names for gameplay scripts, nodes, and input actions (for example, `jogador.gd`, `mvEsquerda`, and `ataque basico`) unless a change intentionally renames all references. Keep scene and script basenames paired where they represent the same game object.

## Testing Guidelines

No test framework or coverage target is configured. For script or scene changes, run the headless editor check, then launch the game and exercise the relevant behavior. Confirm the Output panel has no new parse errors or missing-resource warnings.

## Commit & Pull Request Guidelines

This checkout has no Git history available, so repository-specific commit conventions cannot be confirmed. Use concise imperative commit subjects, such as `Adjust enemy spawn timing`. Pull requests should describe player-visible changes, list the Godot checks performed, and include screenshots or a short capture when visual behavior changes.

## Assets & Configuration

Edit project settings through Godot's Project Settings UI when practical. Keep imported source assets in `art/` or `fonts/`; avoid committing generated `.godot/` cache content.
