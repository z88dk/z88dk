; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;

    SECTION code_video_vdp
    PUBLIC  __tms9918_map_colour


    EXTERN  __CLIB_CONIO_NATIVE_COLOUR

__tms9918_map_colour:
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

    SECTION rodata_video_vdp
table:
IF FORsms
    defb    $1                          ;BLACK -> BLACK
    defb    $5                          ;BLUE -> LIGHT BLUE
    defb    $3                          ;GREEN -> LIGHT GREEN
    defb    $7                          ;CYAN -> CYAN
    defb    $9                          ;RED -> LIGHT RED
    defb    $d                          ;MAGENTA -> MAGENTA
    defb    $6                          ;BROWN -> DARK RED
    defb    $a                          ;LIGHTGRAY -> DARK YELLOW
    defb    $e                          ;DARKGRAY -> GRAY
    defb    $4                          ;LIGHTBLUE -> DARK BLUE
    defb    $c                          ;LIGHTGREEN -> MEDIUM GREEN
    defb    $7                          ;LIGHTCYAN -> CYAN
    defb    $8                          ;LIGHTRED -> MEDIUM RED
    defb    $d                          ;LIGHTMAGENTA -> MAGENTA
    defb    $b                          ;YELLOW -> LIGHT YELLOW
    defb    $f                          ;WHITE -> WHITE
ELSE
    defb    $1                          ;BLACK -> BLACK
    defb    $4                          ;BLUE -> DARK BLUE
    defb    $c                          ;GREEN -> MEDIUM GREEN
    defb    $7                          ;CYAN -> CYAN
    defb    $8                          ;RED -> MEDIUM RED
    defb    $d                          ;MAGENTA -> MAGENTA
    defb    $6                          ;BROWN -> DARK RED
    defb    $b                          ;LIGHTGRAY -> LIGHT YELLOW
    defb    $e                          ;DARKGRAY -> GRAY
    defb    $5                          ;LIGHTBLUE -> LIGHT BLUE
    defb    $3                          ;LIGHTGREEN -> LIGHT GREEN
    defb    $7                          ;LIGHTCYAN -> CYAN
    defb    $9                          ;LIGHTRED -> LIGHT RED
    defb    $d                          ;LIGHTMAGENTA -> MAGENTA
    defb    $a                          ;YELLOW -> DARK YELLOW
    defb    $f                          ;WHITE -> WHITE
ENDIF

