# SPDX-License-Identifier: PMPL-2.0-or-later
set shell := ["bash", "-uc"]
set positional-arguments := true

zig_env := "ZIG_GLOBAL_CACHE_DIR=/tmp/authority-watch-zig-global ZIG_LOCAL_CACHE_DIR=.zig-cache"

default:
    @just --list --unsorted

doctor:
    @printf '%-18s %s\n' "zig" "$(zig version)"
    @printf '%-18s %s\n' "idris2" "$(idris2 --version)"
    @printf '%-18s %s\n' "just" "$(just --version)"
    @printf '%-18s %s\n' "mode" "offline manual precision core"
    @printf '%-18s %s\n' "hexadeca" "BLOCKED: canonical repository not located"

build:
    {{zig_env}} zig build

run: build
    ./zig-out/bin/authority-watch status

ingest source: build
    ./zig-out/bin/authority-watch ingest "{{source}}"

observations:
    @echo "No production observation store is committed; use an operator state directory."

diff observation_a observation_b:
    @echo "Diff request staged for {{observation_a}} -> {{observation_b}}; persistent store integration is pending."

triage:
    @echo "No canonical review ledger configured; no state changed."

review change_id:
    @echo "Review {{change_id}} requires an authenticated append-only operator ledger."

impact change_id:
    @echo "Impact query {{change_id}} requires an ingested change candidate."

build-bundle:
    @echo "Refusing to build a bundle without an approved review record and configured signer."
    @false

verify-bundle path:
    @echo "Bundle verification boundary reserved for signed canonical manifests: {{path}}"

publish-local:
    @echo "Refusing publication: no approved, tested and signed bundle was supplied."
    @false

export-review-pack:
    @echo "No review ledger configured; nothing exported."

freshness profile="uk-insolvency": build
    ./zig-out/bin/authority-watch freshness "{{profile}}"

typecheck:
    @echo "AffineScript contracts use syntax confirmed at the inspected upstream revision."
    cd idris2 && idris2 --build authority-watch.ipkg

test:
    {{zig_env}} zig build test

lint:
    zig fmt --check build.zig zig
    ./tools/check-prohibited-stack.sh

format:
    zig fmt build.zig zig

check: lint typecheck test

clean:
    rm -rf zig-out .zig-cache idris2/build
