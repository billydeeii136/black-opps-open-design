# Black Opps Open Design operations

This repository is the design-generation and visual-application lane in the WSD
ecosystem. Its existing Open Design application architecture remains the product
source of truth. The WSD layer adds explicit completion, reporting, connector,
maintenance, and recovery contracts without replacing the upstream runtime.

## Operational purpose

The repository provides a local-first, web-deployable design engine that uses
installed coding-agent CLIs or a BYOK-compatible proxy to create design
artifacts. The product includes web and daemon components, design skills and
systems, SQLite persistence, local development tooling, Vercel deployment, and
optional Electron desktop packaging.

## Architecture

The operational architecture has five layers:

- **Web layer:** the browser UI and artifact preview surface under `apps/web/`.
- **Daemon/runtime layer:** the privileged local process that detects and runs
  supported agent CLIs against on-disk projects.
- **Design knowledge layer:** `skills/`, `design-systems/`, prompt templates,
  palettes, device frames, and critique/checklist assets.
- **Persistence and lifecycle layer:** SQLite project state plus `pnpm tools-dev`
  lifecycle commands and optional Electron packaging.
- **WSD completion layer:** `automation/` and a dedicated GitHub workflow that
  validate operational documentation and connector contracts independently from
  product tests.

## Data model

The product stores projects, conversations, messages, tabs, and saved templates
in SQLite at `.od/app.sqlite`, as documented by the existing repository README.
Design artifacts and project files remain on disk under the application's
project workspace.

The WSD control plane stores only repository-completion metadata externally:
repository identity, completion state, documentation status, automation status,
maintenance/recovery status, verified GitHub commit, mirror state, and next
action.

## Automation hooks

Existing product automation and lifecycle commands remain authoritative for
building, running, checking, inspecting, and packaging Open Design. The WSD
completion hook is `automation/validate_completion.sh`, invoked by
`.github/workflows/repository-completion-validation.yml`.

The WSD validator verifies completion artifacts and bridge contracts. It does
not replace `pnpm` product checks, application tests, Vercel deployment, or
Electron packaging.

## Figma and Canva reporting bridge

Figma and Canva are separate connector lanes. This repository may provide
validated design artifacts to those connectors, but connector execution must
remain explicit.

### Input contract

A reporting handoff must identify:

- the source repository and verified commit;
- the source artifact or project path;
- the intended destination connector;
- the requested reporting or design transformation;
- any required design-system or brand context.

### Output contract

The connector lane must return a concrete design/file identifier or an explicit
failure result. A connector operation is not complete merely because a handoff
file exists in this repository.

### Validation and failure handling

After a connector write, read back the created design or metadata before the
lane is marked complete. Connector failures remain isolated from the verified
GitHub repository state and are recorded as pending or blocked in Airtable.

## Deployment path

Open Design retains its documented product deployment lanes: local execution via
`pnpm tools-dev`, Vercel for the web layer, and packaged Electron desktop builds
where supported. The WSD repository-completion deployment path is separate:
GitHub commit, completion validation, Airtable status update, and verified
Google Drive mirror.

## Maintenance path

For repository conversion and ongoing maintenance:

1. inspect existing product architecture before changing WSD artifacts;
2. preserve existing agent, design-system, skill, runtime, and deployment
   behavior unless a verified defect requires correction;
3. validate WSD completion artifacts independently from product tests;
4. run the repository's own product checks for product-code changes;
5. commit real changes before updating external status;
6. mirror only verified completion evidence;
7. execute Figma or Canva writes only inside those connector lanes.

## Recovery procedure

If the WSD completion gate fails, preserve the last verified commit, keep the
Airtable record in `Validating` or `Blocked`, correct the specific WSD artifact,
rerun the validator, and refresh the Drive mirror after the new commit exists.

If product runtime or build behavior fails, use the repository's existing local
lifecycle and product diagnostics rather than treating the WSD completion
validator as a product repair tool. A Figma or Canva connector failure must not
roll back a valid GitHub commit.

## Ownership and connector boundaries

GitHub is the source of truth for repository files and commit history. Airtable
is the WSD completion-status plane. Google Drive is the verified mirror plane.
Figma and Canva own only the designs and reporting artifacts created inside
their respective connector lanes. Vercel or other deployment services own their
runtime deployment state. Cross-lane writes require explicit input, output,
authentication, validation, and failure-handling contracts.

## Completion criteria

The WSD repository gate closes when operational purpose, architecture, data
model, automation hooks, deployment, maintenance, recovery, and connector
boundaries are documented; the Figma/Canva bridge contract exists; the
executable validator passes; GitHub changes are committed; and completion
evidence is mirrored to Google Drive and verified by readback.
