
    SECTION code_driver

    PUBLIC  wrtchr
    PUBLIC  _wrtchr

    GLOBAL  __mode
    GLOBAL  __console_x
    GLOBAL  asm_wrtchr
    GLOBAL  asm_adv_curs
    GLOBAL  gmode

    GLOBAL  generic_console_font32
    GLOBAL  generic_console_udg32

    INCLUDE "target/gb/def/gb_globals.def"


; void __LIB__    wrtchr(char chr);
wrtchr:
_wrtchr:                        ; Banked
    PUSH    BC

    LD      A,(__mode)
    CP      G_MODE
    CALL    NZ,gmode

    ld      hl,__console_x
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    push    bc      ;save coordinates

    LD      HL,sp+4
    LD      a,(HL)		;character
    ; We support:
    ; generic_console_font32:	- 0 based font
    ; generic_consoel_udg32:	- for udgs
try_gencon_fonts:
    cp      128
    jr      c,not_udg
    sub     128
    ld      c,a
    ; UDGs are just there with no header
    ld      hl,generic_console_udg32
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
    jr      do_print
not_udg:
    ld      c,a
    ld      hl,generic_console_font32
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
    ld      a,(hl+)	;Font type
    inc     hl	;Skips to the start of encoding table if present
    and     3
    ld      de,128
    cp      FONT_128ENCODING
    jr      z,add_offset
    ld      de,0
    cp      FONT_NOENCODING
    jr      z,add_offset
    ld      d,1
add_offset:
    add     hl,de
do_print:
    ; hl = font
    ; c = character
    ld      a,c
    pop     bc

    CALL    asm_wrtchr
    CALL    asm_adv_curs

    POP     BC
    RET

