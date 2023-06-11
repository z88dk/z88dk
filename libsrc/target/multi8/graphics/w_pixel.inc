
    EXTERN  w_pixeladdress

    EXTERN  getmaxy
    EXTERN  getmaxx
    EXTERN  l_cmp
    EXTERN  __gfx_coords
    EXTERN  __multi8_ink
    EXTERN  __multi8_paper
    EXTERN  __gfx_fatpix

    EXTERN  __vram_in
    EXTERN  __vram_out

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    push    hl        ;save x
    call    getmaxy        ;hl = maxy
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc

    ex      de,hl        ;de = x, hl = y
    push    hl        ;save y
    call    getmaxx
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc
    ex      de,hl
    ld      (__gfx_coords),hl    ;x
    ld      (__gfx_coords+2),de    ;y
    push    bc
    call    w_pixeladdress
    ld      b,a
    ex      af,af
    ld      a,(__gfx_fatpix)
    and     a
    ld      c,@00000001
    jr      z,not_fatpix_rotate
    ld      c,@00000011
    res     0,b
not_fatpix_rotate:
    ex      af,af
    ld      a,c
    jr      z, rotated     ; pixel is at bit 0...
.plot_position    
    rlca
    djnz    plot_position
    ; a = byte holding pixel mask
    ; hl = address
rotated:
    ld      d,a         ;pixel to set
IF NEEDunplot|NEEDplot
    cpl
    ld      e,a         ;Save the pixel mask

IF NEEDplot
    ld      a,(__multi8_ink)
ELSE
    ld      a,(__multi8_paper)
ENDIF
    ld      c,a
    ld      a,(__vram_in)
    ld      b,a

    ; We need to flip in the planes we want and set the bit we want
    or      @00000110
    out     ($2a),a
    ld      a,(hl)
    and     e
    rrc     c
    jr      nc,noset_blue
    or      d
noset_blue:
    ld      (hl),a
    ld      a,b             ;Switch to green plane
    or      @00000011
    out     ($2a),a
    ld      a,(hl)
    and     e
    rrc     c
    jr      nc,noset_green
    or      d
noset_green:
    ld      (hl),a
    ld      a,b             ;Switch to red plane
    or      @00000101
    out     ($2a),a
    ld      a,(hl)
    and     e
    rrc     c
    jr      nc,noset_red
    or      d
noset_red:
    ld      (hl),a
ELIF NEEDxor
    ld      a,(__multi8_ink)

    ld      c,a
    ld      a,(__vram_in)
    ld      b,a

    ; We need to flip in the planes we want and set the bit we want
    or      @00000110
    out     ($2a),a
    ld      a,(hl)
    rrc     c
    jr      nc,noset_blue
    xor     d
noset_blue:
    ld      (hl),a
    ld      a,b             ;Switch to green plane
    or      @00000101
    out     ($2a),a
    ld      a,(hl)
    rrc     c
    jr      nc,noset_green
    xor     d
noset_green:
    ld      (hl),a
    ld      a,b             ;Switch to green plane
    or      @00000011
    out     ($2a),a
    ld      a,(hl)
    rrc     c
    jr      nc,noset_red
    xor     d
noset_red:
    ld      (hl),a
ELIF NEEDpoint
    ld      a,(__vram_in)
    ld      b,a
    or      @00000110
    out     ($2a),a
    ld      e,(hl)
    ld      a,b
    or      @00000101
    out    ($2a),a
    ld      a,(hl)
    or      e
    ld      e,a
    ld      a,b
    or      @00000011
    out    ($2a),a
    ld      a,(hl)
    or      e
    and     d        ;Bit to check
ENDIF
    ld      a,(__vram_out)
    out    ($2a),a
    pop    bc        ;Restore callers
    ret
