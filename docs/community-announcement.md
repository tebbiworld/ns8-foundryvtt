<!--
First community post for the NS8 Foundry VTT module, written in the style
of https://community.nethserver.org/t/ns8-forgejo-testing/28554 (first post).
Paste into a new topic on community.nethserver.org, category "App", tag "ns8".
Fill in the wiki link once the page is published.
-->

# NS8 Foundry VTT (testing)

Hi all,

I've built an NS8 module for [Foundry Virtual Tabletop](https://foundryvtt.com/) — a self-hosted, web-based virtual tabletop for running tabletop RPGs in the browser. It's built on the [felddy/foundryvtt](https://github.com/felddy/foundryvtt-docker) container image.

It's in my community repository. To try it, add the repo once:

```
api-cli run add-repository --data '{"name":"tebbiworld","url":"https://raw.githubusercontent.com/tebbiworld/ns8-repo/main/ns8/updates/","status":true,"testing":false}'
```

then install **Foundry VTT** from the Software Center. (Or straight from the image: `add-module ghcr.io/tebbiworld/foundryvtt:latest 1`.)

What it does:

* Publishes Foundry on one host name through Traefik, with TLS/Let's Encrypt, HTTP-to-HTTPS redirection and WebSocket proxying handled for you
* Settings page maps to the felddy image options: host name, admin access key, timezone, Foundry version and so on
* Downloads the Foundry software for you at first start — either with your foundryvtt.com account credentials or a presigned release URL from your profile
* Keeps all worlds, modules, systems, config, the licence and the download cache on one rootless named volume
* No dedicated node IP needed — one instance uses a single loopback TCP port behind Traefik

A few things to know:

* **You need your own Foundry VTT licence** — the module doesn't ship one, it just runs the software you're entitled to
* Foundry binds the licence to the host name, so pick the FQDN before activating the licence
* The first start downloads the app and can take a few minutes (the unit allows up to 15 minutes to come up)
* It's still testing — I've run it on my own setup but more eyes are very welcome

If you play RPGs and give it a spin, I'd love to hear how it goes — bug reports, rough edges and suggestions all welcome.

Docs: NethServer wiki (tebbiworld repository) · Source: [github.com/tebbiworld/ns8-foundryvtt](https://github.com/tebbiworld/ns8-foundryvtt)

Thanks!

*Category: App · Tags: ns8*
