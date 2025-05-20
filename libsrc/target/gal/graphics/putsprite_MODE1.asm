;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; Gal+ version
;
;
; $Id: putsprite.asm,v 1.4 2016-07-02 09:01:36 dom Exp $
;

    SECTION smc_clib
    PUBLIC  putsprite_MODE1
    EXTERN  pixeladdress_MODE1

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


putsprite_MODE1:
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
    ld      c, (hl)                     ; and/or/xor mode
    inc     hl
    ld      b,(hl)                      ;cpl/nop
    ; We need to swap the operations around
    ld      a,c
    cp      174                         ;xor
    jr      z,modify
    cp      182
    jr      nz,not_or
    ld      bc,166+47*256               ; CPL - AND (HL)
    jr      modify
not_or:
    ld      bc,182                      ; OR (HL)
modify:
    ld      a,c     
    ld      (ortype+1), a               ; Self modifying code
    ld      (ortype2+1), a              ; Self modifying code

    ld      a, b
    ld      (ortype), a                 ; Self modifying code
    ld      (ortype2), a                ; Self modifying code

    ld      h, d
    ld      l, e

    call    pixeladdress_MODE1
    ex      de,hl
    ld      hl, offsets_table
    ld      c, a
    ld      b, 0
    add     hl, bc
    ld      a, (hl)
    ld      (wsmc1+1), a
    ld      (wsmc2+1), a
    ld      (_smc1+1), a
    ex      de,hl


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
_smc1:
    ld      a, 1                        ;Load pixel mask
_iloop:
    sla     c                           ;Test leftmost pixel
    jr      nc, _noplot                 ;See if a plot is needed
    ld      e, a
  ;  cpl
ortype:
    nop                                 ; changed into nop / cpl
    nop                                 ; changed into and/or/xor (hl)
    ld      (hl), a
    ld      a, e
_noplot:
    rlca
    jr      nc, _notedge                ;Test if edge of byte reached
    inc     hl                          ;Go to next byte
_notedge:
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
    ld      c, (ix+2)                   ;Load one line of image
    inc     ix
wsmc1:
    ld      a, 1
wiloop:
    sla     c                           ;Test leftmost pixel
    jr      nc, wnoplot                 ;See if a plot is needed
    ld      e, a

 ;   cpl
ortype2:
    nop                                 ; changed into nop / cpl
    nop                                 ; changed into and/or/xor (hl)
    ld      (hl), a
    ld      a, e
wnoplot:
    rlca
    jr      nc, wnotedge                ;Test if edge of byte reached
    inc     hl                          ;Go to next byte
wnotedge:
wsmc2:
    cp      1
    jr      z, wover_1
nowover_1:
    djnz    wiloop

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
    defb    1,2,4,8,16,32,64,128
    