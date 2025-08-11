; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;

    MODULE  code_clib
    PUBLIC  super80_set_palette_mode
    PUBLIC  _super80_set_palette_mode
    PUBLIC  super80_set_palette_mode_fastcall
    PUBLIC  _super80_set_palette_mode_fastcall
    PUBLIC  conio_map_colour

    EXTERN  __CLIB_CONIO_NATIVE_COLOUR

super80_set_palette_mode:
_super80_set_palette_mode:
    pop     de
    pop     hl
    push    hl
    push    de
super80_set_palette_mode_fastcall:
_super80_set_palette_mode_fastcall:
    ld      a,(__super80_palette_mode)
    ld      e,a
    ld      d,0
    ld      a,l
    ld      (__super80_palette_mode),a
    ex      de,hl
    ret

conio_map_colour:
    ld      c, __CLIB_CONIO_NATIVE_COLOUR
    rr      c
    ret     c

    and     15
    ld      c, a
    ld      b, 0
    ld      hl, table_rgb
    ld      a,(__super80_palette_mode)
    and     a
    jr      z, get_mapped_colour
    ld      hl, table_composite
get_mapped_colour:
    add     hl, bc
    ld      a, (hl)
    ret

; Nibble        Composite       RGB
;0      Black   Black
;1      Grey    Black
;2      Blue    Blue
;3      L.Yellow        L.Blue
;4      Green   Green
;5      L.Magenta       Bright Green
;6      Cyan    Cyan
;7      L.Red   Turquoise
;8      Red     Dark Red
;9      Dark Cyan       Red
;A      Magenta Purple
;B      L.Green Magenta
;C      Yellow  Lime
;D      Dark Blue       Yellow
;E      White   Off White
;F      Black   Bright White

    SECTION data_clib

__super80_palette_mode: defb        0       ;0 = rgb, 1 = composite

; We'll go with the RGB table
    SECTION rodata_clib
table_rgb:
    defb    $0                          ;BLACK -> BLACK
    defb    $3                          ;BLUE -> LIGHT BLUE
    defb    $5                          ;GREEN -> BRIGHT GREEN
    defb    $7                          ;CYAN -> TURQOISE
    defb    $9                          ;RED -> RED
    defb    $b                          ;MAGENTA -> MAGENTA
    defb    $8                          ;BROWN -> DARK RED
    defb    $e                          ;LIGHTGRAY -> OFF WHITE
    defb    $e                          ;DARKGRAY -> OFF WHITE
    defb    $2                          ;LIGHTBLUE -> BLUE
    defb    $4                          ;LIGHTGREEN -> GREEN
    defb    $6                          ;LIGHTCYAN -> CYAN
    defb    $8                          ;LIGHTRED -> DARK RED
    defb    $a                          ;LIGHTMAGENTA -> PUROLE
    defb    $d                          ;YELLOW -> YELLOW
    defb    $f                          ;WHITE -> BRIGHT WHITE

table_composite:
    defb    $0                          ;BLACK -> BLACK
    defb    $2                          ;BLUE -> BLUE
    defb    $4                          ;GREEN -> GREEN
    defb    $6                          ;CYAN -> CYAN
    defb    $8                          ;RED -> RED
    defb    $a                          ;MAGENTA -> MAGENTA
    defb    $7                          ;BROWN -> LIGHT RED
    defb    $1                          ;LIGHTGRAY -> GREY
    defb    $1                          ;DARKGRAY -> GREY
    defb    $d                          ;LIGHTBLUE -> DARK BLUE
    defb    $b                          ;LIGHTGREEN -> LIGHT GREEN
    defb    $9                          ;LIGHTCYAN -> DARK CYAN
    defb    $7                          ;LIGHTRED -> LIGHT RED
    defb    $5                          ;LIGHTMAGENTA -> LIGHT MAGENTA
    defb    $c                          ;YELLOW -> YELLOW
    defb    $e                          ;WHITE -> WHITE

