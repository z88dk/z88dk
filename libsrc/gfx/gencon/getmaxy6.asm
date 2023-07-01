
    SECTION code_clib
    PUBLIC  getmaxy

    EXTERN  __console_h

    PUBLIC  _getmaxy
    PUBLIC  ___getmaxy
    defc    _getmaxy = getmaxy
    defc    ___getmaxy = getmaxy

getmaxy:
    ld      a,(__console_h)
    ld      l,a
    add     a
    add     l
    dec     a
    ld      l,a
    ld      h,0
    ret
