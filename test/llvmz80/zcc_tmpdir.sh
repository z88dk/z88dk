#!/bin/sh
set -eu

DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$DIR/test_env.sh"
ROOT=$(CDPATH= cd -- "$DIR/../.." && pwd)
WORKSPACE=$(CDPATH= cd -- "$ROOT/.." && pwd)
TMP_ROOT=${Z80_TEST_TMPDIR:-"$WORKSPACE/scratch/tmp"}
command -v "$ZCC" >/dev/null 2>&1 || {
    echo "SKIP: zcc not found"
    exit 0
}

mkdir -p "$TMP_ROOT"
WORK=$(mktemp -d "$TMP_ROOT/zcc-tmpdir.XXXXXX")
trap 'rm -rf "$WORK"' EXIT HUP INT TERM
mkdir "$WORK/tmp"

cat > "$WORK/main.c" <<'EOF'
int main(void) { return 0; }
EOF

cd "$WORK"
if ! TMPDIR="$WORK/tmp" "$ZCC" +cpm -compiler=sccz80 -v -E \
        "$WORK/main.c" -o "$WORK/main.i" >"$WORK/build.log" 2>&1; then
    cat "$WORK/build.log"
    echo "FAIL: zcc preprocessing failed with TMPDIR set"
    exit 1
fi

if ! grep -F "$WORK/tmp/tmpzcc" "$WORK/build.log" >/dev/null; then
    cat "$WORK/build.log"
    echo "FAIL: zcc did not place its work directory under TMPDIR"
    exit 1
fi

echo "PASS: zcc work files follow TMPDIR"
