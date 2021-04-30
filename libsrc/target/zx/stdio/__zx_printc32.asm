;
; Print a character for the ZX/TS2068 screen - 32 columns, fit in natural 8x8 character
;
; This is common code used by +zx, +ts2068, +zxn and +sam (MODE1)
;

    MODULE  __zx_printc32
    
    SECTION code_driver
    PUBLIC  __zx_printc32
    PUBLIC  __zx_handle_attributes
        
    EXTERN  __zx_32col_udgs
    EXTERN  __zx_32col_font
    EXTERN  generic_console_flags
    EXTERN  __zx_screenmode
    EXTERN  __zx_printc_attr
    EXTERN  __sam_graphics_pagein

    EXTERN  __zx_gencon_xy_to_dfaddr

__zx_printc32:
    call    __zx_gencon_xy_to_dfaddr    ; hl = screen address, d preserved
IF FORsam
    call    __sam_graphics_pagein
ENDIF
    ex      de,hl
    ld      bc,(__zx_32col_font)
    dec     b
    bit     7,h
    jr      z,handle_characters
    ld      bc,(__zx_32col_udgs)
    res     7,h
handle_characters:
    ld      l,h
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,bc
    ld      a,(generic_console_flags)
    rlca
    sbc     a,a        ; ; c = 0/ c = 255
    ld      c,a
    ld      b,8
print32_loop:
    ld      a,(generic_console_flags)
    bit     4,a
    ld      a,(hl)
    jr      z,no_32_bold
    rrca
    or      (hl)
no_32_bold:
    xor     c
    ld      (de),a
    inc     d
    inc     hl
    djnz    print32_loop
__zx_handle_attributes:
    dec     d
    ld      a,(generic_console_flags)
    bit     3,a
    jp      z,__zx_printc_attr
    ld      a,255
    ld      (de),a
    jp      __zx_printc_attr
