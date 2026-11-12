---
title: "Your data never leaves port."
description: "Business services in your own infrastructure: multi-tenant, metered, open source. Gateway, tenants, authentication, rate limits and usage export included."
eyebrow: "Open source · AGPL-3.0 · self-hosted"
lead: "Business services in your own infrastructure – multi-tenant, metered, open source."
subline: "Gateway, tenants, authentication, rate limits and usage export included – add the business modules you need."
status: "**Alpha · v0.1.0.** Read the [release](https://github.com/data-worx/homeport/releases/tag/v0.1.0) and run it with the [quickstart](https://github.com/data-worx/homeport#quickstart). What comes next is on the [roadmap](https://github.com/data-worx/homeport/blob/main/ROADMAP.md)."

features:
  id: features
  menu: "Features"
  pillars:
    - icon: shield-check
      title: "Your data never leaves port."
      text: "Homeport runs in your environment. No third party between your systems and your data. No phone-home."
    - icon: receipt-text
      title: "Chargeback built in."
      text: "Usage is metered per department, per module and per unit, and exported for controlling."
    - icon: hp-module
      title: "Deep modules, real standards."
      text: "Hard business standards, done properly: full validation, real edge cases. No toy APIs."
      planned: true
    - icon: layers
      title: "Dock what you need."
      text: "Run only what you need. Your internal APIs dock on the module contract, without a restart."
      planned: "Catalog modules dock the same way."
  items:
    - icon: hp-quota
      title: "Fair use by design."
      text: "Plans and throttling per tenant, so one team cannot slow down everyone else."
      planned: "Quotas per tenant."
    - icon: activity
      title: "Observable from day one."
      text: "OTLP into the monitoring you already have."
      planned: "Dashboards to start with."
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
        - text: "An audit log of every admin action"
          planned: true
    - eyebrow: "Controlling & Finance"
      title: "Know who used what."
      points:
        - "Usage per department, module and unit"
        - text: "Export usage as CSV or JSON"
          planned: "Close a period"
        - text: "A webhook into your ERP"
          planned: true
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
  lead: "The path from download to the first module."
  steps:
    - icon: download
      title: "Pull"
      text: "Get the compose file. Images are signed and come from one registry."
    - icon: terminal
      title: "`docker compose up`"
      text: "Gateway and registry start. Connect your identity provider."
      planned: "The admin portal."
    - icon: hp-module
      title: "Dock modules"
      text: "Your own services, on the module contract; catalog modules dock the same way. Each registers itself and is routed, metered and observed."
  diagram:
    alt: "Architecture: your apps call the Homeport gateway. The gateway validates each caller against your identity provider, applies throttling and metering, and calls the docked modules with its own short-lived signed token. Catalog modules and your internal API validate that token and never talk to the identity provider. Modules register with the registry. All components send OTLP telemetry to your monitoring."
    catalog: "From the Homeport catalog"
    own: "Your own services, same contract"
    note: "Everything inside the frame runs in your environment. Identity and monitoring stay yours."

modules:
  id: modules
  menu: "Modules"
  title: "Modules: ours and yours"
  lead: "Modules from the Homeport catalog, and your company's own APIs docked right next to them. Same contract, same platform, same chargeback."
  examples:
    - title: "EDIFACT"
      text: "ORDERS, DESADV, INVOIC"
    - title: "E-invoicing"
      text: "XRechnung, ZUGFeRD"
    - title: "Bank statement formats"
      text: "CAMT, MT940, SEPA"
  poll: "Which module comes first? [Vote in the poll](https://github.com/data-worx/homeport/discussions/2) – it is decided when Homeport v0.2 is released."
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
