#!/usr/bin/env bash
# Bootstrap entry point: link base + any already-enabled use cases.
#   ./install.sh [--dry-run]
# Afterwards use `profile` (linked to ~/.local/bin) - see `profile --help`.
exec "$(cd "$(dirname "$0")" && pwd -P)/bin/profile" link "$@"
