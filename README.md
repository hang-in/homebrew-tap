# homebrew-tap

Homebrew tap for [@hang-in](https://github.com/hang-in)'s command-line
tools, distributed as pre-built binaries built by each source repo's
GitHub Actions release workflow.

## Install

```sh
brew tap hang-in/tap
brew install <formula-name>
# or in one shot:
brew install hang-in/tap/<formula-name>
```

## Available formulas

| Formula | Source | Description |
|---|---|---|
| [`sshc`](Formula/sshc.rb) | [hang-in/sshc](https://github.com/hang-in/sshc) | Minimal TUI for managing and connecting to SSH hosts. |

Future formulas (`secall`, `tunaflow`, …) will land here following the
same pattern.

## How a formula gets here

Each source repo owns its own publication pipeline:

1. **Release build** — on `git push` of a `v*` tag the repo's
   `.github/workflows/release.yml` cross-compiles binaries for
   `x86_64-apple-darwin`, `aarch64-apple-darwin`,
   `x86_64-unknown-linux-gnu`, and `aarch64-unknown-linux-gnu`,
   strips them, packs each as `<bin>-<target>.tar.gz`, and uploads
   the four tarballs as assets on the GitHub release.

2. **Formula bump** — once the GitHub release is **published**, the
   repo's `.github/workflows/bump-homebrew.yml` runs
   [`mislav/bump-homebrew-formula-action`](https://github.com/mislav/bump-homebrew-formula-action).
   It opens a PR on this tap repo that updates the formula's `url`
   and `sha256` entries to the new release. Merging the PR makes
   `brew upgrade` see the new version.

The action needs a personal access token with `repo` write to this
tap. Each source repo stores it as a `HOMEBREW_TAP_TOKEN` secret.

## Adding a new formula

1. Drop a new `Formula/<name>.rb` here following `sshc.rb` as a
   template — pre-built binaries, `on_macos`/`on_linux` +
   `on_arm`/`on_intel` blocks, no source build.
2. In the source repo, copy `.github/workflows/release.yml` +
   `.github/workflows/bump-homebrew.yml` from `hang-in/sshc`, change
   the `formula-name` input on the bump action, and store the same
   `HOMEBREW_TAP_TOKEN` secret.
3. Tag a release. The pipeline does the rest.

Formulas live flat in `Formula/` per Homebrew convention — no
subdirectories.

## Untap

```sh
brew untap hang-in/tap
```

## License

Formulas are MIT (matching the upstream tools).
