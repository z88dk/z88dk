; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;

    MODULE  code_clib
    PUBLIC  conio_map_colour

    EXTERN  __CLIB_CONIO_NATIVE_COLOUR

conio_map_colour:
    ld      c,__CLIB_CONIO_NATIVE_COLOUR
    rr      c
    ret     c
    and     15
    ld      c,a
    ld      b,0
    ld      hl,table
    add     hl,bc
    ld      a,(hl)
    ret

    SECTION rodata_clib

    ; We set the palette to: black, blue, red, white
table:
    defb    0   ;BLACK -> BLACK
    defb    1   ;BLUE -> BLUE
    defb    2   ;GREEN -> RED
    defb    1   ;CYAN -> BLUE
    defb    2   ;RED -> RED
    defb    2   ;MAGENTA -> RED
    defb    2   ;BROWN -> RED
    defb    3   ;LIGHTGRAY -> WHITE
    defb    0   ;DARKGRAY -> BLACK
    defb    1   ;LIGHTBLUE -> BLUE
    defb    2   ;LIGHTGREEN -> RED
    defb    1   ;LIGHTCYAN -> BLUE
    defb    2   ;LIGHTRED -> RED
    defb    2   ;LIGHTMAGENTA -> RED
    defb    3   ;YELLOW -> WHITE
    defb    3   ;WHITE -> WHITE

