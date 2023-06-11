
    EXTERN  pixeladdress_MODE0
    EXTERN  __gfx_coords
    EXTERN  __cpc_ink0
    EXTERN  __cpc_paper0
    EXTERN  l_cmp

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    ; This is wide
    ; hl = x
    ; de = y
    ; y check performed before getting here

    ex      de,hl           ;de = x, hl = y
    push    hl              ;save y
    ld      hl,160          ;max x
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc
    ex      de,hl
    ld      (__gfx_coords),hl       ;x
    ld      (__gfx_coords+2),de     ;y
    push    bc    ;Save callers value
    call    pixeladdress_MODE0    ;hl = address, a = pixel number
    ld      b,a
IF NEEDunplot
    ld      a,(__cpc_paper0)      ;paper
ELIF NEEDplot | NEEDxor
    ld      a,(__cpc_ink0)
ENDIF
    ld      c,@01010101
    jr      z,rotate_done
    rrc     c
    and     a
    rrca
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
    pop     bc    ;Restore callers
    ret
