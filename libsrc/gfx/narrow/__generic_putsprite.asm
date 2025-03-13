;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; Sept 2003 - Stefano: Fixed bug for sprites wider than 8.
; March 2025 - Stefano: 8080 and gbz80 CPU compatibility
;
; Much More Generic version
; Uses plotpixel, respixel and xorpixel
;
;


    SECTION code_graphics
    PUBLIC  __generic_putsprite

    EXTERN  swapgfxbk
    EXTERN  __graphics_end

    EXTERN  plotpixel
    EXTERN  respixel
    EXTERN  xorpixel
    INCLUDE "graphics/grafix.inc"

; __gfx_coords: h,l (vert-horz)
; sprite: (ix)

__generic_putsprite:
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

    cp      166                         ; and(hl) opcode
    jr      z, doand

    cp      182                         ; or(hl) opcode
    jp      z, door

    ; 182 - or
    ; 174 - xor

doxor:
    pop     af                   ; Width

oloopx:
    push    bc                          ;Save # of rows
    push    af

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      c, (ix+2)                   ;Load one line of image
ELSE
    push    hl
    ld      hl,(__spr_bitmap)
    ld      a,(hl)
    pop     hl
    ld      c,a
ENDIF
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

    pop     af
    push    af

    push    hl
    ;push    bc    ; this should be done by the called routine
    push    de
    ld      a, h
    add     a, b
    ld      h, a
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

    jr      noblockx

noblkx:

    ld      a, b                        ; next byte in row ?
    ;dec    a
    and     a
    jr      z, iloopx
    and     7

    jr      nz, iloopx

blockx:
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
    jr      iloopx

noblockx:

    inc     l

    pop     af
    pop     bc                          ;Restore data
    djnz    oloopx

  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF


doand:
    pop     af                   ; Width

oloopa:
    push    bc                          ;Save # of rows
    push    af

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      c, (ix+2)                   ;Load one line of image
ELSE
    push    hl
    ld      hl,(__spr_bitmap)
    ld      a,(hl)
    pop     hl
    ld      c,a
ENDIF
    ;ld    b,a    ;Load width
    ld      b, 0                        ; Better, start from zero !!

iloopa:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    sla     c                           ;Test leftmost pixel
ELSE
    ld      a,c
    rla
    ld      c,a
ENDIF
    jr      nc, noplota                 ;See if a plot is needed

    pop     af
    push    af

    push    hl
    ;push    bc    ; this should be done by the called routine
    push    de
    ld      a, h
    add     a, b
    ld      h, a
    call    respixel
    pop     de
    ;pop    bc
    pop     hl

noplota:

    inc     b                           ; witdh counter

    pop     af
    push    af

    cp      b                           ; end of row ?

    jr      nz, noblka

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

    jr      noblocka

noblka:

    ld      a, b                        ; next byte in row ?
    ;dec    a
    and     a
    jr      z, iloopa
    and     7

    jr      nz, iloopa

blocka:
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
    jr      iloopa

noblocka:

    inc     l
    pop     af
    pop     bc                          ;Restore data
    djnz    oloopa

  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF




door:
    pop     af                   ; Width

oloopo:
    push    bc                          ;Save # of rows
    push    af

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      c, (ix+2)                   ;Load one line of image
ELSE
    push    hl
    ld      hl,(__spr_bitmap)
    ld      a,(hl)
    pop     hl
    ld      c,a
ENDIF
    ;ld    b,a    ;Load width
    ld      b, 0                        ; Better, start from zero !!

iloopo:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    sla     c                           ;Test leftmost pixel
ELSE
    ld      a,c
    rla
    ld      c,a
ENDIF
    jr      nc, noploto                 ;See if a plot is needed

    pop     af
    push    af

    push    hl
    ;push    bc    ; this should be done by the called routine
    push    de
    ld      a, h
    add     a, b
    ld      h, a
    call    plotpixel
    pop     de
    ;pop    bc
    pop     hl

noploto:

    inc     b                           ; witdh counter

    pop     af
    push    af

    cp      b                           ; end of row ?

    jr      nz, noblko

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

    jr      noblocko

noblko:

    ld      a, b                        ; next byte in row ?
    ;dec    a
    and     a
    jr      z, iloopo
    and     7

    jr      nz, iloopo

blocko:
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
    jr      iloopo

noblocko:

    ;djnz    iloopo
    inc     l
    pop     af
    pop     bc                          ;Restore data
    djnz    oloopo

  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF


IF  !__CPU_INTEL__&!__CPU_GBZ80__

; Z80 has got index registers

ELSE

    SECTION bss_graphics

__spr_bitmap:
    defw    0

ENDIF
