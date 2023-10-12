
        SECTION code_clib
        PUBLIC  getmaxy

        EXTERN  __console_h

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
        dec     hl
        ret
