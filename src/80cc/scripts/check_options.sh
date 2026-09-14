#!/bin/bash
# OPTIONS.md must describe every --opt-disable / IR_OFF name, and no others.
# The AST names are a separate bitmask in main.c, listed there.
cd "$(dirname "$0")/.." || exit 2        # run against src/80cc, not scripts/
code=$(grep -rhoE 'opt_disabled\("[a-z0-9-]+"\)' ir_alloc.c ir_lower.c ir_opt.c ir_slots.c \
        ast_opt.c ./*.inc.c 2>/dev/null | sed 's/.*("//;s/").*//' | LC_ALL=C sort -u)
doc=$(grep -oE '^\| `[a-z0-9-]+`' OPTIONS.md | tr -d '|` ' | LC_ALL=C sort -u)
rc=0
miss=$(comm -23 <(echo "$code" | LC_ALL=C sort) <(echo "$doc" | LC_ALL=C sort))
if [ -n "$miss" ]; then echo "FAIL: in the code, not in OPTIONS.md:"; echo "$miss" | sed 's/^/  /'; rc=1; fi
# a documented name that no longer exists (AST names are exempt — they live in main.c)
ast="fold prop simplify typecheck compoundify strength-reduce cse cse-synth licm dse dead-code thread-jumps demote-poststep loop-reverse"
extra=$(comm -13 <(echo "$code" | LC_ALL=C sort) <(echo "$doc" | LC_ALL=C sort))
for n in $extra; do case " $ast " in *" $n "*) ;; *) echo "FAIL: in OPTIONS.md, not in the code: $n"; rc=1;; esac; done
[ $rc = 0 ] && echo "options OK: $(echo "$code" | wc -l) names, all documented"
exit $rc
