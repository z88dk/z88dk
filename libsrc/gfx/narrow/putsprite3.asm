;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; Sept 2003 - Stefano: Fixed bug for sprites wider than 8.
;
; Much More Generic version
; Uses plotpixel, respixel and xorpixel
;
; ** putsprite3 is a thin version with a Self Modifying Code trick **
;
;
; $Id: putsprite3.asm $
;


    SECTION smc_clib

    PUBLIC  putsprite
    PUBLIC  _putsprite
    PUBLIC  ___putsprite

    EXTERN  swapgfxbk
    EXTERN  __graphics_end

    EXTERN  plotpixel
    EXTERN  respixel
    EXTERN  xorpixel
    INCLUDE "graphics/grafix.inc"

; __gfx_coords: h,l (vert-horz)
; sprite: (__spr_bitmap+1)

putsprite:
_putsprite:
___putsprite:
  IF    NEED_swapgfxbk=1
    call    swapgfxbk
  ENDIF
    ld      hl, 2
    add     hl, sp
    ld      e, (hl)
    inc     hl
    ld      d, (hl)                     ;sprite address

    push    de

    inc     hl
    ld      e, (hl)
    inc     hl
    inc     hl
    ld      d, (hl)                     ; x and y __gfx_coords

    inc     hl

    inc     hl

    ld      a, (hl)                     ; and/or/xor mode

    cp      166                         ; and(hl) opcode
    jr      nz, nodoand
    ld      hl, respixel
    jr      doxor
nodoand:

    cp      182                         ; or(hl) opcode
    jr      nz, nodoor
    ld      hl, plotpixel
    jr      doxor

    ; 182 - or
    ; 174 - xor

nodoor:
    ld      hl, xorpixel

doxor:
    ld      (called+1), hl

    pop     hl
    ld      a,(hl)                      ; Width
    push    af                          ; Width
    inc     hl
    ld      a,(hl)                      ; Height
    ld      b,a
    inc     hl
    ld      (__spr_bitmap+1),hl

    ld      h, d
    ld      l, e

oloopx:
    push    bc                          ;Save # of rows
    push    af

    push    hl
    ld      hl,(__spr_bitmap+1)
    ld      a,(hl)
    pop     hl
    ld      c,a

    ;ld    b,a    ;Load width
    ld      b, 0                        ; Better, start from zero !!

iloopx:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    sla     c                           ;Test leftmost pixel
ELSE
    ld      a,c
    rla
    ld      c,a
ENDIF
    jr      nc, noplotx                 ;See if a plot is needed

    push    hl
    ;push    bc    ; this should be done by the called routine
    push    de
    ld      a, h
    add     a, b
    ld      h, a
called:
    call    xorpixel
    pop     de
    ;pop    bc
    pop     hl

noplotx:

    inc     b                           ; witdh counter

    pop     af
    push    af

    cp      b                           ; end of row ?

    jr      nz, noblkx

    push    hl
.__spr_bitmap
    ld      hl,0
    inc     hl
    ld      (__spr_bitmap+1),hl
    ld      a,(hl)
    pop     hl
    ld      c,a

    jr      noblockx

noblkx:

    ld      a, b                        ; next byte in row ?
    ;dec    a
    and     a
    jr      z, iloopx
    and     7

    jr      nz, iloopx

blockx:
    push    hl
    ld      hl,(__spr_bitmap+1)
    inc     hl
    ld      (__spr_bitmap+1),hl
    ld      a,(hl)
    pop     hl
    ld      c,a

    jr      iloopx

noblockx:

    inc     l

    pop     af
    pop     bc                          ;Restore data
    djnz    oloopx
  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    ret
  ENDIF

