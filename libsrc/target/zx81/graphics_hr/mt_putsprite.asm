;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; ZX81 - Memotech WRX mode version
;
;
; $Id: mt_putsprite.asm  $
;


IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION smc_clib
    PUBLIC  putsprite
    PUBLIC  _putsprite
    PUBLIC  ___putsprite
    EXTERN  pixeladdress
    EXTERN  swapgfxbk
    EXTERN  __graphics_end

    INCLUDE "classic/gfx/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)




putsprite:
_putsprite:
___putsprite:
    push    ix
    ld      hl, 4
    add     hl, sp
    ld      e, (hl)
    inc     hl
    ld      d, (hl)                     ; sprite address
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

  IF    NEED_swapgfxbk=1
    call    swapgfxbk
  ENDIF
    call    pixeladdress

    ld      hl, offsets_table
    ld      c, a
    ld      b, 0
    add     hl, bc
    ld      a, (hl)
    ld      (wsmc1+1), a
    ld      (wsmc2+1), a
    ld      (_smc1+1), a
    ld      h, d
    ld      l, e
    ld      (rowadr+1), hl              ; save current coordinates
    ld      (rowadr2+1), hl              ; save current coordinates
    ld      (rowadr3+1), hl              ; save current coordinates

    ld      a, (ix+0)
    cp      9
    jr      nc, putspritew

    ld      d, (ix+0)
    ld      b, (ix+1)
_oloop:
    push    bc                          ;Save # of rows
    ld      b, d                        ;Load width
    ld      c, (ix+2)                   ;Load one line of image
    inc     ix
_smc1:
    ld      a, 1                        ;Load pixel mask
_iloop:
    sla     c                           ;Test leftmost pixel
    jr      nc, _noplot                 ;See if a plot is needed
    ld      e, a

ortype:
    nop                                 ; changed into nop / cpl
    nop                                 ; changed into and/or/xor (hl)
    cp      0x76
    jr      nz,_no_halt
    ld      a,0x56
_no_halt:
    ld      (hl), a
    ld      a, e
_noplot:
IF BITS_reversed = 1
    rlca
ELSE
    rrca
ENDIF
    jr      nc, _notedge                ;Test if edge of byte reached
    inc     hl                          ;Go to next byte
_notedge:
    djnz    _iloop

    ; ---------
    push    de
rowadr:
    ld      hl,0
    ld      de,33
    add     hl,de
    ld      (rowadr+1), hl
    pop     de
    ; ---------

    pop     bc                          ;Restore data
    djnz    _oloop
  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

putspritew:
    ld      d, (ix+0)
    ld      b, (ix+1)
woloop:
    push    bc                          ;Save # of rows
    ld      b, d                        ;Load width
    ld      c, (ix+2)                   ;Load one line of image
    inc     ix
wsmc1:
    ld      a, 1                        ;Load pixel mask
wiloop:
    sla     c                           ;Test leftmost pixel
    jr      nc, wnoplot                 ;See if a plot is needed
    ld      e, a

ortype2:
    nop                                 ; changed into nop / cpl
    nop                                 ; changed into and/or/xor (hl)
    cp      0x76
    jr      nz,no_halt
    ld      a,0x56
no_halt:
    ld      (hl), a
    ld      a, e
wnoplot:
IF BITS_reversed = 1
    rlca
ELSE
    rrca
ENDIF
    jr      nc, wnotedge                ;Test if edge of byte reached
    inc     hl                          ;Go to next byte
wnotedge:
wsmc2:
    cp      1
    jr      z, wover_1

    djnz    wiloop

    ; ---------
    push    de
rowadr2:
    ld      hl,0
    ld      de,33
    add     hl,de
    ld      (rowadr2+1), hl
    pop     de
    ; ---------

    pop     bc                          ;Restore data
    djnz    woloop
  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

wover_1:
    ld      c, (ix+2)
    inc     ix
    djnz    wiloop
    dec     ix

    ; ---------
    push    de
rowadr3:
    ld      hl,0
    ld      de,33
    add     hl,de
    ld      (rowadr3+1), hl
    pop     de
    ; ---------

    pop     bc
    djnz    woloop
  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF


    SECTION rodata_clib

offsets_table:
    defb    1, 2, 4, 8, 16, 32, 64, 128
ENDIF
