#!/usr/bin/env bash
# SPDX-License-Identifier: PMPL-2.0-or-later
set -euo pipefail

if rg --files \
  -g '*.py' \
  -g '*.pyc' \
  -g '*.ts' \
  -g '*.tsx' \
  -g 'package.json' \
  -g 'node_modules/**' |
  rg .
then
  echo "prohibited Python/TypeScript/Node application source detected" >&2
  exit 1
fi

if rg -n '#include[[:space:]]*[<"]|@cImport|extern[[:space:]]+"c"' \
  zig affinescript idris2
then
  echo "prohibited C intermediary detected" >&2
  exit 1
fi

echo "prohibited-stack check passed"
