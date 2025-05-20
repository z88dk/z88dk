;
;
;     Generic graphics routines
;     Self modifying code version
;
;     Stefano Bodrato - 4/1/2007
;
;
;     Sprite Rendering Routine
;     original code by Patrick Davidson (TI 85)
;
;
;    $Id: putsprite_smc.asm$
;

    SECTION smc_clib

    PUBLIC  putsprite
    PUBLIC  _putsprite
    PUBLIC  ___putsprite

    EXTERN  swapgfxbk
    EXTERN  __graphics_end

    EXTERN  pixel


; __gfx_coords: h,l (vert-horz)
; sprite: (ix)

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

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
    push    de
    pop     ix
ELSE
    push    de
ENDIF

    inc     hl
    ld      e, (hl)
    inc     hl
    inc     hl
    ld      d, (hl)                     ; x and y __gfx_coords

    inc     hl

    inc     hl

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      a, (ix+0)                   ; Width
    push    af
    ld      b, (ix+1)                   ; Height
ELSE
    ex      (sp),hl
    inc     hl
    ld      a,(hl)                      ; Height
    ld      b,a
    inc     hl
    ld      (__spr_bitmap),hl
    dec     hl
    dec     hl
    ld      a,(hl)                      ; Width
    ex      (sp),hl
    push    af                          ; Width
ENDIF

    ld      a, (hl)                     ; and/or/xor mode

    ld      h, d
    ld      l, e

oloop:
    push    bc                          ;Save # of rows
    push    af

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      c, (ix+2)                   ;Load one line of image
ELSE
    push    hl
    ld      hl,(__spr_bitmap)
    ld      a,(hl)
    ld      c,a
	pop     hl
ENDIF
    ;ld    b,a    ;Load width
    ld      b, 0                        ; Better, start from zero !!

iloop:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    sla     c                           ;Test leftmost pixel
ELSE
    ld      a,c
    rla
    ld      c,a
ENDIF
    jr      nc, noplot                  ;See if a plot is needed

    pop     af
    push    af

    push    hl
    ;push    bc    ; this should be done by the called routine
    push    de
    ld      a, h
    add     a, b
    ld      h, a
    call    pixel
    pop     de
    ;pop    bc
    pop     hl

noplot:

    inc     b                           ; witdh counter

    pop     af
    push    af

    cp      b                           ; end of row ?

    jr      nz, noblk

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    inc     ix
    ld      c, (ix+2)                   ;Load one line of image
ELSE
    push    hl
    ld      hl,(__spr_bitmap)
    inc     hl
    ld      (__spr_bitmap),hl
    ld      a,(hl)
    pop     hl
    ld      c,a
ENDIF

    jr      noblock

noblk:

    ld      a, b                        ; next byte in row ?
    ;dec    a
    and     a
    jr      z, iloop
    and     7

    jr      nz, iloop

block:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    inc     ix
    ld      c, (ix+2)                   ;Load one line of image
ELSE
    push    hl
    ld      hl,(__spr_bitmap)
    inc     hl
    ld      (__spr_bitmap),hl
    ld      a,(hl)
    pop     hl
    ld      c,a
ENDIF
    jr      iloop

noblock:

    inc     l

    pop     af
    pop     bc                          ;Restore data
    djnz    oloop
  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF


IF  !__CPU_INTEL__&!__CPU_GBZ80__

; Z80 doesn't has index registers

ELSE

    SECTION bss_graphics

__spr_bitmap:
    defw    0

ENDIF
