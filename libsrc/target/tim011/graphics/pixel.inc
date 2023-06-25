
    EXTERN  w_pixeladdress
    EXTERN  __gfx_coords
    EXTERN  __tim011_ink
    EXTERN  __tim011_paper
    EXTERN  __gfx_fatpix
    EXTERN  l_cmp

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    ; This is wide
    ; hl = x
    ; de = y
    ld      a,d      ;Check y
    and     a
    ret     nz

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
    call    w_pixeladdress    ;hl = address, a = pixel number
    ld      b,a
IF NEEDunplot
    ld      a,(__tim011_paper)    ;paper
ELIF NEEDplot | NEEDxor
    ld      a,(__tim011_ink)
ENDIF
    ld      e,a
    ex      af,af
    ld      a,(__gfx_fatpix)
    and     a
    jr      z,not_fatpix
    ; We have fatpix here, so we only have two pixels in each byte
    ld      a,e
    rrca
    rrca
    or      e
    ld      e,a
    ex      af,af
    ld      a,b
    xor     3
    ld      a,e
    ld      e,@00001111
    jr      nz,rotate_done
    rrca
    rrca
    rrca
    rrca
    ld      e,@11110000
    jr      rotate_done
not_fatpix:
    ex      af,af
    ld      a,e
    ld      e,@00111111
    jr      z,rotate_done
rotate:
    rrc     e
    rrc     e
    rrca
    rrca
    djnz    rotate
rotate_done:
    ld      d,a         ;Pixel colour to use
    ld      bc,hl
IF NEEDplot|NEEDunplot
    in      a,(c)
    and     e
    or      d
    out     (c),a
ELIF NEEDxor
    in      a,(c)
    xor     d
    out     (c),a
ELIF NEEDpoint
    ld      a,e
    cpl
    ld      e,a
    in      a,(c)
    and     e
ENDIF    
    pop     bc    ;Restore callers
    ret
