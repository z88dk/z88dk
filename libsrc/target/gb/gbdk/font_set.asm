    SECTION code_driver
    PUBLIC  font_set
    PUBLIC  _font_set
    EXTERN  asm_font_set



; font_t __LIB__	font_set( font_t font_handle ) NONBANKED;
_font_set:
font_set:
    push    bc
    ld      hl,sp+4
    LD      A,(HL+)          ; A = c
    ld      h,(hl)
    ld      l,a
    call    asm_font_set
    pop     bc
    ld      de,0		; Always good...
    ld      h,d
    ld      l,e
    RET