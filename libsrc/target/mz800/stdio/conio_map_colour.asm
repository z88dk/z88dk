; Platform specific colour transformation: conio colours to the console's pens (0 black, 1 red, 2 green, 3 white with mz800_gfx_init's palette; the nearest)
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f

    MODULE  code_clib
    PUBLIC  conio_map_colour

    EXTERN  __CLIB_CONIO_NATIVE_COLOUR

conio_map_colour:
    ld      c, __CLIB_CONIO_NATIVE_COLOUR
    rr      c
    ret     c

    and     15
    ld      c, a
    ld      b, 0
    ld      hl, table
    add     hl, bc
    ld      a, (hl)
    ret

    SECTION rodata_clib
table:
    defb    0                           ;BLACK
    defb    1                           ;BLUE (the red pen)
    defb    2                           ;GREEN
    defb    2                           ;CYAN
    defb    1                           ;RED
    defb    1                           ;MAGENTA
    defb    2                           ;BROWN
    defb    3                           ;LIGHTGRAY
    defb    0                           ;DARKGRAY
    defb    1                           ;LIGHTBLUE
    defb    2                           ;LIGHTGREEN
    defb    3                           ;LIGHTCYAN
    defb    1                           ;LIGHTRED
    defb    1                           ;LIGHTMAGENTA
    defb    3                           ;YELLOW
    defb    3                           ;WHITE
