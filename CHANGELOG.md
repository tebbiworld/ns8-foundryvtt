# Changelog

## 1.1.0 — 2026-09-19

Alignment with the NethServer module conventions (NethServer/agents skills).

### Changed

- **Secrets moved out of the module environment.** The admin key, the foundryvtt.com password, the license key and the presigned release URL are now kept in `state/passwords.env` (mode 0600) instead of `state/environment`, which NS8 mirrors to Redis in plain text. Existing installations are migrated on update; the values do not change. The secrets are no longer passed on the podman command line.
- **Module backup now contains the data.** New `etc/state-include.conf`: the backup holds the `foundryvtt-data` volume (worlds, systems, modules, assets) and the secrets file. Before, only the module environment was saved.
- **Working restore.** New `restore-module` steps re-apply every setting on the restored instance.
- Service restarts list every unit of the pod explicitly.

### Fixed

- `build-images.sh` builds the UI itself. It relied on a locally built `ui/dist`, so a build on a clean checkout (CI, the automatic upstream release) failed.

### Added

- Robot Framework tests (install, update from the previous release, backup and restore) run on real NS8 nodes through `stephdl/ns8-ci-actions`.

## 1.0.2 — 2026-09-14

### Fixed

- `update-module` now restarts the service, so a new upstream image (automatic releases) or a changed unit takes effect right after the update instead of at the next reboot.

## 1.0.1 — 2026-09-14

### Changed

- Container image pinned to `felddy/foundryvtt:14.367.0` instead of the moving `14` tag (same image as `14` today). The Foundry software version stays controlled by the *Foundry version* setting; newer felddy images arrive as module updates (automatic every ~6 weeks).

