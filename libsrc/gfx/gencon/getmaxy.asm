
        SECTION code_clib
        PUBLIC  getmaxy

        EXTERN  __console_h

        PUBLIC  _getmaxy
        defc    _getmaxy=getmaxy

getmaxy:
        ld      a, (__console_h)
        add     a
        dec     a
        ld      l, a
        ld      h, 0
        ret
