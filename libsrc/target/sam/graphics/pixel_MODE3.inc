
    EXTERN  pixeladdress_MODE3
    EXTERN  __gfx_coords
    EXTERN  __sam_MODE3_attr
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout
    EXTERN  l_cmp

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    ; This is wide
    ; hl = x
    ; de = y
    ld      a,d      ;Check y
    and     a
    ret     nz
    ld      a,e
    cp      192
    ret     nc

    ex      de,hl           ;de = x, hl = y
    push    hl              ;save y
    ld      hl,512          ;max x
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc
    ex      de,hl
    ld      (__gfx_coords),hl       ;x
    ld      (__gfx_coords+2),de     ;y
    push    bc    ;Save callers value
    call    __sam_graphics_pagein
    call    pixeladdress_MODE3    ;hl = address, a = pixel number
    ld      b,a
IF NEEDunplot
    ld      a,(__sam_MODE3_attr+1)    ;paper
ELIF NEEDplot | NEEDxor
    ld      a,(__sam_MODE3_attr)
ENDIF
    ld      c,@00111111
    jr      z,rotate_done
rotate:
    rrc     c
    rrc     c
    and     a
    rrca
    rrca
    djnz    rotate
rotate_done:
    ld      b,a         ;Pixel colour to use

IF NEEDplot|NEEDunplot
    ld      a,(hl)
    and     c
    or      b
    ld      (hl),a
ELIF NEEDxor
    ld      a,(hl)
    xor     b
    ld      (hl),a
ELIF NEEDpoint
    ld      a,c
    cpl
    and     (hl)
ENDIF    
    call    __sam_graphics_pageout
    pop     bc    ;Restore callers
    ret
