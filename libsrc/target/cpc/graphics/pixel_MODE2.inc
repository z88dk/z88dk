
    EXTERN  pixeladdress_MODE2
    EXTERN  __gfx_coords
    EXTERN  __gfx_fatpix
    EXTERN  l_cmp

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    ; This is wide
    ; hl = x
    ; de = y
    ; y check performed before getting here


    ld      a,(__gfx_fatpix)
    and     a
    jr      z,not_fatpix_x
    add     hl,hl
not_fatpix_x:
    ex      de,hl           ;de = x, hl = y
    push    hl              ;save y
    ld      hl,640          ;max x
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc
    ex      de,hl
    ld      (__gfx_coords),hl       ;x
    ld      (__gfx_coords+2),de     ;y
    push    bc    ;Save callers value
    call    pixeladdress_MODE2    ;hl = address, a = pixel number
    ld      b,a
    ex      af,af
    ld      a,(__gfx_fatpix)
    ld      c,@00000001
    jr      z,not_fatpix_rotate
    ld      c,@00000011
    res     0,b
not_fatpix_rotate:
    ex      af,af
    ld      a,c
    jr      z,rotated
plot_position:
    rlca
    djnz    plot_position
rotated:
    ld      c,(hl)
IF NEEDplot
    or      c
    ld      (hl),a
ELIF NEEDunplot
    cpl
    and     c
    ld      (hl),a
ELIF NEEDxor
    xor     c
    ld      (hl),a
ELIF NEEDpoint
    and     c
ENDIF
    pop     bc    ;restore Callers
    ret

