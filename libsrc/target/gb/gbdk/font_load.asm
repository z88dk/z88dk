    SECTION code_driver
    PUBLIC  font_load
    PUBLIC  _font_load
    EXTERN  asm_font_load


; font_t __LIB__	font_load( void *font ) NONBANKED;
_font_load:
font_load:
    push    bc
    ld      hl,sp+4
    LD      A,(HL+)          ; A = c
    ld      h,(hl)
    ld      l,a
    call    asm_font_load
    ld      d,h		;Return in de AND hl
    ld      e,l
    pop     bc
    RET