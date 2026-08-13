;
;    Fast background save
;
;    Generic version (just a bit slow)
;
;    $Id: bkrestore3.asm $
;

    SECTION code_clib


    EXTERN  plotpixel
    EXTERN  respixel

    PUBLIC  bkrestore
    PUBLIC  _bkrestore
    PUBLIC  bkrestore_fastcall
    PUBLIC  _bkrestore_fastcall

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out
    INCLUDE "classic/gfx/grafix.inc"

bkrestore:
_bkrestore:
    pop     de
    pop     hl
    push    hl
    push    de

bkrestore_fastcall:
_bkrestore_fastcall:

    ; __FASTCALL__ !!   HL = sprite address

  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
ENDIF
    inc     hl                          ; skip first X xs
    inc     hl                          ; skip first Y ys

    ld      d, (hl)                     ; x pos
    inc     hl
    ld      e, (hl)                     ; Y pos
    inc     hl

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    hl                          ; sprite addr
    pop     ix

    ld      h, d  ; X
    ld      l, e  ; Y

    ld      a, (ix+0)                   ; Width
    ld      b, (ix+1)                   ; Height
ELSE
    ld      a, (hl)                     ; Width
    inc     hl
    push    af
    ld      a, (hl)                     ; Height
    ld      b, a
    inc     hl
    pop     af
    push    hl                          ; sprite data addr

    ld      h, d  ; X
    ld      l, e  ; Y
ENDIF

oloopx:
IF  __CPU_INTEL__|__CPU_GBZ80__
    ex      (sp),hl
ENDIF
    push    bc                          ;Save # of rows
    push    af

    ;ld    b,a    ;Load width
    ld      b, 0                        ; Better, start from zero !!

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      c, (ix+2)                   ;Load one line of image
ELSE
    ld      a, (hl)                   ;Load one line of image
    ld      c,a
ENDIF

iloopx:

    push    hl
    ;push    bc    ; this should be done by the called routine
    push    de
    ld      a, h
    add     a, b
    ld      h, a
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    sla     c                           ;Test leftmost pixel
ELSE
    ld      a,c
    rla
ENDIF
    push    af
    call    nc, respixel
    pop     af
    call    c, plotpixel
    pop     de
    ;pop    bc
    pop     hl

    inc     b                           ; witdh counter

    pop     af
    push    af

    cp      b                           ; end of row ?

    jr      nz, noblkx

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    inc     ix
ELSE
    inc     hl
ENDIF
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      c, (ix+2)                   ;Load next byte of image
ELSE
    ld      a, (hl)
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
ELSE
    inc     hl
ENDIF
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      c, (ix+2)                   ;Load next byte of image
ELSE
    ld      a, (hl)
    ld      c,a
ENDIF
    jr      iloopx

noblockx:

    pop     af
    pop     bc                          ;Restore data

IF  __CPU_INTEL__|__CPU_GBZ80__
    ex      (sp),hl
ENDIF
    inc     l
    djnz    oloopx

  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_out
  ENDIF

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
ELSE
    pop     hl
ENDIF

    ret


