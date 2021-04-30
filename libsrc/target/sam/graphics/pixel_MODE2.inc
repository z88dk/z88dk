
    EXTERN  pixeladdress_MODE2
    EXTERN  __gfx_coords
    EXTERN  l_cmp
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout

    INCLUDE "graphics/grafix.inc"

    EXTERN  __zx_console_attr

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    ; Called via a w_ routine, so we enter with 16 bit coordinates
    ld      a,d
    and     a
    ret     nz
    ld      a,e
    cp      192
    ret     nc

    ld      a,h
    and     a
    ret     nz
    ld      (__gfx_coords),hl       ;x
    ld      (__gfx_coords+2),de     ;y
    ; we want to get the coordinates into h=y, l =x
    ld      h,e

    push    bc    ;Save callers value
    call    __sam_graphics_pagein
    call    pixeladdress_MODE2    ;hl = address, a = pixel number
    ld      b,a
    ld      a,@10000000
    jr      z, rotated     ; pixel is at bit 0...
.plot_position    
    rrca
    djnz    plot_position
rotated:
    ld      b,a        ;the pixel mask
    cpl
    ld      c,a        ;the excluded mask
    ; c = byte holding mask exlcuding this pixel
    ; b = pixel to set
    ; hl = address
    ld      a,(hl)
IF NEEDplot
    and     c
    or      b
    ld      (hl),a
ENDIF
IF NEEDunplot
    and     c
    ld      (hl),a
ENDIF
IF NEEDxor
    xor     b
    ld      (hl),a
ENDIF
IF NEEDpoint
    and     b
ELSE
    set     5,h
    ld      a,(__zx_console_attr)
    ld      (hl),a
ENDIF
    call    __sam_graphics_pageout
    pop     bc        ;Restore callers
    ret
