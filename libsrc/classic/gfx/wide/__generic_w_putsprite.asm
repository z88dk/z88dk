;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; Sept 2003 - Stefano: Fixed bug for sprites wider than 8.
; Apr 2017  - Stefano: Fixed bug for sprite pos coordinates wider than 255.
; July 2026 - Stefano: 8080 and gbz80 CPU compatibility
;
; Much More Generic version
; Uses plotpixel, respixel and xorpixel
;
;
; $Id: __generic_w_putsprite.asm $
;

    SECTION code_graphics

    MODULE  __generic_w_putsprite
    PUBLIC  __generic_putsprite

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out
    EXTERN  __graphics_end

    EXTERN  w_plotpixel
    EXTERN  w_respixel
    EXTERN  w_xorpixel


; __gfx_coords: h,l (vert-horz)
; sprite: (ix)

__generic_putsprite:
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
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

;    push    de
;    pop     ix

    inc     hl
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ld      c, (hl)
    inc     hl
    ld      b, (hl)                     ; x and y __gfx_coords
    ld      (oldx), bc

    inc     hl
    ld      a, (hl)                     ; and/or/xor mode


    cp      166                         ; and(hl) opcode
    jr      z, doand

    cp      182                         ; or(hl) opcode
    jp      z, door

    ; 182 - or
    ; 174 - xor

;--------------------------------------
doxor:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      a, (ix+0)                   ; Width
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
ENDIF
oloopx:
    push    bc                          ;Save # of rows
    push    af

    ld      hl, (oldx)                  ;;

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

    push    hl
    push    bc
    push    de
    call    w_xorpixel
    pop     de
    pop     bc
    pop     hl

noplotx:

    inc     b                           ; witdh counter
    inc     hl                          ;;

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

    ;pop hl
    ;inc    l
    inc     de

    pop     af
    pop     bc                          ;Restore data
    djnz    oloopx

  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_out
  ENDIF

  IF    _GFX_PAGE_VRAM
   IF __CPU_INTEL__ | __CPU_GBZ80__
    pop     de
   ENDIF
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ELSE
    pop     de
    ENDIF
    ret
  ENDIF



;--------------------------------------
doand:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      a, (ix+0)                   ; Width
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
ENDIF
oloopa:
    push    bc                          ;Save # of rows
    push    af

    ld      hl, (oldx)                  ;;

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

    push    hl
    push    bc
    push    de
    call    w_respixel
    pop     de
    pop     bc
    pop     hl

noplota:

    inc     b                           ; witdh counter
    inc     hl                          ;;

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

    ;pop hl
    ;inc    l
    inc     de

    pop     af
    pop     bc                          ;Restore data
    djnz    oloopa

  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_out
  ENDIF

  IF    _GFX_PAGE_VRAM
   IF __CPU_INTEL__ | __CPU_GBZ80__
    pop     de
   ENDIF
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ELSE
    pop     de
    ENDIF
    ret
  ENDIF



;--------------------------------------
door:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      a, (ix+0)                   ; Width
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
ENDIF
oloopo:
    push    bc                          ;Save # of rows
    push    af

    ld      hl, (oldx)                  ;;

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

    push    hl
    push    bc
    push    de
    call    w_plotpixel
    pop     de
    pop     bc
    pop     hl

noploto:

    inc     b                           ; witdh counter
    inc     hl                          ;;

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

    ;pop hl
    ;inc    l
    inc     de

    pop     af
    pop     bc                          ;Restore data
    djnz    oloopo

  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_out
  ENDIF

  IF    _GFX_PAGE_VRAM
   IF __CPU_INTEL__ | __CPU_GBZ80__
    pop     de
   ENDIF
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ELSE
    pop     de
    ENDIF
    ret
  ENDIF


    SECTION bss_graphics

IF  !__CPU_INTEL__&!__CPU_GBZ80__

; Z80 has got index registers

ELSE

__spr_bitmap:
    defw    0

ENDIF

oldx:
    defw    0

