;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; VZ200/300 version
;
;
; $Id: putsprite.asm,v 1.8 2016-07-02 09:01:36 dom Exp $
;

    SECTION smc_clib
    PUBLIC  putsprite
    PUBLIC  _putsprite
    EXTERN  pixeladdress
    EXTERN  __mc6847_MODE2_attr
    EXTERN  __mc6847_mode
    EXTERN  __generic_putsprite

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


putsprite:
_putsprite:
    ld      a,(__mc6847_mode)
    cp      1
    jp      nz,__generic_putsprite
    push    ix                          ;save callers
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

    inc     hl

    inc     hl
    ld      a, (hl)                     ; and/or/xor mode
    ld      (ortype+1), a               ; Self modifying code
    ld      (ortype2+1), a              ; Self modifying code

    inc     hl
    ld      a, (hl)
    ld      (ortype), a                 ; Self modifying code
    ld      (ortype2), a                ; Self modifying code

    ld      h, d
    ld      l, e

    call    pixeladdress
    xor     3
    ld      b, a
    ld      c, a
    ld      a, (__mc6847_MODE2_attr)           ; pink up ink
attr_shift:
    rrca
    rrca
    djnz    attr_shift
    ld      (csmc+1), a
    ld      (cwsmc+1), a
    rlc     c
    ld      hl, offsets_table
    ld      b, 0
    add     hl, bc
    ld      a, (hl)
    ld      (wsmc1+1), a
    ld      (wsmc2+1), a
    ld      (_smc1+1), a
    ld      h, d
    ld      l, e

    ld      a, (ix+0)
    cp      9
    jr      nc, putspritew

    ld      d, (ix+0)
    ld      b, (ix+1)
_oloop:
    push    bc                          ;Save # of rows
    push    hl                          ;Save screen address
    ld      b, d                        ;Load width
    ld      c, (ix+2)                   ;Load one line of image
    inc     ix
csmc:
    ld      a, @11000000                ;colour
    ex      af, af
_smc1:
    ld      a, 1                        ;Load pixel mask
_iloop:
    sla     c                           ;Test leftmost pixel
    jr      nc, _noplot                 ;See if a plot is needed
    ex      af, af
    ld      e, a

ortype:
    nop                                 ; changed into nop / cpl
    nop                                 ; changed into and/or/xor (hl)
    ld      (hl), a
    ld      a, e
    ex      af, af
_noplot:
    rrca
    rrca
    jr      nc, _notedge                ;Test if edge of byte reached
    inc     hl                          ;Go to next byte
_notedge:
    ex      af, af                      ;Shift colir mask
    rrca
    rrca
    ex      af, af
    djnz    _iloop
    pop     hl                          ;Restore address
    ld      bc, 32                      ;Go to next line
    add     hl, bc
    pop     bc                          ;Restore data
    djnz    _oloop
    pop     ix                          ;restore callers
    ret


putspritew:
    ld      d, (ix+0)
    ld      b, (ix+1)
woloop:
    push    bc                          ;Save # of rows
    push    hl                          ;Save screen address
    ld      b, d                        ;Load width
    push    de
    ld      c, (ix+2)                   ;Load one line of image
    inc     ix
    ld      d, 2
cwsmc:
    ld      a, @11000000                ;colour
    ex      af, af
wsmc1:
    ld      a, 1
wiloop:
    sla     c                           ;Test leftmost pixel
    jr      nc, wnoplot                 ;See if a plot is needed
    ex      af, af
    ld      e, a

ortype2:
    nop                                 ; changed into nop / cpl
    nop                                 ; changed into and/or/xor (hl)
    ld      (hl), a
    ld      a, e
    ex      af, af
wnoplot:
    rrca
    rrca
    jr      nc, wnotedge                ;Test if edge of byte reached
    inc     hl                          ;Go to next byte
wnotedge:
    ex      af, af
    rrca
    rrca
    ex      af, af
wsmc2:
    cp      1
    jr      nz, nowover_1
    dec     d
    jr      z, wover_1
nowover_1:

    djnz    wiloop
    pop     de
    pop     hl                          ;Restore address
    ld      bc, 32                      ;Go to next line
    add     hl, bc
    pop     bc                          ;Restore data
    djnz    woloop
    pop     ix                          ;restore callers
    ret

wover_1:
    ld      c, (ix+2)
    inc     ix
    djnz    wiloop
    dec     ix
    pop     hl
    ld      bc, 32
    add     hl, bc
    pop     bc
    djnz    woloop
    pop     ix                          ;restore callers
    ret

    SECTION rodata_clib
offsets_table:
    defb    128, 64, 32, 16, 8, 4, 2, 1
