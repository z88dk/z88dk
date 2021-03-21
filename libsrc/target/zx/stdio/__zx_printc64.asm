;
; Print a character for the ZX/TS2068 screen - 64 columns, 2 characters in 8x8 character
;
; This is common code used by +zx, +ts2068, +zxn and +sam (MODE1)
;

    MODULE  __zx_printc64
    
    SECTION code_driver
    PUBLIC  __zx_printc64
        
    EXTERN  __zx_handle_attributes
    EXTERN  __zx_64col_font
    EXTERN  generic_console_flags


    EXTERN  __zx_gencon_xy_to_dfaddr
    EXTERN  __sam_graphics_pagein



__zx_printc64:
    srl     c    ; divide by 2
    ex      af,af    ; save the lowest bit
    call    __zx_gencon_xy_to_dfaddr
    ex      de,hl    ; de = screen address
    ex      af,af
    ld      a,0x0f
    jr      c,not_even_column
    ld      a,0xf0
not_even_column:
IF FORsam
    call    __sam_graphics_pagein
ENDIF
    ; h = character
    ; de = screen address
    ; a = screen mask
    ld      l,h
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    ld      bc,(__zx_64col_font)
    dec     b
    add     hl,bc
    ld      b,8
    ld      c,a
    ex      de,hl
print64_loop:
    ld      a,c
    cpl
    and     (hl)
    ld      (hl),a
    ld      a,(generic_console_flags)
    rlca
    ld      a,(de)
    jr      nc,print64_noinverse
    cpl
print64_noinverse:
    and     c
    or      (hl)
    ld      (hl),a
    inc     h
    inc     de
    djnz    print64_loop
    ex      de,hl
    jp      __zx_handle_attributes
