
## Tokens & Permissions

Two separate tokens are involved, one per workflow:

### `RENOVATE_TOKEN` — opening PRs (Renovate)

Used by [`renovate.yaml`](.github/workflows/renovate.yaml) so Renovate can scan the repo and open PRs.

- **Type:** a Personal Access Token (PAT), *not* the built-in `GITHUB_TOKEN`.
- **Why a PAT:** PRs opened by the built-in `GITHUB_TOKEN` do **not** trigger other workflows. Opening PRs with a PAT is what lets the `pull_request` event fire and start the CI workflow below.
- **Scopes:** classic PAT with `repo` (and `workflow` if Renovate may touch files under `.github/workflows/`). A fine-grained PAT needs *Contents: Read & write*, *Pull requests: Read & write*.
- **Set it:**

      gh secret set RENOVATE_TOKEN --body '<TOKEN>'

### `GITHUB_TOKEN` — building, testing, merging (CI)

Used by [`ci.yaml`](.github/workflows/ci.yaml). This is the automatic token GitHub injects into every run — no secret to create. The workflow grants it exactly what the merge needs:

```yaml
permissions:
  contents: write        # push the merge commit to master
  pull-requests: write   # merge the PR via the API
```

Merging through the API with this token needs **no** repo-level "Allow auto-merge" setting and **no** ruleset — which is what the native Renovate `platformAutomerge` path required (see [History](#history--why-not-just-use-renovates-automerge)).

> **Note:** a merge commit made with `GITHUB_TOKEN` will not itself trigger further workflows (e.g. a deploy on push to `master`). If you need that, swap in a PAT for the merge step.

### Branch protection

If `master` later gets required status checks or required approvals, the API merge respects them. Renovate cannot approve its own PR, so a "require approval" rule would block auto-merge unless a second reviewer (human or bot with a different token) approves.

## Clean Testing

For clean testing, re-create the Repository on GitHub when it gets to polluted with Tags and Releases:

    gh repo delete --yes "$(basename -s .git "$(git remote get-url origin)")"  # bash
    gh repo delete --yes ${${$(git remote get-url origin)##*/}%.git}  # zsh

    gh repo create --public "$(basename -s .git "$(git remote get-url origin)")"  # bash
    gh repo create --public ${${$(git remote get-url origin)##*/}%.git}  # zsh

    gh secret set RENOVATE_TOKEN --body '<TOKEN>'

    git tag | xargs git tag -d
    git push -u origin master

## History — why not just use Renovate's `automerge`?

This repo moved merging into a workflow because Renovate's own auto-merge has two modes, and both were dead ends for this setup.

Setting `automerge: true` only tells Renovate that a PR is *eligible* to be merged. **How** it merges depends on `platformAutomerge`:

**1. `platformAutomerge: true` (the default) — delegate to GitHub's native auto-merge.**
Renovate doesn't merge anything itself; it just flips on GitHub's "auto-merge" toggle for the PR and lets GitHub merge once conditions are met. GitHub will only accept that toggle if **both**:
- the repo setting *Settings → General → Allow auto-merge* is enabled, **and**
- a branch protection rule / ruleset exists for the target branch with **at least one required status check** — GitHub needs a gate to wait on; with no required check there is nothing to auto-merge *against*, so the toggle is refused and nothing ever merges.

So the default path forces you to maintain repo settings **and** a ruleset, and it silently does nothing if either is missing.

**2. `platformAutomerge: false` — Renovate merges the branch itself.**
Renovate merges during **its own scheduled run**, not when CI finishes, and only if it can see that required checks have **already passed** at that moment. In practice this merged nothing here: with no required status checks configured there was nothing for Renovate to confirm as green, and merges (if any) would only happen on Renovate's cron cadence, not right after a build. Observed: no merges at all, with or without GitHub settings.

**The limits, in short:**
- Renovate never merges "the instant CI goes green" — mode 1 defers to GitHub, mode 2 only acts on Renovate's schedule.
- Mode 1 hard-requires a repo setting **and** a ruleset with a required check.
- Mode 2 needs pre-existing passing required checks and doesn't react to a `pull_request` workflow completing.

Doing the merge from [`ci.yaml`](.github/workflows/ci.yaml) sidesteps all of it: the workflow runs on `pull_request`, waits for build+test in the same run, and merges via the API immediately — no repo-level auto-merge setting and no ruleset required.
