
    EXTERN  w_pixeladdress
    EXTERN  __gfx_coords
    EXTERN  l_cmp
    EXTERN  __aquarius_video_pagein
    EXTERN  __aquarius_video_pageout
    EXTERN  __aquarius_set_attribute

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    ; This is wide
    ; hl = x
    ; de = y
    ld      a,d      ;Check y
    and     a
    ret     nz
    ld      a,e
    cp      200
;    ret     nc

    ex      de,hl           ;de = x, hl = y
    push    hl              ;save y
    ld      hl,320          ;max x
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc
    ex      de,hl
    ld      (__gfx_coords),hl       ;x
    ld      (__gfx_coords+2),de     ;y
    push    bc    ;Save callers value
    call    __aquarius_video_pagein
    ld      hl,(__gfx_coords)       ;x
    call    w_pixeladdress    ;hl = address, a = pixel number
    ld      d,b		      ;keep it safe
    ld      b,a
    ld      a,1
    jr      z, rotated      ; pixel is at bit 0...
.plot_position
    rlca
    djnz    plot_position
    ; a = byte holding pixel mask
    ; hl = address
rotated:
IF NEEDplot
    or      (hl)
    ld      (hl),a
    ld      b,d
    call    __aquarius_set_attribute
ELIF NEEDunplot
    cpl
    and     (hl)
    ld      (hl),a
    ld      b,d
    call    __aquarius_set_attribute
ELIF NEEDxor
    xor     (hl)
    ld      (hl),a
    ld      b,d
    call    __aquarius_set_attribute
ELIF NEEDpoint
    and     (hl)
ENDIF    
    ex      af,af
    call    __aquarius_video_pageout
    ex      af,af
    pop     bc    ;Restore callers
    ret
