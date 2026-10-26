---
title: "Your data never leaves port."
description: "Homeport is a self-hosted platform for deep business modules: multi-tenant, metered and open source."
eyebrow: "Open source · AGPL-3.0 · self-hosted"
lead: "Deep business modules – self-hosted, multi-tenant, open source."
status: "**Pre-alpha.** Nothing runs yet. This page describes what Homeport is being built to do; the [roadmap](https://github.com/data-worx/homeport/blob/main/ROADMAP.md) shows how far it is."

features:
  id: features
  menu: "Features"
  pillars:
    - icon: shield-check
      title: "Your data never leaves port."
      text: "Homeport is built to run in your environment. No third party between your systems and your data. No phone-home."
    - icon: receipt-text
      title: "Chargeback built in."
      text: "Usage is meant to be metered per department, per module and per unit, and exported for controlling or straight into your ERP."
    - icon: hp-module
      title: "Deep modules, real standards."
      text: "Hard business standards, done properly: full validation, real edge cases. No toy APIs."
    - icon: layers
      title: "Dock what you need."
      text: "Run only what you need, ours or yours. Catalog modules and your internal APIs are to dock the same way, without a restart."
  items:
    - icon: hp-quota
      title: "Fair use by design."
      text: "Plans, quotas and throttling per tenant, so one team cannot slow down everyone else."
    - icon: activity
      title: "Observable from day one."
      text: "Dashboards to start with, and OTLP into the monitoring you already have."
    - icon: log-in
      title: "Your identity provider."
      text: "Single sign-on through OIDC, with Entra ID, Keycloak and others."
    - icon: badge-check
      title: "Trust by default."
      text: "Signed images, an SBOM and a CVE scan for every image."
    - icon: file-text
      title: "Open source."
      text: "AGPL. Read every line."

team:
  id: team
  menu: "For your team"
  title: "For your team"
  audiences:
    - eyebrow: "IT & Compliance"
      title: "Sovereign by architecture."
      points:
        - "Runs on your servers, in your cloud tenant or air-gapped"
        - "Every image signed, with an SBOM and a CVE report"
        - "An audit log of every admin action"
    - eyebrow: "Controlling & Finance"
      title: "Know who used what."
      points:
        - "Usage per department, module and unit"
        - "Close a period, export CSV or JSON"
        - "A webhook into your ERP"
    - eyebrow: "Developers & Ops"
      title: "One command. Then just run it."
      points:
        - "`docker compose up` and you are live"
        - "OTLP traces, metrics and logs"
        - "Dock your own APIs on the module contract"

how:
  id: how
  menu: "How it works"
  title: "How it works"
  lead: "The intended path from download to the first module."
  steps:
    - icon: download
      title: "Pull"
      text: "Get the compose file. Images are signed and come from one registry."
    - icon: terminal
      title: "`docker compose up`"
      text: "Gateway, registry and admin portal start. Connect your identity provider."
    - icon: hp-module
      title: "Dock modules"
      text: "From the catalog or your own services. Each registers itself and is routed, metered and observed."
  diagram:
    alt: "Architecture: your apps call the Homeport gateway. The gateway validates each caller against your identity provider, applies throttling and metering, and calls the docked modules with its own short-lived signed token. Catalog modules and your internal API validate that token and never talk to the identity provider. Modules register with the registry. All components send OTLP telemetry to your monitoring."
    catalog: "From the Homeport catalog"
    own: "Your own services, same contract"
    note: "Everything inside the frame runs in your environment. Identity and monitoring stay yours."

modules:
  id: modules
  menu: "Modules"
  title: "Modules: ours and yours"
  lead: "Deep modules from the Homeport catalog, and your company's own APIs docked right next to them. Same contract, same platform, same chargeback."
  link: "Read the module contract"
  url: "https://github.com/data-worx/homeport/tree/main/docs/reference/module-contract"

licensing:
  title: "Open source and licensing"
  items:
    - icon: file-text
      title: "AGPL-3.0"
      text: "Use, study, change and share. Run it for your company at no cost."
    - icon: git-branch
      title: "Contribute"
      text: "Pull requests welcome. Contributors sign the [CLA](https://github.com/data-worx/homeport/blob/main/CLA.md) once."
---
