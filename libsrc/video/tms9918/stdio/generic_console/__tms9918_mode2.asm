

SECTION code_video_vdp

PUBLIC __tms9918_mode2_printc

EXTERN  generic_console_font32
EXTERN  generic_console_udg32
EXTERN  generic_console_flags

EXTERN  __tms9918_attribute
EXTERN  __tms9918_scroll_buffer
EXTERN  FILVRM
EXTERN  LDIRVM

EXTERN  CONSOLE_XOFFSET
EXTERN  CONSOLE_YOFFSET


__tms9918_mode2_printc:
    ld      a,d
    ld      de,(generic_console_font32)
    dec     d
    bit     7,a
    jr      z,tms9918_printc_rejoin
    ld      de,(generic_console_udg32)
    res     7,a
tms9918_printc_rejoin:
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,de
    push	bc	;Save coordinates
    ld      a,(generic_console_flags)
    ld      b,a	;Save flags
    rlca
    sbc     a
    ld      c,a	;So c = 255/0 depending on inverse
    ld      de,__tms9918_scroll_buffer
    push    de	;Save buffer
    ld      a,8
copy_glyph:
    ex      af,af
    ld      a,(hl)
    bit     4,b
    jr      z,not_bold
    rrca
    or      (hl)
not_bold:
    xor     c	;Invert if necessary
    ld      (de),a
    inc     de
    inc     hl
    ex      af,af
    dec     a
    jr      nz,copy_glyph
    bit     3,b
    jr      z,not_underline
    dec     de
    dec     a
    ld      (de),a
not_underline:
    pop     hl	;Get buffer back
    pop     bc
    ld      a,c
    add     CONSOLE_XOFFSET
    add     a
    add     a
    add     a
    ld      e,a
    ld      a,CONSOLE_YOFFSET
    add     b
    ld      d,a         ;This assumes that the pattern generator is at 0
    push    de
    ld      bc,8
    call    LDIRVM
    pop     hl
    ; Now set the attributes
    ld      de,8192
    add     hl,de        
    ld      a,(__tms9918_attribute)
    ld      bc,8
    jp      FILVRM
