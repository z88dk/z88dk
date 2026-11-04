#!/bin/sh
# Drive z88dk-ticks over enums_a.c + enums_b.c (-debug) and assert that enum
# objects print their enumerator and that enumerator names are int constants.
# The files define different enums of the same name (colour), anonymous enums
# with the same generated tag, and a file static of the same name; they share
# the enum of enums.h. Two functions of enums_a.c have a static of the same name
# (st) and different enums. The unknown-name error paths are check_exprerr.sh's.
#
# usage: check_enums.sh <ticks-machine-flag> <bin> <map> <label>
set -u

LINE_A=24    # enums_a.c: fa()'s return    (keep in sync)
LINE_A2=31   # enums_a.c: fa2()'s return
LINE_B=13    # enums_b.c: fb()'s return
LINE_C=7     # enums_c.c: fc()'s return

cmds=""   # what ticks is fed
want=""   # one check per line: <kind> <text>; "@" in a v text splits it in two parts
n=0       # the history number of the next value

cmd()  { cmds="$cmds$1
"; }
# val <expected> <expression>: "print <expression>" gives "$<n> = <expected>"
val()  { n=$((n + 1)); cmd "print $2"; want="$want""v $n $1
"; }
# line <expected> <command>: the command prints this line
line() { cmd "$2"; want="$want""l $1
"; }

# fa(): enums_a.c defines colour { RED, GREEN = 5, BLUE }
cmd "break enums_a.c:$LINE_A"; cmd cont
val '<enum colour> BLUE'               ga_col
val '<enum shared> SH_TWO'             ga_sh
val '<enum 0__anonenum_4_0> ANA'       ga_anon
val '<enum colour[]> 0x@[2] = { [0] = RED, [1] = BLUE }' ga_arr
val '<enum colour> BLUE'               '*ga_ptr'
val '<enum colour*> 0x@(BLUE)'         ga_ptr
val '<enum colour> GREEN'              s_col
val '<enum colour> BLUE'               st
val '<enum colour> BLUE'               param
val '<enum colour> BLUE'               loc
val '<int16_t> 23'                     plain
val '<int16_t> 0'                      RED
val '<int16_t> 6'                      BLUE
val '<int16_t> 2'                      SH_TWO
val '<int16_t> -3'                     ANA
val '<int16_t> 300'                    ANB
val '<int16_t> 1'                      CYAN
line 'type = enum colour'              'whatis ga_col'
line 'type = enum colour'              'whatis param'
line 'type = int16_t'                  'whatis ga_int'
line 'type = int16_t'                  'whatis plain'
val '<int16_t> 6'                      ga_int
# a typedef of an enum is that enum; integers declared next to it are not
val '<enum colour> GREEN'              ga_tdef
line 'type = enum colour'              'whatis ga_tdef'
val '<int16_t> 6'                      ga_ienum
line 'type = int16_t'                  'whatis ga_ienum'
val '<int32_t> 6'                      ga_long
val '<uint16_t> 6'                     ga_uns
line 'type = int32_t'                  'whatis ga_long'
line 'type = uint16_t'                 'whatis ga_uns'
# arithmetic and a cast give an integer; an enum keeps its name when copied
val '<int16_t> 0'                      'ga_col - BLUE'
val '<int16_t> 6'                      'ga_col + 0'
val '<int16_t> 6'                      'ga_col * 1'
val '<int16_t> 6'                      'ga_col / 1'
val '<int16_t> 6'                      '(int)ga_col'
val '<enum colour> BLUE'               '(ga_col)'
val '<enum colour> BLUE'               'ga_arr[1]'
val '<enum colour*> 0x@(BLUE)'         '&ga_col'
val '<enum colour> BLUE'               '$1'
val '<int16_t> 6'                      '$1 + 0'
line '  <enum colour>param = BLUE'     'info locals'
line '  <enum colour>loc = BLUE'       'info locals'
line '  <int16_t>plain = 23'           'info locals'

# fa2(): its static st is of another enum than fa()'s
cmd "break enums_a.c:$LINE_A2"; cmd cont
val '<enum shared> SH_TWO'             st
val '<enum colour> GREEN'              s_col
val '<int16_t> 0'                      RED

# fb(): the other module. Its colour has other values and its own RED
cmd "break enums_b.c:$LINE_B"; cmd cont
val '<enum colour> MAGENTA'            st
val '<enum colour> RED'                s_col
val '<enum colour> MAGENTA'            gb_col
val '<enum shared> SH_ONE'             gb_sh
val '<enum 0__anonenum_4_0> BNB'       gb_anon
val '<enum 0__anonenum_4_0> ANA'       ga_anon
val '<enum colour> BLUE'               ga_col
val '<int16_t> 10'                     RED
val '<int16_t> 11'                     MAGENTA
val '<int16_t> 8'                      BNB
val '<int16_t> -3'                     ANA
val '<int16_t> 6'                      BLUE
# fc(): a module with no enums. A name two enums define resolves to the smallest
# F<file>$<tag> key, whatever order the records were read in
cmd "break enums_c.c:$LINE_C"; cmd cont
val '<int16_t> 0'                      RED
val '<int16_t> 1'                      SH_ONE
val '<int16_t> 1'                      CYAN
cmd quit

out=$(printf '%s' "$cmds" | z88dk-ticks -w 30 -d "$1" -x "$3" "$2" 2>&1)

label="$4"
ok=1
while IFS= read -r w; do
    [ -n "$w" ] || continue
    kind=${w%% *}; rest=${w#* }
    if [ "$kind" = v ]; then
        num=${rest%% *}; text=${rest#* }
        pre=${text%%@*}; post=${text#*@}
        [ "$pre" = "$text" ] && post=""
        got=$(printf '%s\n' "$out" | grep -F "\$$num = " | head -n 1)
        case "$got" in
            *"\$$num = $pre"*"$post"*) ;;
            *) echo "  MISSING [$label]: \$$num = $text    (got: ${got:-nothing})"; ok=0 ;;
        esac
    else
        printf '%s\n' "$out" | grep -qF "$rest" || { echo "  MISSING [$label]: $rest"; ok=0; }
    fi
done <<EOT
$want
EOT

# Malformed N: and E: records are warned about and skipped: an N: with no "[",
# one cut short, one cut inside its list (two shapes), an E: with no tag.
# Well-formed ones too, with a drive letter in the file name (the key ends at the
# last ':'), the E: coming after the S: of its object (the real map has E: first).
# The map is the real one plus those records.
bad="$3.bad"
cp "$3" "$bad"
tail=$(grep -m 1 '__CDBINFO__' "$3" | sed 's/^[^ ]* = / = /')
for rec in 'N:Fbad.c$nolist({2}SI:S)' 'N:Fbad.c$cut({2}SI:S' 'N:Fbad.c$cut2({2}SI:S)[(QA$7)(QB$5' 'N:Fbad.c$cut3({2}SI:S)[(QC$9' 'E:G$nosuch$0_0$0({2}SEnocolon),E,0,0' 'N:FC:/inc/w.h$wc({2}SI:S)[(W6$6)(W7$7)]' 'E:G$ga_int$0_0$0({2}SEFC:/inc/w.h$wc:S),E,0,0'; do
    printf '%s\n' "$rec" | awk -v tail="$tail" '
        BEGIN { for (i = 0; i < 256; i++) ord[sprintf("%c", i)] = i }
        { out = ""
          for (i = 1; i <= length($0); i++) { c = substr($0, i, 1)
              out = out (c ~ /[A-Za-z]/ ? c : sprintf("_%02x", ord[c])) }
          print "__CDBINFO__" out tail }' >> "$bad"
done
out=$(printf 'break enums_b.c:%s\ncont\nprint ga_col\nprint RED\nprint ga_int\nprint QB\nquit\n' "$LINE_B" \
      | z88dk-ticks -w 30 -d "$1" -x "$bad" "$2" 2>&1)
rm -f "$bad"
[ "$(printf '%s\n' "$out" | grep -cF 'Warning: could not add debug info on enum.')" = 4 ] \
    || { echo "  MISSING [$label]: four 'could not add debug info on enum.' warnings, for the N: records"; ok=0; }
[ "$(printf '%s\n' "$out" | grep -cF 'Warning: could not add debug info on enum object.')" = 1 ] \
    || { echo "  MISSING [$label]: one 'could not add debug info on enum object.' warning, for the E: record"; ok=0; }
printf '%s\n' "$out" | grep -qF '$1 = <enum colour> BLUE' || { echo "  MISSING [$label]: \$1 = <enum colour> BLUE (malformed records in the map)"; ok=0; }
printf '%s\n' "$out" | grep -qF '$3 = <enum wc> W6' || { echo "  MISSING [$label]: \$3 = <enum wc> W6 (a drive letter in the key; an E: after its S:)"; ok=0; }
printf '%s\n' "$out" | grep -qF 'Cannot resolve symbol: QB' || { echo "  MISSING [$label]: QB of a record cut inside its list is not an enumerator"; ok=0; }
printf '%s\n' "$out" | grep -qF '$2 = <int16_t> 10' || { echo "  MISSING [$label]: \$2 = <int16_t> 10 (malformed records in the map)"; ok=0; }

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo enums FAIL ($label)"
    exit 1
fi
echo "debuginfo enums OK ($label)"
