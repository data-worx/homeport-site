---
title: "Deine Daten verlassen nie den Hafen."
description: "Fachdienste in deiner eigenen Infrastruktur: mandantenfähig, mit Verbrauchsmessung, Open Source. Gateway, Mandanten, Authentifizierung, Rate Limits und Verbrauchsexport inklusive."
eyebrow: "Open Source · AGPL-3.0 · selbst gehostet"
lead: "Fachdienste in deiner eigenen Infrastruktur – mandantenfähig, mit Verbrauchsmessung, Open Source."
subline: "Gateway, Mandanten, Authentifizierung, Rate Limits und Verbrauchsexport inklusive – dock die Fachmodule an, die du brauchst."
status: "**Alpha · v0.1.0.** Lies das [Release](https://github.com/data-worx/homeport/releases/tag/v0.1.0) und starte es mit dem [Quickstart](https://github.com/data-worx/homeport#quickstart). Was als Nächstes kommt, steht in der [Roadmap](https://github.com/data-worx/homeport/blob/main/ROADMAP.md)."

features:
  id: features
  menu: "Funktionen"
  pillars:
    - icon: shield-check
      title: "Deine Daten verlassen nie den Hafen."
      text: "Homeport läuft in deiner Umgebung. Kein Dritter zwischen deinen Systemen und deinen Daten. Kein Nach-Hause-Telefonieren."
    - icon: receipt-text
      title: "Leistungsverrechnung eingebaut."
      text: "Die Nutzung wird pro Abteilung, Modul und Einheit gemessen und fürs Controlling exportiert."
    - icon: hp-module
      title: "Tiefe Module, echte Standards."
      text: "Schwierige Fachstandards, richtig umgesetzt: vollständige Validierung, echte Sonderfälle. Keine Spielzeug-APIs."
      planned: true
    - icon: layers
      title: "Docke an, was du brauchst."
      text: "Betreibe nur, was du brauchst. Deine internen APIs docken über den Modulvertrag an, ohne Neustart."
      planned: "Katalogmodule docken auf dieselbe Weise an."
  items:
    - icon: hp-quota
      title: "Faire Nutzung eingebaut."
      text: "Tarife und Drosselung pro Mandant, damit ein Team nicht alle anderen ausbremst."
      planned: "Kontingente pro Mandant."
    - icon: activity
      title: "Beobachtbar ab dem ersten Tag."
      text: "OTLP in das Monitoring, das du schon hast."
      planned: "Dashboards für den Start."
    - icon: log-in
      title: "Dein Identity Provider."
      text: "Single Sign-on über OIDC, mit Entra ID, Keycloak und anderen."
    - icon: badge-check
      title: "Vertrauen als Standard."
      text: "Signierte Images, eine SBOM und ein CVE-Scan für jedes Image."
    - icon: file-text
      title: "Open Source."
      text: "AGPL. Jede Zeile lesbar."

team:
  id: team
  menu: "Für dein Team"
  title: "Für dein Team"
  audiences:
    - eyebrow: "IT & Compliance"
      title: "Souverän durch die Architektur."
      points:
        - "Läuft auf deinen Servern, in deinem Cloud-Tenant oder air-gapped"
        - "Jedes Image signiert, mit SBOM und CVE-Bericht"
        - text: "Ein Audit-Log jeder Admin-Aktion"
          planned: true
    - eyebrow: "Controlling & Finanzen"
      title: "Wissen, wer was genutzt hat."
      points:
        - "Nutzung pro Abteilung, Modul und Einheit"
        - text: "Nutzung als CSV oder JSON exportieren"
          planned: "Periode abschließen"
        - text: "Ein Webhook in dein ERP"
          planned: true
    - eyebrow: "Entwicklung & Betrieb"
      title: "Ein Befehl. Dann läuft es einfach."
      points:
        - "`docker compose up` und du bist live"
        - "OTLP-Traces, -Metriken und -Logs"
        - "Docke deine eigenen APIs über den Modulvertrag an"

how:
  id: how
  menu: "So funktioniert es"
  title: "So funktioniert es"
  lead: "Der Weg vom Download bis zum ersten Modul."
  steps:
    - icon: download
      title: "Holen"
      text: "Die Compose-Datei herunterladen. Die Images sind signiert und kommen aus einer Registry."
    - icon: terminal
      title: "`docker compose up`"
      text: "Gateway und Registry starten. Deinen Identity Provider anbinden."
      planned: "Das Admin-Portal."
    - icon: hp-module
      title: "Module andocken"
      text: "Deine eigenen Dienste, über den Modulvertrag; Katalogmodule docken genauso an. Jedes Modul registriert sich selbst und wird geroutet, gemessen und beobachtet."
  diagram:
    alt: "Architektur: Deine Anwendungen rufen das Homeport-Gateway auf. Das Gateway prüft jeden Aufrufer bei deinem Identity Provider, wendet Drosselung und Verbrauchsmessung an und ruft die angedockten Module mit einem eigenen, kurzlebigen signierten Token auf. Katalogmodule und deine interne API prüfen dieses Token und sprechen nie mit dem Identity Provider. Module registrieren sich bei der Registry. Alle Komponenten senden OTLP-Telemetrie an dein Monitoring."
    catalog: "Aus dem Homeport-Katalog"
    own: "Deine eigenen Dienste, gleicher Vertrag"
    note: "Alles innerhalb des Rahmens läuft in deiner Umgebung. Identität und Monitoring bleiben bei dir."

modules:
  id: modules
  menu: "Module"
  title: "Module: unsere und deine"
  lead: "Module aus dem Homeport-Katalog, und die eigenen APIs deines Unternehmens direkt daneben angedockt. Derselbe Vertrag, dieselbe Plattform, dieselbe Leistungsverrechnung."
  examples:
    - title: "EDIFACT"
      text: "ORDERS, DESADV, INVOIC"
    - title: "E-Rechnung"
      text: "XRechnung, ZUGFeRD"
    - title: "Bankformate"
      text: "CAMT, MT940, SEPA"
  poll: "Welches Modul kommt zuerst? [Stimm in der Umfrage ab](https://github.com/data-worx/homeport/discussions/2) – entschieden wird mit dem Release von Homeport v0.2."
  link: "Zum Modulvertrag"
  url: "https://github.com/data-worx/homeport/tree/main/docs/reference/module-contract"

licensing:
  title: "Open Source und Lizenzen"
  items:
    - icon: file-text
      title: "AGPL-3.0"
      text: "Nutzen, untersuchen, ändern und weitergeben. Im eigenen Unternehmen kostenlos betreiben."
    - icon: git-branch
      title: "Mitmachen"
      text: "Pull Requests sind willkommen. Beitragende unterzeichnen einmalig das [CLA](https://github.com/data-worx/homeport/blob/main/CLA.md)."
---
