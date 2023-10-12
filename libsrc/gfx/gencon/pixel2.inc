
        INCLUDE "graphics/grafix.inc"

        EXTERN  generic_console_printc
        EXTERN  generic_console_plotc
        EXTERN  generic_console_vpeek
        EXTERN  generic_console_pointxy
        EXTERN  textpixl2
        EXTERN  getmaxy
        EXTERN  __console_w
        EXTERN  __console_h
        EXTERN  __gfx_fatpix
        EXTERN  __gfx_coords


        ld      a, (__console_w)
        dec     a
        cp      h
        ret     c

        ex      de, hl
        call    getmaxy                 ;l = max
        ld      a, l
        ex      de, hl
        cp      l
        ret     c

  IF    __CPU_GBZ80__
        ld      a, l
        ld      (__gfx_coords), a
        ld      a, h
        ld      (__gfx_coords+1), a
  ELIF  WIDE_GFX
        ex      de, hl
        ld      hl, __gfx_coords
        ld      (hl), d                 ;x
        inc     hl
        ld      (hl), 0
        inc     hl
        ld      (hl), e                 ;y
        inc     hl
        ld      (hl), 0
        ex      de, hl
  ELSE
        ld      (__gfx_coords), hl
  ENDIF
        push    bc                      ;save entry bc
        ld      c, h
        ld      b, l
        ld      a, (__gfx_fatpix)
        and     a
        jr      z, not_fatpix0
  IF    __CPU_INTEL__
        ld      a, l
        rra
        and     @01111111
        ld      b, a
  ELSE
        srl     b
  ENDIF
not_fatpix0:
        push    bc                      ;save reduced cooardinates
        push    hl                      ;save original coordinates
  IF    USEplotc
        call    generic_console_pointxy
  ELSE
        ld      e, 1                    ;raw mode
        call    generic_console_vpeek
  ENDIF
        ld      hl, textpixl2
        ld      e, 0
        ld      b, 4
ckmap:
        cp      (hl)
        jr      z, chfound
        inc     hl
        inc     e
        djnz    ckmap
        ld      e, 0
chfound:
        ld      b, e

        pop     hl                      ;original coordinates

        ld      a, (__gfx_fatpix)
        and     a
        ld      a, 3
        jr      z, not_fatpix
        ld      a, l
        rlca
        and     2
        jr      nz, not_fatpix
        inc     a
not_fatpix:

  IF    NEEDplot
        or      b
  ENDIF
  IF    NEEDunplot
        cpl
        and     b
  ENDIF
  IF    NEEDxor
        xor     b
  ENDIF
  IF    NEEDpoint
        and     b
        pop     bc
  ELSE
        ld      hl, textpixl2
        ld      d, 0
        ld      e, a
        add     hl, de
        ld      a, (hl)
        pop     bc                      ;reduced coordinates
    IF  USEplotc
        ld      d, a
        ld      e, 0                    ;pixel4 mode
        call    generic_console_plotc
    ELSE
        ld      d, a
        ld      e, 1                    ;raw mode
        call    generic_console_printc
    ENDIF
  ENDIF
        pop     bc
        ret
