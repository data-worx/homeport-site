---
title: "Homeport v0.2.0: the admin portal"
date: 2026-11-19
author: René Kuss
description: The operator gets a portal for tenants, plans, clients, modules, usage and the audit log. Three decisions shape how it reaches the platform.
---

Homeport v0.2.0 is out. It brings the admin portal: a web interface in
which the operator signs in at their own identity provider and manages
what the platform holds.

## What the portal does

- **Tenants, plans and clients.** The operator creates and renames
  tenants, creates and changes plans with their rate limits, and registers
  the client ids of their identity provider for a tenant and a plan.
  Homeport never creates clients at the identity provider; it only records
  which client belongs to whom.
- **Modules.** Every registered module with its versions, instances, last
  heartbeat and routes, and a link to its API docs where they are served.
- **Usage.** One row per tenant, one column per module and meter, summed
  over a period, with totals, and downloadable per hour or day as CSV or
  JSON.
- **The audit log.** Who changed which tenant, plan or client, and who read
  which tenant's usage, newest first and filterable.

The [admin portal documentation](/docs/operators/admin-portal/) shows
every screen.

A portal that lists things is not hard to build. What took the time is how
it reaches the platform. Three decisions shape that, and they are written
down in [ADR-0020](/docs/architecture/adr/0020-the-operator-as-a-caller/).

## The operator is a caller of its own

The portal is the first caller of the platform services besides the
gateway, and the first human one. Homeport lets a new caller in only by
authenticating it as itself: no trust in the network, no shared secret.

So the operator signs in at the portal with OIDC, authorization code with
PKCE, at the identity provider the operator already runs for their
tenants. A configurable claim, such as `roles` with `homeport-admin`,
grants access. There is one role and no finer permissions.

The portal calls the admin API from its server only, never from the
browser. The gateway validates the operator's token and forwards the
request with the same kind of caller token every forwarded request gets,
told apart by its scope `admin` and by carrying no tenant. A service
serves its admin endpoints on that scope only: a token with a tenant, or a
service's own token, does not reach them.

That gives a second caller without a second mechanism. And reading across
tenants, which row-level security otherwise forbids, is confined to one
database role per service, `metering_admin` being the first. It reads every
tenant's rows through a policy of its own instead of `BYPASSRLS`, which
would lift row-level security on every table.

## The audit entry is written in the same transaction

Every change the operator makes, and every read of tenant data, writes an
audit entry in the same transaction as the action itself, into the
`audit_entries` table of the service that owns the data.

The same transaction is the point. An entry written afterwards, or sent to
a log, can be lost while the change it describes is kept. Here, either
both are stored or neither is.

The entry records the operator's subject and display name as they were at
the time, so it stays readable after the user is gone from the identity
provider. The service may add entries and read them, never change or
delete them; an integration test asserts that. Homeport never deletes
audit entries itself. They hold personal data, and how long they are kept
is the operator's decision.

There is no single audit log across services. Each service keeps its own,
in its own database schema, and the portal shows them in one list. When
one service does not answer, the page shows the others and names the one
that is missing.

## The admin API has a port of its own

The admin API lives on the gateway under `/platform/v1/admin/...`, but
only on a second endpoint. On the public endpoint the admin routes do not
exist and answer like any unknown path, and the compose file does not
publish the admin port.

The reason is what a mistake costs. A check that is missing or a route that
is misconfigured would, on a shared port, put the admin API in front of
everyone who can reach the gateway. On a port of its own, nothing on the
public side can reach it, whatever goes wrong in the routing. An operator
who wants to automate against the admin API publishes the port on purpose.

## Upgrading

The release adds the database role `metering_admin`, which an existing
installation creates by hand before it migrates. The
[upgrade guide](/docs/operators/upgrading/) walks through it step by step,
the way back included. From this release on, every release is tested as an
upgrade from the one before.

The release notes are on
[GitHub](https://github.com/data-worx/homeport/releases/tag/v0.2.0).
