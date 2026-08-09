#!/bin/sh
# ravn/z88dk#59: -autoformat non-literal-format diagnostic.
#
# The -autoformat pass (on for -compiler=llvmz80 / -compiler=sdcc) scans
# STRING-LITERAL printf/scanf formats to auto-select classic converters. A
# format passed at runtime (a variable / ?: / call result) is invisible to it.
# In a MIXED translation unit -- one that ALSO has literal formats, which prune
# the converter table down to the literal-detected set -- a runtime format may
# need a converter no literal mentioned, which then silently mis-renders. This
# test pins the compile-time note that flags exactly that footgun, and pins its
# silence for the two safe shapes:
#   - pure-literal TU  (nothing runtime -> no note)
#   - pure-runtime TU  (no mask emitted, CRT keeps the broad default -> no note)
#
# Compile-only (-c): the note is emitted by zpragma during compilation, so no
# linker/emulator is needed. Skips if zcc/clang backend is unavailable.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

# Compile SRC with -compiler=llvmz80 and return zpragma's stderr (the notes).
build_log() {
    zcc +cpm -compiler=llvmz80 --math32 -O2 -c -o "$WORK/out.o" "$1" 2>&1 || true
}

# 1. MIXED TU: a literal "%d" (prunes the table) + a runtime format -> NOTE.
cat > "$WORK/mixed.c" <<'EOF'
#include <stdio.h>
int main(int argc, char **argv) {
    const char *fmt = (argc > 1) ? argv[1] : "%x";
    printf("count=%d\n", argc);
    printf(fmt, argc);
    return 0;
}
EOF
LOG=$(build_log "$WORK/mixed.c")
echo "$LOG" | grep -q "not a string literal" \
    || { echo "--- log ---"; echo "$LOG"; fail "mixed TU: expected non-literal note, got none"; }
# note must point at the user's call site (mixed.c), not an inlined header proto
echo "$LOG" | grep "not a string literal" | grep -q "mixed.c:5" \
    || { echo "--- log ---"; echo "$LOG"; fail "note mis-located (expected mixed.c:5)"; }

# 2. PURE-LITERAL TU: only literal formats -> NO note.
cat > "$WORK/lit.c" <<'EOF'
#include <stdio.h>
int main(void) { printf("a=%d b=%s\n", 1, "x"); return 0; }
EOF
LOG=$(build_log "$WORK/lit.c")
echo "$LOG" | grep -q "not a string literal" \
    && { echo "--- log ---"; echo "$LOG"; fail "pure-literal TU: unexpected note"; } || true

# 3. PURE-RUNTIME TU: only a runtime format, no literal -> NO note
#    (no mask emitted, so the CRT keeps its broad default converter table).
cat > "$WORK/run.c" <<'EOF'
#include <stdio.h>
int main(int argc, char **argv) { printf(argv[0], argc); return 0; }
EOF
LOG=$(build_log "$WORK/run.c")
echo "$LOG" | grep -q "not a string literal" \
    && { echo "--- log ---"; echo "$LOG"; fail "pure-runtime TU: unexpected note"; } || true

echo "PASS: #59 non-literal note fires for mixed TU, silent for pure-literal/pure-runtime"
