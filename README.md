# Helm Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/oli-the-dev)](https://artifacthub.io/packages/search?repo=oli-the-dev)

## Publish a new Chart version

To publish a new version of a Chart just update its version to the new version in the `Chart.yaml` file and push it to the repository.
The GitHub Action will automatically create a new release and push the Chart to the Repository.

## App image updates

[Renovate](https://github.com/apps/renovate) watches `appVersion` in charts that have a `# renovate:` comment above it. When a new upstream release exists it opens a PR that:

1. Bumps `appVersion`
2. Bumps the chart `version` (patch for app patches, minor otherwise)

Install the [Mend Renovate GitHub App](https://github.com/apps/renovate) on this repository if it is not already installed. Chart dependencies (Valkey, …) and GitHub Actions stay on Dependabot.
