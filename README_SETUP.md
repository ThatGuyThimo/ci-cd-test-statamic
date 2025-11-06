README — Statamic full-stack testbed (Docker / Terraform / GitHub Actions / DO App Platform)

## Purpose

This repository is a full-stack testbed demonstrating how to build, deploy and manage a Statamic (Laravel) site using:

-   Docker for local development
-   GitHub Actions for CI/CD (build, push, deploy)
-   Terraform for infrastructure (DigitalOcean App Platform, Spaces, Databases)
-   DigitalOcean App Platform for hosting

This README explains how to set up and use the project locally, how the CI/CD flow works, and how to manage Terraform runs and deployments.

## Prerequisites

Local dev machine needs:

-   Docker & docker-compose
-   Git
-   Node.js and npm (if you want to run watchers locally outside container)
-   PHP (optional; you can use the containerized PHP)
-   An account and API token for DigitalOcean (DO)
-   DigitalOcean Container Registry and App Platform access
-   (Recommended) Terraform installed for local infra work
    The production `dockerfile` builds the Statamic control panel assets during the image build. For local rapid development use `npm run watch` to regenerate assets.

README — Statamic full-stack testbed (How to use)

## Overview

This file explains how to use the repository's CI/CD and infra automation: the GitHub Actions workflow, Terraform infra usage, environment variables and secrets, how the Dockerfile is built in CI, and how to run local npm tasks for asset development.

## GitHub Actions (what runs and how to trigger)

-   Trigger: push a Git tag matching v\* (example: `git tag v1.0.0 && git push origin v1.0.0`).
-   Jobs:
    -   build: builds the Docker image using `dockerfile` and pushes to the configured DO Container Registry.
    -   terraform: runs `terraform init` and `terraform apply` in `infra/`. It generates `app.yaml`, applies infra, and writes the app URL to an artifact (`app_url.txt`).
    -   set-app-url-and-redeploy (if present): downloads `app_url.txt` and `app.yaml`, patches `APP_URL` to https, and re-applies the app spec.

## Trigger a deploy (example)

```zsh
git tag v1.0.0
git push origin v1.0.0
```

When the tag push completes the `build` job runs, then `terraform` runs and applies the app spec.

## Terraform (CI usage and local commands)

-   CI: Terraform is executed inside the `infra/` directory by the GitHub Actions `terraform` job.
<!-- -   Local (optional): to run Terraform locally:

```zsh
cd infra
terraform init
terraform plan -var "do_token=$DO_TOKEN" -var "app_image=$DOCR_REGISTRY/statamic-app:latest"
terraform apply -auto-approve -var "do_token=$DO_TOKEN" -var "app_image=$DOCR_REGISTRY/statamic-app:latest"
```

Replace the `-var` values with the appropriate environment variables listed below. -->

## Dockerfile (how image is built in CI)

-   The CI `build` job uses `docker/build-push-action` to build the image from the repository root using `./dockerfile` and pushes tags:

    -   `statamic-app:v*`
    -   `statamic-app:latest`

-   To build locally (same Dockerfile):

```zsh
docker build -f dockerfile -t local/statamic:latest .
```

## Local npm usage (assets)

-   To install and run the asset watcher from your host machine:

```zsh
npm install
npm run watch
```

-   The production image runs the asset build during Docker build, but local development can use `npm run watch` to regenerate `public/build`.

## Environment variables and GitHub repository settings

Set the following values in your repository's GitHub **Secrets** or **Variables** (use Secrets for sensitive values):

Secrets (sensitive — set in GitHub Secrets):

-   `DO_TOKEN` — DigitalOcean API token (used by Terraform / DO provider)
-   `DOCR_REGISTRY` — container registry host (e.g. registry.digitalocean.com/your-reg)
-   `DOCR_USERNAME` — registry username (if used)
-   `DOCR_PASSWORD` — registry password (if used)
-   `DOCR_REPOSITORY` — repository path used in `app.yaml` (e.g. `statamic-app`)
-   `APP_KEY` — Laravel `APP_KEY`
-   `DB_HOST` — database host
-   `DB_PORT` — database port
-   `DB_DATABASE` — database name
-   `DB_USERNAME` — database user
-   `DB_PASSWORD` — database password
-   `REDIS_PASSWORD` — redis password (if applicable)
-   `REDIS_HOST` — redis host (if applicable)
-   `SPACES_KEY` — DigitalOcean Spaces access key
-   `SPACES_SECRET` — DigitalOcean Spaces secret key

Repository Variables (non-sensitive values; set in GitHub Repository Variables):

-   `REGION` — DigitalOcean region (example: `ams3`)
-   `APP_ENV` — application environment (example: `production`)
-   `APP_DEBUG` — `true` or `false` used in the workflow (may be set as a repo variable)
-   `LOG_LEVEL` — application log level (example: `info`)

Application `.env` keys that the App Platform `app.yaml` will expect (set in App Platform or via Terraform envs):

-   `APP_KEY`, `APP_ENV`, `APP_URL`, `ASSET_URL`
-   `DB_CONNECTION`, `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`
-   `CACHE_DRIVER`, `QUEUE_CONNECTION`, `SESSION_DRIVER`, `REDIS_HOST`, `REDIS_PASSWORD`

All sensitive credentials above must be stored in GitHub Secrets and referenced in the Actions workflow. Non-sensitive values may be stored in GitHub Repository Variables.

## Example CI variables used in the workflow

The workflow references the above secrets and variables via `${{ secrets.NAME }}` and `${{ vars.NAME }}`.

## Useful commands (copyable)

Create & push a tag to trigger CI:

```zsh
git tag v1.0.0
git push origin v1.0.0
```

Build image locally:

```zsh
docker build -f dockerfile -t local/statamic:latest .
```

Run Terraform locally (example):

```zsh
cd infra
terraform init
terraform plan -var "do_token=$DO_TOKEN" -var "app_image=$DOCR_REGISTRY/statamic-app:latest"
terraform apply -auto-approve -var "do_token=$DO_TOKEN" -var "app_image=$DOCR_REGISTRY/statamic-app:latest"
```

Run npm watcher locally:

```zsh
npm install
npm run watch
```

## File locations

-   CI workflow: `.github/workflows/BaDDigitalOcean.yml`
-   Terraform infra: `infra/`
-   Dockerfile used by CI: `./dockerfile`
-   App spec generated in CI: `app.yaml` (output of the terraform job)

---

This document is a usage-only how-to for the repository's CI/CD and infra automation. Edit values in GitHub Secrets/Variables as required for your environment.
