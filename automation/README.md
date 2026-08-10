# WSD automation layer

This directory contains WSD repository-completion automation for Open Design.
It is separate from the product lifecycle and build tooling already present in
the repository.

## Current hook

`validate_completion.sh` verifies the WSD operational specification, the product
README, core product paths, the completion workflow, and the Figma/Canva bridge
contract documented in `OPERATIONS.md`.

## Inputs

The validator reads the checked-out repository tree. It does not require
network access, connector credentials, or product API keys.

## Outputs

A successful execution exits with status `0` and prints the completion result.
A failed execution exits nonzero and identifies the missing artifact or
operational section.

## Validation boundary

The validator does not replace application tests, `pnpm` checks, Vercel
deployment, Electron packaging, or connector execution. Those remain separate
product and connector lanes.

## Failure handling

Keep the repository completion state in `Validating` or `Blocked`, repair only
the failed WSD artifact, rerun validation, commit the correction, and refresh
Airtable and Drive only after the new commit exists.
