# Releasing

How a merged `main` becomes the site at `homeport.data-worx.de`. The binding
rules are `core.releasing` and `core.release-site` in
[`AGENTS.core.md`](../AGENTS.core.md); this repository follows trunk with tags
and has no test environment.

## Releasing a version

A merge to `main` does not publish anything. A release does:

1. Rename `## [Unreleased]` in `CHANGELOG.md` to `## [X.Y.Z] - YYYY-MM-DD`
   in a pull request, and merge it.
2. Tag the merge commit on `main` and push the tag:

   ```bash
   git switch main && git pull
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

The workflow `.github/workflows/deploy.yml` then runs two jobs:

- **release** checks that the tag is on `main` and has its changelog section,
  runs the gates, builds the site once and creates the GitHub release `vX.Y.Z`.
  The release text is the changelog section, and the release carries the
  build as `homeport-site-vX.Y.Z.tar.gz`.
- **deploy** downloads that archive and uploads it to GitHub Pages. It never
  builds.

Check the result:

```bash
gh release view vX.Y.Z      # lists homeport-site-vX.Y.Z.tar.gz under ASSETS
curl -sI https://homeport.data-worx.de/ | head -1     # HTTP/1.1 200 OK
```

## Deploying a release again

A redeploy or a rollback deploys the archive of an existing release, built
when it was tagged. Start the workflow by hand on that tag:

```bash
gh workflow run deploy.yml --ref vX.Y.Z
```

Only the deploy job runs. The workflow fails when the release `vX.Y.Z` has no
archive. `v0.1.0` to `v0.2.0` were released before the archive existed and
can therefore not be deployed again.

Start it on the tag, not on `main`: the `github-pages` environment rejects any
ref but a tag.

## The github-pages environment

The repository's `github-pages` environment allows only tags matching `v*.*.*`
to deploy, no branch. GitHub creates it allowing `main` when Pages is switched
on; a tag deploy is then rejected until the rule is changed.

## The imprint address

The release job takes the imprint address from the repository secret
`IMPRINT_ADDRESS` and fails when it is empty. Set it from your local file, so
the address never passes through a terminal or a log:

```bash
gh secret set IMPRINT_ADDRESS < imprint.local.txt
```

In PowerShell, where `<` is not available:

```powershell
Get-Content imprint.local.txt -Raw | gh secret set IMPRINT_ADDRESS
```
