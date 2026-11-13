;
;	Samsung SPC-1500 PSG routines
;
;	int get_psg(int reg);
;
;	Get a PSG register.
;

    SECTION code_clib
    PUBLIC  get_psg
    PUBLIC  _get_psg

get_psg:
_get_psg:
    ld      bc, $1c00
    out     (c), l
    ld      b, $1b
    in      a, (c)
    ld      l, a
    ret
