#!/bin/sh
# Drive z88dk-ticks over floats_a.c + floats_b.c + floats_n.c (-debug) and assert
# that floats print their value, each in the format of the module that defines it.
# Every module writes __fp_mode, __fp_exponent_bias and __fp_mantissa_size; a float
# behind a pointer, or a member, takes the format of the pointer's or the struct's.
#
# usage: check_floats.sh <ticks-machine-flag> <bin> <map> <label> <format>
#   format: math48 (z80, 6 bytes), math32 (ieee, 4 bytes), z80bias129 (z80 with
#           an exponent bias of 129 and a 4-byte mantissa), mbf32, mbf40, mbf64,
#           bbc and z88 (both the z88 format), dai32 (the AM9511's),
#           mixed (floats_a.c --math48, floats_b.c --math32),
#           nowidth (floats_p.c --math48: no record gives a float's width),
#           z88int (floats_i.c --math-bbc: the z88 integer form)
set -u

LINE=23     # floats_a.c: main()'s return (keep in sync)

label="$4"
map="$3"
ok=1
first=""
want() {
    printf '%s\n' "$out" | grep -qF "$1" || { echo "  MISSING [$label]: $1"; ok=0; }
}
# val <n> <text>: the n-th value printed is text
val() { want "\$$1 = $2"; }
# fmt <module> <mode> <bias> <mantissa>: the module's locals in the map
fmt() {
    for s in "__fp_mode $2" "__fp_exponent_bias $3" "__fp_mantissa_size $4"; do
        set -- "$1" $s
        grep -q "^$2 *= \$$3 ; const, local, , $1, " "$map" || { echo "  MISSING [$label]: $2 = \$$3 of $1 in the map"; ok=0; }
    done
}

# doctor "<name> <value>[;...]|<expected>"...: print ga_f with floats_a_c's symbols
# changed; <expected> is "=<value>" or the refusal's "(...)"
doctor() {
    bad="$map.bad"
    for b in "$@"; do
        edits=${b%%|*}; msg=${b#*|}
        cp "$map" "$bad"
        old_ifs=$IFS; IFS=';'
        for e in $edits; do
            sed -i "s/^\(${e% *} *= [$]\)[0-9A-F]*\( ; const, local, , floats_a_c,\)/\1${e#* }\2/" "$bad"
        done
        IFS=$old_ifs
        out=$(printf 'print ga_f\nquit\n' | z88dk-ticks -w 30 -d "$tflag" -x "$bad" "$bin" 2>&1)
        case "$msg" in
            =*) want "\$1 = <float> ${msg#=}" ;;
            *)  want "Error: Unsupported float format $msg" ;;
        esac
    done
    rm -f "$bad"
}
tflag="$1"; bin="$2"
# A pointer cast keeps the module of the pointer it casts: *(float*)&gb_f is gb_f's
out=$(printf 'break floats_a.c:%s\ncont\nprint ga_f\nprint ga_arr\nprint ga_arr[2]\nprint *ga_ptr\nprint ga_st.f\nprint gb_f\nprint ga_f + 1\nprint sizeof(ga_f)\nprint sizeof(ga_arr)\nprint ga_int\nprint *(float*)&ga_f\nprint *(float*)&gb_f\nprint ga_pay\nprint gb_head.p->v\nprint gb_p0[1]\nprint *(gb_p0 + 1)\nprint gb_ptr[-1]\nprint ga_tail.n\nprint gb_pay\nprint gb_tail.n\nprint sizeof(gb_tail)\nprint *(gb_ptr - 1)\nprint gb_wrap.k\nprint sizeof(gb_wrap)\nprint sizeof(gb_tails)\nquit\n' "$LINE" \
      | z88dk-ticks -w 30 -d "$1" -x "$3" "$2" 2>&1)

case "$5" in
    math48|math32|z80bias129|mbf32|mbf40|mbf64|bbc|z88|dai32)
        case "$5" in
            math48)     size=6; f="0000 0080 0005" ;;
            z80bias129) size=6; f="0000 0081 0004" ;;
            math32)     size=4; f="0001 007E 0003" ;;
            mbf32)      size=4; f="0002 0080 0003" ;;
            mbf40)      size=6; f="0003 0080 0004" ;;
            mbf64)      size=8; f="0004 0080 0007" ;;
            bbc|z88)    size=6; f="0005 007F 0004" ;;
            dai32)      size=4; f="0006 0000 0003" ;;
        esac
        for m in floats_a_c floats_b_c floats_n_c; do fmt $m $f; done
        val 1 '<float> -3.250000'
        want '[3] = { [0] = 1.500000, [1] = -2.000000, [2] = 100.000000 }'
        val 3 '<float> 100.000000'
        val 4 '<float> -2.000000'
        val 5 '<float> 0.500000'
        val 6 '<float> 1024.000000'
        val 7 '<float> -2.250000'
        val 8 "<int16_t> $size"
        val 9 "<int16_t> $((size * 3))"
        val 10 '<int16_t> 1027'
        val 11 '<float> -3.250000'
        val 12 '<float> 1024.000000'
        val 13 '<struct pay> {v=-0.750000}'
        val 14 '<float> 2.500000'
        val 15 '<float> -16.000000'
        val 16 '<float> -16.000000'
        val 17 '<float> 8.000000'
        val 18 '<int16_t> 77'
        val 19 '<struct pay> {v=2.500000}'
        val 20 '<int16_t> 88'
        val 21 "<int16_t> $((size + 2))"
        val 22 '<float> 8.000000'
        val 23 '<int16_t> 700'
        val 24 "<int16_t> $((size + 4))"
        val 25 "<int16_t> $(((size + 2) * 2))"
        first="$out"
        # A map without the symbols (zsdcc, older compilers): a float is IEEE, so a
        # 6-byte one is not read
        case "$5" in
            math48|math32|z80bias129)
                nofp="$map.nofp"
                grep -v '^__fp_' "$map" > "$nofp"
                out=$(printf 'print ga_f\nprint *ga_ptr\nquit\n' | z88dk-ticks -w 30 -d "$1" -x "$nofp" "$2" 2>&1)
                rm -f "$nofp"
                if [ "$size" = 4 ]; then
                    want '$1 = <float> -3.250000'
                    want '$2 = <float> -2.000000'
                else
                    # *ga_ptr too: its record gives no width, the other records give 6
                    [ "$(printf '%s\n' "$out" | grep -cF 'Error: Unsupported float format (6 bytes, and no __fp_mode)')" = 2 ] \
                        || { echo "  MISSING [$label]: ga_f and *ga_ptr not read without the symbols"; ok=0; }
                fi
                ;;
        esac
        # What the decoder cannot handle is refused: an unknown __fp_mode, a mantissa
        # that leaves no room for the exponent, z88's after its offset. z88 with a
        # 4-byte mantissa reads the z80 bytes of -3.25 (00 00 00 00 d0 82) from the
        # second byte: -3.25 again, which it is only with the offset. The AM9511's
        # format takes its bias from the map, and only a 3-byte mantissa.
        case "$5" in
            math48) doctor "__fp_mode 0007|(6 bytes, __fp_mode 7)" "__fp_mantissa_size 0006|(6 bytes, z80)" \
                           "__fp_mode 0005|(6 bytes, z88)" "__fp_mode 0005;__fp_mantissa_size 0004|=-3.250000" ;;
            dai32)  doctor "__fp_exponent_bias 0001|=-1.625000" "__fp_mantissa_size 0004|(4 bytes, am9511)" ;;
        esac
        ;;
    z88int)
        out=$(printf 'print *gi_neg\nprint *gi_pos\nprint gi_zero\nquit\n' | z88dk-ticks -w 30 -d "$1" -x "$map" "$2" 2>&1)
        want '$1 = <float> -2.000000'
        want '$2 = <float> 2.000000'
        want '$3 = <float> 0.000000'
        # The integer form needs the four mantissa bytes
        first="$out"
        sed "s/^\(__fp_mantissa_size *= [$]\)[0-9A-F]*\( ; const, local, , floats_i_c,\)/\10003\2/" "$map" > "$map.bad"
        out=$(printf 'print *gi_pos\nquit\n' | z88dk-ticks -w 30 -d "$1" -x "$map.bad" "$2" 2>&1)
        rm -f "$map.bad"
        want 'Error: Unsupported float format (a z88 integer with a 3-byte mantissa)'
        ;;
    nowidth)
        # The width is the format's; without the symbols nothing gives it, so refuse
        out=$(printf 'print *gp_ptr\nquit\n' | z88dk-ticks -w 30 -d "$1" -x "$map" "$2" 2>&1)
        want '$1 = <float> -3.250000'
        nofp="$map.nofp"
        grep -v '^__fp_' "$map" > "$nofp"
        first="$out"
        out=$(printf 'print *gp_ptr\nquit\n' | z88dk-ticks -w 30 -d "$1" -x "$nofp" "$2" 2>&1)
        rm -f "$nofp"
        want 'Error: Unsupported float format (no width, and no __fp_mode)'
        ;;
    mixed)
        # Each float in its own module's format: ga_* z80, gb_* IEEE. floats_n.c, with
        # no float, is built with the link's --math48
        fmt floats_a_c 0000 0080 0005
        fmt floats_b_c 0001 007E 0003
        fmt floats_n_c 0000 0080 0005
        val 1 '<float> -3.250000'
        want '[3] = { [0] = 1.500000, [1] = -2.000000, [2] = 100.000000 }'
        val 3 '<float> 100.000000'
        val 4 '<float> -2.000000'
        val 5 '<float> 0.500000'
        val 6 '<float> 1024.000000'
        val 7 '<float> -2.250000'
        val 8 '<int16_t> 6'
        val 10 '<int16_t> 1027'
        val 11 '<float> -3.250000'
        val 12 '<float> 1024.000000'
        # A pointer's stride is its module's: gb_p0 and gb_ptr point at 4-byte floats
        val 14 '<float> -16.000000'                                     # gb_p0[1]
        val 15 '<float> -16.000000'                                     # *(gb_p0 + 1)
        val 16 '<float> 8.000000'                                       # gb_ptr[-1]
        val 17 '<int16_t> 77'                                           # ga_tail.n
        # struct pay and struct tail are in floats.h, so both modules have T: records of
        # one key, and the last read, floats_a.c's (6-byte floats), is kept: every member
        # of floats_b.c's objects, a float's or not, and their sizeof, are refused
        val 13 '<struct pay> {v=-0.750000}'
        val 18 '<struct pay> {v=<error:Unsupported float format (struct pay is laid out with 6-byte floats)>}'
        want 'Error: Unsupported float format (struct pay is laid out with 6-byte floats)'      # gb_head.p->v
        want 'Error: Unsupported float format (struct tail is laid out with 6-byte floats)'     # gb_tail.n
        want 'Error: Can not obtain sizeof: Unsupported float format (struct tail is laid out with 6-byte floats)'
        val 19 '<float> 8.000000'                                       # *(gb_ptr - 1)
        # struct wrap holds its float only in a struct member; gb_tails is an array of
        # struct tail: both are refused as well
        want 'Error: Unsupported float format (struct wrap is laid out with 6-byte floats)'     # gb_wrap.k
        want 'Error: Can not obtain sizeof: Unsupported float format (struct wrap is laid out with 6-byte floats)'
        [ "$(printf '%s\n' "$out" | grep -cF 'Error: Can not obtain sizeof: Unsupported float format (struct tail is laid out with 6-byte floats)')" = 2 ] \
            || { echo "  MISSING [$label]: sizeof(gb_tail) and sizeof(gb_tails) refused"; ok=0; }
        printf '%s\n' "$out" | grep -qE '\$(2[0-9]) = ' && { echo "  WRONG [$label]: a value printed for gb_tail.n, gb_wrap.k or a sizeof"; ok=0; }
        ;;
esac

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    [ -n "$first" ] && echo "$first"
    echo "$out"
    echo "debuginfo floats FAIL ($label)"
    exit 1
fi
echo "debuginfo floats OK ($label)"
