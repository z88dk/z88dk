; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;

    MODULE  code_clib
    PUBLIC  conio_map_colour

    PUBLIC  eg2000_switch_palette_mode
    PUBLIC  _eg2000_switch_palette_mode

    EXTERN  __CLIB_CONIO_NATIVE_COLOUR


conio_map_colour:
    ld      c, __CLIB_CONIO_NATIVE_COLOUR
    rr      c
    ret     c

    and     15
    ld      c, a
    ld      b, 0
    ld      a,(__eg2000_palette_mode)
    dec     a
    ld      hl, table2
    jr      z,domap
    ld      hl,table
domap:
    add     hl, bc
    ld      a, (hl)
    ret


eg2000_switch_palette_mode:
_eg2000_switch_palette_mode:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    ld      (__eg2000_palette_mode),a
    ret

    SECTION bss_clib

    PUBLIC  __eg2000_palette_mode

__eg2000_palette_mode:    defb    0           ;0 = europe/ 1 = nz/southern

    SECTION rodata_clib
; European/northern colours:
;const rgb_t cgenie_state::m_palette_eu[] =
;{
;0        rgb_t(0x5e, 0x5e, 0x5e), // gray
;1        rgb_t(0x11, 0xff, 0xea), // cyan
;2        rgb_t(0xff, 0x00, 0x5e), // red
;3        rgb_t(0xea, 0xea, 0xea), // white
;4        rgb_t(0xff, 0xf9, 0x00), // yellow
;5        rgb_t(0x6e, 0xff, 0x00), // green
;6        rgb_t(0xff, 0x52, 0x00), // orange
;7        rgb_t(0xea, 0xff, 0x00), // light yellow
;8        rgb_t(0x02, 0x48, 0xff), // blue
;9        rgb_t(0x8e, 0xd4, 0xff), // light blue
;10       rgb_t(0xff, 0x12, 0xff), // pink
;11       rgb_t(0x88, 0x43, 0xff), // purple
;12       rgb_t(0x8c, 0x8c, 0x8c), // light gray
;13       rgb_t(0x00, 0xfb, 0x8c), // turquoise
;14       rgb_t(0xd2, 0x00, 0xff), // magenta
;15       rgb_t::white()           // bright white
;};

table:
    defb    $0                          ;BLACK -> GREY
    defb    $8                          ;BLUE -> BLUE
    defb    $5                          ;GREEN -> GREEN
    defb    $1                          ;CYAN -> CYAN
    defb    $2                          ;RED -> RED
    defb    $e                          ;MAGENTA -> MAGENTA
    defb    $6                          ;BROWN -> ORANGE
    defb    $3                          ;LIGHTGRAY -> WHITE
    defb    $c                          ;DARKGRAY -> LIGHT GREY
    defb    $9                          ;LIGHTBLUE -> LIGHT BLUE
    defb    $7                          ;LIGHTGREEN -> LIGHT YELLOW
    defb    $d                          ;LIGHTCYAN -> TURQUOISE
    defb    $a                          ;LIGHTRED -> PINK
    defb    $b                          ;LIGHTMAGENTA -> PURPLE
    defb    $4                          ;YELLOW -> YELLOW
    defb    $f                          ;WHITE -> BRIGHT WHITE

; "Southern/NZ?" colours
; 0     rgb_t::white,
; 1     rgb_t(0x12, 0xff, 0xff),    cyan1
; 2     rgb_t(0xff, 0x6f, 0xff),    light magenta
; 3     rgb_t(0x31, 0x77, 0xff),    light blue
; 4     rgb_t(0xff, 0xcb, 0x00),    ochre/orange/brown
; 5     rgb_t(0x6e, 0xff, 0x00),    light green
; 6     rgb_t(0xff, 0x52, 0x00),    light red
; 7     rgb_t(0x5e, 0x5e, 0x5e),    grey
; 8     rgb_t(0xea, 0xea, 0xea),    light grey
; 9     rgb_t(0x00, 0xff, 0xdd),    cyan 2
; 10    rgb_t(0xd2, 0x00, 0xff),    magenta
; 11    rgb_t(0x02, 0x48, 0xff),    blue
; 12    rgb_t(0xff, 0xf9, 0x00),    yellow
; 13    rgb_t(0x00, 0xda, 0x00),    green
; 14    rgb_t(0xff, 0x22, 0x00),    red
; 15    rgb_t::black


table2:
    defb    $f                          ;BLACK -> BLACK
    defb    $b                          ;BLUE -> BLUE
    defb    $d                          ;GREEN -> GREEN
    defb    $1                          ;CYAN -> CYAN1
    defb    $e                          ;RED -> RED
    defb    $a                          ;MAGENTA -> MAGENTA
    defb    $4                          ;BROWN -> ORANGE
    defb    $8                          ;LIGHTGRAY -> light grey
    defb    $7                          ;DARKGRAY -> grey
    defb    $3                          ;LIGHTBLUE -> LIGHT BLUE
    defb    $5                          ;LIGHTGREEN -> LIGHT GREEN
    defb    $9                          ;LIGHTCYAN -> CYAN2
    defb    $3                          ;LIGHTRED -> LIGHT RED
    defb    $2                          ;LIGHTMAGENTA -> LIGHT MAGENTA
    defb    $c                          ;YELLOW -> YELLOW
    defb    $0                          ;WHITE -> BRIGHT WHITE
