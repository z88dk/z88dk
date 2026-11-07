#!/bin/sh
# Long typed text: z88dk-ticks and z88dk-gdb copied it into fixed-size buffers
# and crashed. Each case runs in a session of its own, since a crash ends the
# session, and asserts the error (cut to the 127 characters of its buffer) and
# that the next command still ran.
# - print of a 120-character unknown name: its error message;
# - print of a 140- and a 5000-character word, a 140- and a 5000-character
#   history name ($...) and a 140-character function name: the lexer's copy and
#   the error message (a word of 5000 is what overflows the lexer's own
#   buffer by enough to crash);
# - a print line of 597 characters: cmd_print's copy;
# - z88dk-gdb (MI): a 40-digit command token, a 100-digit token inside
#   -interpreter-exec, a 900-character host name in -target-select and a
#   300-character -var-create name.
#
# usage: check_typed.sh <ticks-machine-flag> <bin> <map> <label>
set -u

BRK=19   # dbgvars.c break line (the `r = r + s;` statement; keep in sync)

label="$4"
ok=1

# rep <char> <n>: the character n times
rep() { printf "%${2}s" "" | tr ' ' "$1"; }

# check <what> <command> <error>: the command prints "Error: <error>", cut to
# 127 characters, and the next command, print a + b, runs
check() {
    what="$1" cmd="$2" want=$(printf '%s' "$3" | cut -c1-127)
    out=$(printf 'break dbgvars.c:%s\ncont\n%s\nprint a + b\nquit\n' "$BRK" "$cmd" \
          | z88dk-ticks -w 30 -d "$flag" -x "$map" "$bin" 2>&1)
    rc=$?
    got=$(printf '%s\n' "$out" | sed -n 's/.*Error: //p')
    [ "$got" = "$want" ] || { echo "  WRONG [$label] $what: error is <$got>, want <$want> (rc=$rc)"; ok=0; }
    printf '%s\n' "$out" | grep -qF '= <int16_t> 30' \
        || { echo "  MISSING [$label] $what: the next command, print a + b, did not run (rc=$rc)"; ok=0; }
}

flag="$1" bin="$2" map="$3"

u120="u$(rep z 119)"
w140="w$(rep z 139)"
w5000="w$(rep z 4999)"
h140="\$h$(rep z 139)"
h5000="\$h$(rep z 4998)"
f140="f$(rep z 139)"
check "unknown name of 120"   "print $u120"     "Cannot resolve symbol: $u120"
check "word of 140"           "print $w140"     "Cannot resolve symbol: $w140"
check "word of 5000"          "print $w5000"    "Cannot resolve symbol: $w5000"
check "history name of 140"   "print $h140"     "Cannot find item <$h140"
check "history name of 5000"  "print $h5000"    "Cannot find item <$h5000"
check "function name of 140"  "print $f140(1)"  "Unknown function call: $f140"

# a print line of 597 characters: 1 + 1 + ... + 1, 150 terms
sum=1 i=1
while [ $i -lt 150 ]; do sum="$sum + 1"; i=$((i + 1)); done
out=$(printf 'break dbgvars.c:%s\ncont\nprint %s\nprint a + b\nquit\n' "$BRK" "$sum" \
      | z88dk-ticks -w 30 -d "$flag" -x "$map" "$bin" 2>&1)
rc=$?
printf '%s\n' "$out" | grep -qF '$1 = <int32_t> 150' \
    || { echo "  MISSING [$label] print line of 597: \$1 = <int32_t> 150 (rc=$rc)"; ok=0; }
printf '%s\n' "$out" | grep -qF '$2 = <int16_t> 30' \
    || { echo "  MISSING [$label] print line of 597: the next command, print a + b, did not run (rc=$rc)"; ok=0; }

# z88dk-gdb, MI: no server is needed to read a command or a target address
mi() { printf '%s\n' "$@" | z88dk-gdb --interpreter=mi2 "$map" 2>&1; }
t40=$(rep 1 40) t100=$(rep 1 100) host=$(rep h 900)
out=$(mi "${t40}-gdb-version" '2-gdb-exit'); rc=$?
printf '%s\n' "$out" | grep -qxF "$(rep 1 31)^done" \
    || { echo "  MISSING [$label] MI token of 40 digits: its first 31 digits and ^done (rc=$rc)"; ok=0; }
printf '%s\n' "$out" | grep -qxF '2^exit' \
    || { echo "  MISSING [$label] MI token of 40 digits: the next command, -gdb-exit, did not run (rc=$rc)"; ok=0; }
out=$(mi "1-interpreter-exec mi2 \"${t100}-gdb-version\"" '2-gdb-exit'); rc=$?
printf '%s\n' "$out" | grep -qxF '2^exit' \
    || { echo "  MISSING [$label] -interpreter-exec token of 100 digits: the next command, -gdb-exit, did not run (rc=$rc)"; ok=0; }
out=$(mi "1-target-select remote ${host}:1" '2-gdb-exit'); rc=$?
printf '%s\n' "$out" | grep -qF '1^error,msg="target-select: cannot connect to' \
    || { echo "  MISSING [$label] -target-select host of 900: its error (rc=$rc)"; ok=0; }
printf '%s\n' "$out" | grep -qxF '2^exit' \
    || { echo "  MISSING [$label] -target-select host of 900: the next command, -gdb-exit, did not run (rc=$rc)"; ok=0; }
out=$(mi "1-var-create v$(rep q 299) * 1" '2-gdb-exit'); rc=$?
printf '%s\n' "$out" | grep -qxF '1^error,msg="variable name is too long\n"' \
    || { echo "  MISSING [$label] -var-create name of 300: its error (rc=$rc)"; ok=0; }
printf '%s\n' "$out" | grep -qxF '2^exit' \
    || { echo "  MISSING [$label] -var-create name of 300: the next command, -gdb-exit, did not run (rc=$rc)"; ok=0; }

if [ "$ok" != 1 ]; then
    echo "debuginfo typed FAIL ($label)"
    exit 1
fi
echo "debuginfo typed OK ($label)"
