
    EXTERN  pixeladdress_MODE4
    EXTERN  __gfx_coords
    EXTERN  __sam_MODE4_attr
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout
    EXTERN  l_cmp

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    ; Called via a w_ routine, so we enter with 16 bit coordinates
    ld      a,d      ;Check y 
    and     a
    ret     nz
    ld      a,e
    cp      192
    ret     nc

    ld      a,h      ;Check x
    and     a
    ret     nz
    ld      (__gfx_coords),hl       ;x
    ld      (__gfx_coords+2),de     ;y
    ; we want to get the coordinates into h=y, l =x
    ld      h,e
    push    bc    ;Save callers value
    call    __sam_graphics_pagein
    call    pixeladdress_MODE4    ;hl = address, a = pixel number
IF NEEDunplot
    ld      a,(__sam_MODE4_attr+1)    ;paper
ELIF NEEDplot | NEEDxor
    ld      a,(__sam_MODE4_attr)
ENDIF
    ld      c,@00001111
    jr      z,pixel_zero
    ld      c,@11110000
IF !NEEDpoint
    rrca
    rrca
    rrca
    rrca
    and     15
ENDIF
pixel_zero:
    ld      b,a            ;Attribute
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
