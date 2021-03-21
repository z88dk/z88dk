;
; Pixel operation for MODE0,1,2
;

    EXTERN  __gfx_coords
    EXTERN  pixeladdress_MODE0
    EXTERN  __set_zx_pixel_colour
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout
    

; We enter here with: hl = x, de = y
IF FORzxn | FORts2068 | FORsam
    ld      a,h
    and     a
    ret     nz
    ld      a,d
    and     a
    ret     nz
    ld      a,e
    cp      192
    ret     nc
    ld      (__gfx_coords),hl
    ld      (__gfx_coords+2),de

    ; Now get them into 8 bit parameters
    ld      h,l
    ld      l,e
ELSE
    ld      a,l
    cp      192
    ret     nc
    ld      (__gfx_coords),hl
ENDIF
    push    bc        ;Save callers
IF FORsam
    call    __sam_graphics_pagein
ENDIF
    call    pixeladdress_MODE0
    ld      b,a
    ld      a,1
    jr      z, continue    ; pixel is at bit 0...
.plot_position 
    rlca
    djnz    plot_position
continue:
    ; So here we have de=hl=screen location
    ; a = pixel mask
IF NEEDplot    
    or      (hl)
    ld      (hl),a
    call    __set_zx_pixel_colour
ENDIF
IF NEEDunplot
    cpl
    and     (hl)
    ld      (hl),a
    call    __set_zx_pixel_colour
ENDIF
IF NEEDxor
    xor     (hl)
    ld      (hl),a
    call    __set_zx_pixel_colour
ENDIF
IF NEEDpoint
    and     (hl)
ENDIF
IF FORsam
    call    __sam_graphics_pageout
ENDIF
    pop     bc    ;Restore callers
    ret


