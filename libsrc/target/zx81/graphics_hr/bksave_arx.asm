;
;    Fast background save
;
;    ZX81 ARX HRG version
;
;    $Id: bksave_arx.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION smc_clib
    PUBLIC  bksave
    PUBLIC  _bksave
    PUBLIC  ___bksave
    EXTERN  pixeladdress


bksave:
_bksave:
___bksave:
    push    ix
    ld      hl, 4
    add     hl, sp
    ld      e, (hl)
    inc     hl
    ld      d, (hl)                     ;sprite address
    push    de
    pop     ix

    inc     hl
    ld      e, (hl)
    inc     hl
    inc     hl
    ld      d, (hl)                     ; x and y __gfx_coords

    ld      h, d                        ; current x coordinate
    ld      l, e                        ; current y coordinate

    ld      (ix+2), h
    ld      (ix+3), l

    push    hl
    call    pixeladdress
    pop     hl

    ld      a, (ix+0)
    ld      b, (ix+1)

    dec     a
    srl     a
    srl     a
    srl     a
    inc     a
    inc     a                           ; INT ((Xsize-1)/8+2)
    ld      (rbytes+1), a

bksaves:
    push    bc

rbytes:
    ld      b, 0

    push    hl
    ex      de,hl
    ld      de,8
rloop:
    ld      a, (hl)
    ld      (ix+4), a
    add     hl,de
    inc     ix
    djnz    rloop
    pop     hl

    inc     l
    push    hl
    call    pixeladdress
    pop     hl

    pop     bc

    djnz    bksaves
    pop     ix
    ret
ENDIF
