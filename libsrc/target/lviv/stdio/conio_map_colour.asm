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
    ld      c, __CLIB_CONIO_NATIVE_COLOUR
    dec     c
    ret     z

    and     15
    ld      c, a
    ld      b, 0
    ld      hl, table
    add     hl, bc
    ld      a, (hl)
    ret

    SECTION rodata_clib
    ; On the Lviv: 0 = black, 1 = BLUE, 2 = GREEN, 3 = RED
table:
    defb    0                   ;BLACK -> BLACK
    defb    1                   ;BLUE -> BLUE
    defb    2                   ;GREEN -> GREEN
    defb    1                   ;CYAN -> BLUE
    defb    3                   ;RED -> RED
    defb    3                   ;MAGENTA->RED
    defb    3                   ;BROWN->RED
    defb    2                   ;LIGHTGRAY->GREEN
    defb    2                   ;DARKGRAY->GREEN
    defb    1                   ;LIGHTBLUE -> BLUE
    defb    2                   ;LIGHTGREEN -> GREEN
    defb    1                   ;LIGHTCYAN -> BLUE
    defb    3                   ;LIGHTRED -> RED
    defb    3                   ;LIGHTMAGENTA->RED
    defb    2                   ;YELLOW -> GREEN
    defb    2                   ;WHITE -> GREEN
