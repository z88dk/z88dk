	INCLUDE	"graphics/grafix.inc"


        MODULE    fp1100_getmaxx
        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
        EXTERN	  __fp1100_mode
        EXTERN    __console_w

.getmaxx
._getmaxx
    ld      a,(__fp1100_mode)
    bit     1,a
    jr      z,hires_graphics
    ld      a,(__console_w)
    add     a
    dec     a
    ld      l,a
    ld      h,0
    ret


hires_graphics:
    ld      hl,319
    and     a
    ret     z
    ld      hl,639
	ret
