# Changelog

## 1.0.2 — 2026-09-14

### Fixed

- `update-module` now restarts the service, so a new upstream image (automatic releases) or a changed unit takes effect right after the update instead of at the next reboot.

## 1.0.1 — 2026-09-14

### Changed

- Container image pinned to `felddy/foundryvtt:14.367.0` instead of the moving `14` tag (same image as `14` today). The Foundry software version stays controlled by the *Foundry version* setting; newer felddy images arrive as module updates (automatic every ~6 weeks).

