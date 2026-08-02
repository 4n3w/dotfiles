# `config.d` — the per-machine override seam

`../config` is the portable sway base: keybindings, colours, layout. It ends with

```
include ~/.config/sway/config.d/*.conf
```

so anything a *specific* machine needs — `output`, `input`, rotation, scale, gaps,
idle behaviour — goes in a `.conf` file dropped here instead of being edited into the
base. Later directives win in sway, so an override file simply takes precedence.

This directory is deliberately near-empty in this repo. The files that land here are
owned by machine-specific repos and symlinked in. On the ClockworkPi uConsole:

```
~/.config/sway/config.d/10-uconsole.conf -> ~/uconsole/sway/10-uconsole.conf
```

which sets the DSI panel's mode and `transform 90`, the trackball's pointer options,
and a `swayidle` rule. None of that would be correct on any other machine, which is
exactly why it is not in this repo.

## Conventions

- **Numeric prefixes.** `include` expands the glob in sorted order, so `10-`, `20-`
  control precedence between multiple override files.
- **`.conf` only.** The glob matches `*.conf`; anything else here (like this README) is
  ignored by sway and safe to keep.
- **Overrides, not forks.** If you find yourself re-stating most of the base config in
  an override, the setting probably belongs in the base instead.

## Gotcha

`sway --validate` checks directive *names*, not *values*. A bad value like
`mode 1280x720` on a portrait panel, or i3-gaps syntax sway never implemented, passes
validation and then fails silently at runtime. Check values against `man 5 sway` and
`man 5 sway-output`, and check the installed binary rather than current online docs —
older sway releases lack directives the docs describe.
