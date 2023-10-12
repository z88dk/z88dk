
        SECTION code_clib
        PUBLIC  getmaxy

        EXTERN  __console_h
        EXTERN  __gfx_fatpix

        PUBLIC  _getmaxy
        defc    _getmaxy=getmaxy

getmaxy:
  IF    __CPU_GBZ80__
        ld      hl, __console_h
        ld      l, (hl)
  ELSE
        ld      hl, (__console_h)
  ENDIF
        ld      h, 0
        ld      a, (__gfx_fatpix)
        and     a
        jr      z, skip_double
        add     hl, hl
skip_double:
        dec     hl
        ret
