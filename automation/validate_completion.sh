#!/usr/bin/env bash
set -Eeuo pipefail

required_files=(
  "README.md"
  "OPERATIONS.md"
  "automation/README.md"
  "automation/validate_completion.sh"
  ".github/workflows/repository-completion-validation.yml"
  "apps/web"
  "skills"
  "design-systems"
)

for path in "${required_files[@]}"; do
  if [[ ! -e "$path" ]]; then
    echo "missing required operational artifact: $path" >&2
    exit 1
  fi
done

required_sections=(
  "Operational purpose"
  "Architecture"
  "Data model"
  "Automation hooks"
  "Figma and Canva reporting bridge"
  "Deployment path"
  "Maintenance path"
  "Recovery procedure"
  "Ownership and connector boundaries"
  "Completion criteria"
)

for section in "${required_sections[@]}"; do
  if ! grep -Fqi "## ${section}" OPERATIONS.md; then
    echo "OPERATIONS.md missing section: ${section}" >&2
    exit 1
  fi
done

grep -Fq "pnpm tools-dev" README.md || {
  echo "README no longer documents the local lifecycle entry point" >&2
  exit 1
}

grep -Fq "Vercel" README.md || {
  echo "README no longer documents the Vercel deployment lane" >&2
  exit 1
}

if grep -RInE '(sk-proj-|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,})' \
  OPERATIONS.md automation .github/workflows/repository-completion-validation.yml \
  --exclude='validate_completion.sh' 2>/dev/null; then
  echo "possible credential material detected in WSD operational artifacts" >&2
  exit 1
fi

bash -n automation/validate_completion.sh

echo "black-opps-open-design WSD completion artifacts validated"
