;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; PC6001 version
;
;
; $Id: putsprite.asm,v 1.4 2016-07-02 09:01:36 dom Exp $
;


    INCLUDE "classic/video/mc6847/mc6847.inc"


IFNDEF MC6847_IOSPACE


    SECTION smc_clib
    PUBLIC  putsprite
    PUBLIC  _putsprite
    EXTERN  cpygraph
    EXTERN  pixeladdress
    EXTERN  __generic_putsprite
    EXTERN  __mc6847_mode
    EXTERN  __mc6847_modeval

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
    ex      de,hl
    call    pixeladdress
    xor     7
    and     7
IFNDEF FORmc1000
    ld      de,hl
ENDIF

    ld      hl, offsets_table
    ld      c, a
    ld      b, 0
    add     hl, bc
    ld      a, (hl)
    ld      (wsmc1+1), a
    ld      (wsmc2+1), a
    ld      (_smc1+1), a
    ex      de,hl

IF FORmc1000
    ld      a,(__mc6847_modeval)
    ex      af,af
ENDIF

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

IF FORmc1000
    ex      af,af
    res     0,a
    out     ($80),a
    ex      af,af
ENDIF

ortype:
    nop                                 ; changed into nop / cpl
    nop                                 ; changed into and/or/xor (hl)
    ld      (hl), a
IF FORmc1000
    ex      af,af
    set     0,a
    out     ($80),a
    ex      af,af
ENDIF
    ld      a, e
_noplot:
    rrca
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

IF FORmc1000
    ex      af,af
    res     0,a
    out     ($80),a
    ex      af,af
ENDIF

ortype2:
    nop                                 ; changed into nop / cpl
    nop                                 ; changed into and/or/xor (hl)
    ld      (hl), a
IF FORmc1000
    ex      af,af
    set     0,a
    out     ($80),a
    ex      af,af
ENDIF
    ld      a, e
wnoplot:
    rrca
    jr      nc, wnotedge                ;Test if edge of byte reached
    inc     hl                          ;Go to next byte
wnotedge:
wsmc2:
    cp      1
    jr      z, wover_1
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
    defb    128, 64, 32, 16, 8, 4, 2, 1

ENDIF