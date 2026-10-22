---
title: "Deine Daten verlassen nie den Hafen."
description: "Homeport ist eine selbst gehostete Plattform für tiefe Fachmodule: mandantenfähig, mit Verbrauchsmessung und Open Source."
eyebrow: "Open Source · AGPL-3.0 · selbst gehostet"
lead: "Tiefe Fachmodule – selbst gehostet, mandantenfähig, Open Source."
status: "**Pre-Alpha.** Noch läuft nichts. Diese Seite beschreibt, wofür Homeport gebaut wird; wie weit es ist, zeigt die [Roadmap](https://github.com/data-worx/homeport/blob/main/ROADMAP.md)."

features:
  id: features
  menu: "Funktionen"
  pillars:
    - icon: shield-check
      title: "Deine Daten verlassen nie den Hafen."
      text: "Homeport ist dafür gebaut, in deiner Umgebung zu laufen. Kein Dritter zwischen deinen Systemen und deinen Daten. Kein Nach-Hause-Telefonieren."
    - icon: receipt-text
      title: "Leistungsverrechnung eingebaut."
      text: "Die Nutzung soll pro Abteilung, Modul und Einheit gemessen und fürs Controlling oder direkt in dein ERP exportiert werden."
    - icon: hp-module
      title: "Tiefe Module, echte Standards."
      text: "Schwierige Fachstandards, richtig umgesetzt: vollständige Validierung, echte Sonderfälle. Keine Spielzeug-APIs."
    - icon: layers
      title: "Docke an, was du brauchst."
      text: "Betreibe nur, was du brauchst, unsere Module oder deine. Katalogmodule und deine internen APIs sollen auf dieselbe Weise andocken, ohne Neustart."
  items:
    - icon: hp-quota
      title: "Faire Nutzung eingebaut."
      text: "Tarife, Kontingente und Drosselung pro Mandant, damit ein Team nicht alle anderen ausbremst."
    - icon: activity
      title: "Beobachtbar ab dem ersten Tag."
      text: "Dashboards für den Start und OTLP in das Monitoring, das du schon hast."
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
        - "Ein Audit-Log jeder Admin-Aktion"
    - eyebrow: "Controlling & Finanzen"
      title: "Wissen, wer was genutzt hat."
      points:
        - "Nutzung pro Abteilung, Modul und Einheit"
        - "Periode abschließen, als CSV oder JSON exportieren"
        - "Ein Webhook in dein ERP"
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
  lead: "Der geplante Weg vom Download bis zum ersten Modul."
  steps:
    - icon: download
      title: "Holen"
      text: "Die Compose-Datei herunterladen. Die Images sind signiert und kommen aus einer Registry."
    - icon: terminal
      title: "`docker compose up`"
      text: "Gateway, Registry und Admin-Portal starten. Deinen Identity Provider anbinden."
    - icon: hp-module
      title: "Module andocken"
      text: "Aus dem Katalog oder deine eigenen Dienste. Jedes Modul registriert sich selbst und wird geroutet, gemessen und beobachtet."

modules:
  id: modules
  menu: "Module"
  title: "Module: unsere und deine"
  lead: "Tiefe Module aus dem Homeport-Katalog, und die eigenen APIs deines Unternehmens direkt daneben angedockt. Derselbe Vertrag, dieselbe Plattform, dieselbe Leistungsverrechnung."
  link: "Zum Modulvertrag"
  url: "https://github.com/data-worx/homeport/tree/main/docs/module-contract"

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
