#!/bin/bash
# Invariant 3, BOTH directions: every env gate in the source has a row in
# DESIGN_INDEX.md, and every gate named in a LIVE section of that file still
# exists in the source. The second direction is the one that rotted — seven rows
# named gates deleted in earlier sweeps, so the index over-promised for months.
#
# The ranging-arc section deliberately names REMOVED gates (that is its point),
# so it is excluded from the "must still exist" test.
cd "$(dirname "$0")/.." || exit 2
rc=0

src=$(grep -rhoE 'getenv\("IR_[A-Z0-9_]+"\)' ./*.c ./*.inc.c 2>/dev/null \
      | sed 's/.*("//;s/").*//' | grep -v '^IR_OFF$' | LC_ALL=C sort -u)
# IR_OFF is the opt-out registry's front door, documented under "Opt-outs",
# not a gate with a row of its own. check_options.sh owns that registry.

# Sections that list gates expected to be LIVE.
live=$(awk '/^### Verifiers/{f=1} /^### The ranging arc/{f=0}
            /^### Debug output/{f=1} /^### Probes with a live question/{f=1}
            /^### Numeric knobs/{f=1} /^## Documents/{f=0} f' DESIGN_INDEX.md \
       | grep -oE 'IR_[A-Z0-9_]+' | grep -v '^IR_OFF$' | LC_ALL=C sort -u)

miss=$(comm -13 <(echo "$live") <(echo "$src"))
if [ -n "$miss" ]; then
    echo "FAIL: env gate in the source with no row in DESIGN_INDEX.md:"
    echo "$miss" | sed 's/^/  /'; rc=1
fi

dead=$(comm -23 <(echo "$live") <(echo "$src"))
if [ -n "$dead" ]; then
    echo "FAIL: DESIGN_INDEX.md lists a gate that no longer exists:"
    echo "$dead" | sed 's/^/  /'; rc=1
fi

[ $rc = 0 ] && echo "gates OK: $(echo "$live" | wc -l) listed live, all present"
exit $rc
