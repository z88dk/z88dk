;
;    z88dk GFX library
;    Render the "stencil" - plot/unplot based version.
;     Stefano - Jul 2017, June 2026
;
;    Render the "stencil".
;    The dithered horizontal lines base their pattern on the Y coordinate
;    and on an 'intensity' parameter (0..11).
;    Basic concept by Rafael de Oliveira Jannone
;
;    Machine code version by Stefano Bodrato, 22/4/2009
;
;    stencil_render(unsigned char *stencil, unsigned char intensity)
;

    INCLUDE "classic/gfx/grafix.inc"

    SECTION code_graphics

    PUBLIC  __generic_stencil_render
    EXTERN  dither_pattern

    EXTERN  plotpixel, respixel
    EXTERN  __gfx_coords

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

;
;    $Id: __generic_stencil_render.asm $
;

__generic_stencil_render:

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix                          ;save callers
    ld      ix, 4
    add     ix, sp
ELSE
    ld      hl,2
    add     hl, sp
    ld      a,(hl)
    ld      (smc1),a
    inc     hl
    inc     hl
    ld      hl,(hl)
    ld      (smc2),hl
ENDIF

  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    ;ld    bc,__graphics_end
    ;push bc

    ld      c, _GFX_MAXY%256
    ld      hl, (__gfx_coords)
    push    hl
    push    bc

yloop:
    pop     bc
    dec     c
    ;jp    z,__gfx_vram_page_out
    jr      nz, noret
    pop     hl
    ld      (__gfx_coords), hl
  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF

noret:
    push    bc

    ld      d, 0
    ld      e, c

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      l, (ix+2)                   ; stencil
    ld      h, (ix+3)
ELSE
    ld      hl,(smc2)
ENDIF

    add     hl, de
    ld      a, (hl)                     ;X1

  IF    _GFX_MAXY<>256
    ld      e, _GFX_MAXY
    add     hl, de
  ELSE
    ld      e, 0
    inc     h
  ENDIF
    cp      (hl)                        ; if x1>x2, return
    jr      nc, yloop

       ; C still holds Y
    push    af                          ; X1
    ld      a, (hl)
    ld      b, a                        ; X2

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      a, (ix+0)                   ; intensity
ELSE
    ld      a, (smc1)
ENDIF

    call    dither_pattern
    ;ld    (pattern2+1),a
    ld      e, a

    pop     af                          ; X1
    ld      d, a                        ; X1

    ; adjust horizontal pattern position for the current line
    and     7
pattern_shift:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    rrc     e                           ; shifted pattern
ELSE
    push    af
    ld      a,e
    rrca
    ld      e,a
    pop     af
ENDIF
    dec     a
    jr      nz, pattern_shift

    ld      a, b                        ; X2
    sub     d                           ; X2-X1 = line lenght in pixels
    ld      b, d                        ; X1
    ld      d, a
    inc     d


    ld      l, c                        ; Y
xloop:
    ;;;ld    h,a    ; X1
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    rrc     e                           ; shifted pattern
ELSE
    push    af
    ld      a,e
    rrca
    ld      e,a
    pop     af
ENDIF
    push    hl
    push    de
    push    bc
    ;push    af

    ld      h, b                        ; X1
    ld      l, c
    jr      nc, do_unplot
    call    plotpixel
    jr      done
do_unplot:
    call    respixel
done:
    ;pop    af
    pop     bc
    pop     de
    pop     hl
    inc     b
    dec     d
    jr      nz, xloop

    jr      yloop


    SECTION bss_graphics

IF  !__CPU_INTEL__&!__CPU_GBZ80__

; Z80 has got index registers

ELSE

smc1:
    defb    0

smc2:
    defw    0

ENDIF
