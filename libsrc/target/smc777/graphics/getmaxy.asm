
        MODULE  smc777_getmaxy
        SECTION code_clib
        PUBLIC  getmaxy
        PUBLIC  _getmaxy
        EXTERN  __console_h
        EXTERN  __smc777_mode


    INCLUDE	"graphics/grafix.inc"

.getmaxy
._getmaxy
        ld      a,(__smc777_mode)
        and     @00001100
        cp      @00001000       ; 640
        ld      hl,199
        ret     z
        cp      @00000100       ; 320
        ld      hl,199
        ret     z
        ; We must be in lores mode here
        ld      a,(__console_h)
        add     a
        dec     a
        ld      l,a
        ld      h,0
	ret
