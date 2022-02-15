
    EXTERN pixeladdress
    EXTERN w_pixeladdress
    EXTERN  getmaxy
    EXTERN  getmaxx
    EXTERN  l_cmp
    EXTERN __gfx_coords
    EXTERN  KRT_CLS_FILL
    EXTERN  KRT_PORT
    EXTERN  KRT_BANK_SELECTOR

    INCLUDE "graphics/grafix.inc"

; Generic code to handle the pixel commands
; Define NEEDxxx before including

IF maxx > 256
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
ELSE
    ld      (__gfx_coords),hl
    push    bc	;Save callers value
    call    pixeladdress		;hl = address, a = pixel number
ENDIF
    ld      b,a
    ld      a,1
    jr      z, rotated 	; pixel is at bit 0...
.plot_position	
    rlca
    djnz    plot_position
    ; a = byte holding pixel mask
    ; hl = address
rotated:
IF NEEDplot
    or      (hl)
    ld      (hl),a
ENDIF
IF NEEDunplot
    cpl
    and     (hl)
    ld      (hl),a
ENDIF
IF NEEDxor
    xor     (hl)
    ld      (hl),a
ENDIF
IF NEEDpoint
    ld      c,a
    ld      a,(hl)
    xor     KRT_CLS_FILL
    and     c
ENDIF
    push    af
    ld      a,KRT_BANK_SELECTOR
    out     (KRT_PORT),a
    pop     af
    pop     bc  ;Restore callers
    ret
