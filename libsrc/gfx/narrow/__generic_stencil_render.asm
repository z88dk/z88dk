;
;    z88dk GFX library
;    Render the "stencil" - plot/unplot based version.
;     Stefano - Jul 2017
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

        INCLUDE "graphics/grafix.inc"

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  __generic_stencil_render
        EXTERN  dither_pattern

        EXTERN  plotpixel, respixel
        EXTERN  __gfx_coords

        EXTERN  swapgfxbk
        EXTERN  __graphics_end

;
;    $Id: stencil_render2.asm - Stefano Exp, 2017 $
;

__generic_stencil_render:
        push    ix
        ld      ix, 4
        add     ix, sp

    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF
    ;ld    bc,__graphics_end
    ;push bc

        ld      c, maxy%256
        ld      hl, (__gfx_coords)
        push    hl
        push    bc

yloop:
        pop     bc
        dec     c
    ;jp    z,swapgfxbk1
        jr      nz, noret
        pop     hl
        ld      (__gfx_coords), hl
    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
      IF    !__CPU_INTEL__&!__CPU_GBZ80__
        pop     ix
      ENDIF
        ret
    ENDIF
noret:
        push    bc

        ld      d, 0
        ld      e, c

        ld      l, (ix+2)               ; stencil
        ld      h, (ix+3)
        add     hl, de
        ld      a, (hl)                 ;X1

    IF  maxy<>256
        ld      e, maxy
        add     hl, de
    ELSE
        ld      e, 0
        inc     h
    ENDIF
        cp      (hl)                    ; if x1>x2, return
        jr      nc, yloop

       ; C still holds Y
        push    af                      ; X1
        ld      a, (hl)
        ld      b, a                    ; X2

        ld      a, (ix+0)               ; intensity
        call    dither_pattern
    ;ld    (pattern2+1),a
        ld      e, a

        pop     af                      ; X1
        ld      d, a                    ; X1

    ; adjust horizontal pattern position for the current line
        and     7
pattern_shift:
        rrc     e                       ; shifted pattern
        dec     a
        jr      nz, pattern_shift

        ld      a, b                    ; X2
        sub     d                       ; X2-X1 = line lenght in pixels
        ld      b, d                    ; X1
        ld      d, a
        inc     d


        ld      l, c                    ; Y
xloop:
    ;;;ld    h,a    ; X1
        rrc     e                       ; shifted pattern
        push    hl
        push    de
        push    bc
    ;push    af

        ld      h, b                    ; X1
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

  ENDIF
