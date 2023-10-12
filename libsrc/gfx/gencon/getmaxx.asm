
        SECTION code_clib
        PUBLIC  getmaxx

        EXTERN  __console_w

        PUBLIC  _getmaxx
        defc    _getmaxx=getmaxx

getmaxx:
        ld      a, (__console_w)
        add     a
        dec     a
        ld      l, a
        ld      h, 0
        ret
