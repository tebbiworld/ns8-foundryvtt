# ns8-foundryvtt

A [NethServer 8](https://github.com/NethServer/ns8-core) module that runs
[Foundry Virtual Tabletop](https://foundryvtt.com/) using the
[felddy/foundryvtt](https://github.com/felddy/foundryvtt-docker) container image.

Foundry is a self-hosted, web-based virtual tabletop for tabletop RPGs. It is a
Node.js web/websocket application, so it maps cleanly onto NS8: a single HTTP
service published on one host name through Traefik (TLS, Let's Encrypt and
WebSocket proxying included). **You need your own Foundry VTT license.**

## Install

```
add-module ghcr.io/tebbiworld/foundryvtt:latest 1
```

## Settings

The settings page maps to the [felddy image environment
variables](https://github.com/felddy/foundryvtt-docker#environment-variables):

| Setting | Env var | Notes |
| --- | --- | --- |
| Host name | `FOUNDRY_HOSTNAME` + Traefik host | FQDN Foundry is published on. **Foundry binds the license to this host** — choose it before activating the license. |
| Let's Encrypt certificate | (Traefik) | Request a valid certificate for the host. |
| HTTP to HTTPS redirection | (Traefik) | Redirect plain HTTP to HTTPS. |
| Administrator access key | `FOUNDRY_ADMIN_KEY` | Protects the Foundry setup/configuration screen. Empty = no admin lock. |
| Software download method | — | `credentials` (account) or `release_url` (presigned URL). |
| Foundry account / password | `FOUNDRY_USERNAME` / `FOUNDRY_PASSWORD` | foundryvtt.com login used to download the software and fetch a license. |
| Presigned release URL | `FOUNDRY_RELEASE_URL` | Alternative to account credentials; timed URL from your profile. |
| License key | `FOUNDRY_LICENSE_KEY` | Optional; fetched automatically when empty and credentials are set. |
| Foundry version | `FOUNDRY_VERSION` | Specific version to install; empty = latest stable. |
| Timezone | `TZ` | e.g. `Europe/Berlin`. |

Traefik terminates TLS on 443, so the container additionally receives
`FOUNDRY_PROXY_SSL=true` and `FOUNDRY_PROXY_PORT=443` automatically.

## Storage

All Foundry data (worlds, modules, systems, config, the license and the download
cache) lives on the rootless named volume `foundryvtt-data` mounted at `/data`.

## Notes

* On first start the container downloads the Foundry software; this can take a
  few minutes (the app unit allows up to 15 minutes to start).
* One instance uses one allocated TCP port on the node loopback, fronted by
  Traefik. No dedicated node IP is required.
