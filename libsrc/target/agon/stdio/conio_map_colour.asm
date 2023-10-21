; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;
; These colours work in both 16 and 64 colour modes
; Thanks to RobertK for mapping them
;
; Palettes are defined here: https://gist.github.com/astralaster/33a7c4ca85380925b306b2df37afbd19
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

table:
        defb    $0      ;BLACK -> (#00 00 00)
        defb    12      ;BLUE -> (#00 00 ff)
        defb    10      ;GREEN -> (#00 ff 00)
        defb    14      ;CYAN -> (#00 ff ff)
        defb    9       ;RED -> (#ff 00 00)
        defb    13      ;MAGENTA -> (#ff 00 ff)
        defb    3       ;BROWN -> (#aa aa 00)
        defb    7       ;LIGHTGRAY -> (#aa aa aa)
        defb    8       ;DARKGRAY -> (#55 55 55)
        defb    4       ;LIGHTBLUE -> (#00 00 aa)
        defb    2       ;LIGHTGREEN -> (#00 aa 00) 
        defb    6       ;LIGHTCYAN -> (#00 aa aa)
        defb    1       ;LIGHTRED -> (#aa 00 00)
        defb    5       ;LIGHTMAGENTA -> (#aa 00 aa)
        defb    11      ;YELLOW -> (#ff ff 00)
        defb    15      ;WHITE -> (#ff ff ff)
