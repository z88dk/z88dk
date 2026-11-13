; Platform specific colour transformation: conio colours to the console's pens
; (a pen is the colour: 1 blue, 2 red, 4 green)
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
    defb    1                           ;BLUE
    defb    4                           ;GREEN
    defb    5                           ;CYAN
    defb    2                           ;RED
    defb    3                           ;MAGENTA
    defb    6                           ;BROWN (yellow)
    defb    7                           ;LIGHTGRAY
    defb    0                           ;DARKGRAY
    defb    1                           ;LIGHTBLUE
    defb    4                           ;LIGHTGREEN
    defb    5                           ;LIGHTCYAN
    defb    2                           ;LIGHTRED
    defb    3                           ;LIGHTMAGENTA
    defb    6                           ;YELLOW
    defb    7                           ;WHITE
