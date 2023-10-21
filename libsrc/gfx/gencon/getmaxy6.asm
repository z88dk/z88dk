
        SECTION code_clib
        PUBLIC  getmaxy

        EXTERN  __console_h

        PUBLIC  _getmaxy
        defc    _getmaxy=getmaxy

getmaxy:
        ld      a, (__console_h)
        ld      l, a
        add     a
        add     l
        dec     a
        ld      l, a
        ld      h, 0
        ret
