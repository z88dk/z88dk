
        SECTION code_clib
        PUBLIC  getmaxx

        EXTERN  __console_w

        PUBLIC  _getmaxx
        defc    _getmaxx=getmaxx

getmaxx:
  IF    __CPU_GBZ80__
        ld      hl, __console_w
        ld      l, (hl)
  ELSE
        ld      hl, (__console_w)
  ENDIF
        ld      h, 0
        dec     hl
        ret
