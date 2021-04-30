; void bordercolor(int c) __z88dk_fastcall;
;
;

    SECTION code_clib
    PUBLIC  bordercolor
    PUBLIC  _bordercolor

    EXTERN  conio_map_colour
    EXTERN  zx_border

bordercolor:
_bordercolor:
    ld      a,l
    call    conio_map_colour
    ld      l,a
    jp      zx_border
