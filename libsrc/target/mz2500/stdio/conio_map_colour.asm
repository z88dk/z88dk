; Platform specific colour transformation: conio colours to the pixel values (blue 1, red 2, green 4, intensity 8)
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;

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
    defb    6                           ;BROWN
    defb    7                           ;LIGHTGRAY
    defb    8                           ;DARKGRAY
    defb    9                           ;LIGHTBLUE
    defb    12                          ;LIGHTGREEN
    defb    13                          ;LIGHTCYAN
    defb    10                          ;LIGHTRED
    defb    11                          ;LIGHTMAGENTA
    defb    14                          ;YELLOW
    defb    15                          ;WHITE
